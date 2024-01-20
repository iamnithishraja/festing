import cloudinary from "cloudinary";
import Post from "../models/postModel.js";
import ApiFeatures from "../utils/apiFeatures.js";
import Category from "../models/categoryModel.js";
import User from "../models/userModel.js";

async function uploadImage(image, folder_name) {
    return new Promise((resolve, reject) => {
        const upload_stream = cloudinary.v2.uploader.upload_stream({
            resource_type: "image",
            width: 1920,
            quality: "auto",
            folder: folder_name,
        }, (error, uploadResult) => {
            if (error) {
                reject(error);
            } else {
                resolve(uploadResult);
            }
        });

        upload_stream.end(image);
    }).then((uploadResult) => {
        return {
            public_id: uploadResult.public_id,
            url: uploadResult.secure_url
        };
    }).catch((error) => {
        throw new Error(`Error uploading image: ${error.message}`);
    });
}

async function createPost(req, res, next) {
        const newPost = { caption: req.body.caption };
        newPost.image = await uploadImage(req.files.image.data, req.body.category);
        newPost.owner = req.user.id;
        await Post.create(newPost);
        res.json({ success: true });
}

async function likeAndUnlikePost(req, res, next) {
        const post = await Post.findById(req.params.id);

        if (!post) {
            return res.json({
                success: false,
                message: "Post not found",
            });
        }

        if (post.likes.includes(req.user._id)) {
            const index = post.likes.indexOf(req.user._id);

            post.likes.splice(index, 1);

            await post.save();

            return res.json({
                success: true,
                message: "Post Unliked",
            });
        } else {
            post.likes.push(req.user._id);

            await post.save();

            return res.json({
                success: true,
                message: "Post Liked",
            });
        }
}

async function getUserPosts(req, res, next) {
        const toSerch = req.query.id ? req.query.id : req.user.id;
        const tempPosts = Post.find({ owner: toSerch }).sort({ createdAt: -1 });
        const apiFeatures = new ApiFeatures(tempPosts, req.query).pagination(4);
        const posts = await apiFeatures.query;
        const reqPosts = [];
        for (let i = 0; i < posts.length; i++) {
            const post = posts[i];
            reqPosts.push({ _id: post._id, image: post.image.url, numLikes: post.likes.length, numComments: post.comments.length, caption: post.caption, isLiked: post.likes.includes(req.user._id) });
        }
        res.json({ success: true, posts: [...reqPosts] });
}

async function deletePost(req, res, next) {
        const post = await Post.findById(req.params.id);

        if (!post) {
            return res.json({
                success: false,
                message: "Post not found",
            });
        }

        if (post.owner.toString() !== req.user._id.toString()) {
            return res.json({
                success: false,
                message: "Unauthorized",
            });
        }
        await cloudinary.v2.uploader.destroy(post.image.public_id);

        await Post.findOneAndDelete({ _id: post.id });
        res.json({
            success: true,
            message: "Post deleted",
        });
}

async function getFeedPosts(req, res, next) {
        const tempPosts = Post.find().sort({ createdAt: -1 }).populate("owner");
        const apiFeatures = new ApiFeatures(tempPosts, req.query).pagination(10);
        const posts = await apiFeatures.query;
        const reqPosts = [];
        for (let i = 0; i < posts.length; i++) {
            const post = posts[i];
            reqPosts.push({ _id: post._id, image: post.image.url, numLikes: post.likes.length, numComments: post.comments.length, caption: post.caption, owner: post.owner._id, dp: post.owner.avatar.url, name: post.owner.name, rollno: post.owner.rollno, isLiked: post.likes.includes(req.user._id) });
        }
        res.json({ success: true, posts: [...reqPosts] });
}

async function getComments(req, res, next) {
        const post = await Post.findById(req.params.id).populate("comments.user");
        const comments = [];

        post.comments.forEach(comment => {
            comments.push({
                username: comment.user.name,
                comment: comment.comment,
                dp: comment.user.avatar.url
            });
        });

        res.json({ success: true, comments });
}

async function updatePost(req, res, next) {
        res.json({ success: true });
}

async function commentOnPost(req, res, next) {
        const post = await Post.findById(req.params.id);

        if (!post) {
            return res.json({
                success: false,
                message: "Post not found",
            });
        }

        let commentIndex = -1;
        post.comments.forEach((item, index) => {
            if (item.user.toString() === req.user._id.toString()) {
                commentIndex = index;
            }
        });
        if (commentIndex !== -1) {
            post.comments[commentIndex].comment = req.body.comment;

            await post.save();

            return res.json({
                success: true,
                message: "Comment Updated",
            });
        } else {
            post.comments.push({
                user: req.user._id,
                comment: req.body.comment,
            });

            await post.save();
            return res.json({
                success: true,
                message: "Comment added",
            });
        }
}

async function getCategories(req, res, next) {
        const Allcategories = await Category.findOne({});
        if(!Allcategories){
            const newCategoryObj = new Category({categories:["others"]});
            await newCategoryObj.save();
            res.json({ success: true, categories:newCategoryObj.categories});
        }
        else{
            res.json({ success: true, categories:Allcategories.categories});
        }
}

async function addCategory(req, res, next) {
        const {id} = req.params;
        const Allcategories = await Category.findOne({});
        if(!Allcategories){
            const newCategoryObj = new Category({categories:["others",id]});
            await newCategoryObj.save();
            res.json({ success: true, categories:newCategoryObj.categories});
        }
        else{
            Allcategories.categories.push(`${id}`);
            await Allcategories.save();
            res.json({ success: true, categories:Allcategories.categories});
        }
}

async function removeAllCategories(req, res, next) {
        await Category.findOneAndDelete({});
        const newCategoryObj = new Category({categories:["others"]});
        await newCategoryObj.save();
        res.json({ success: true, categories:newCategoryObj.categories});
}

export { commentOnPost, createPost, deletePost, getFeedPosts as getPosts, likeAndUnlikePost, updatePost, getUserPosts, getCategories, addCategory, removeAllCategories, getComments };