import cloudinary from "cloudinary";
import Post from "../models/postModel.js";
import ApiFeatures from "../utils/apiFeatures.js";
;
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
    try {
        const newPost = { caption: req.body.caption };
        newPost.image = await uploadImage(req.files.image.data, req.body.category);
        newPost.owner = req.user.id;
        await Post.create(newPost);
        res.json({ success: true });
    } catch (error) {
        console.log(error);
        res.json({ success: false, message: error.message });
    }
}

async function likeAndUnlikePost(req, res, next) {
    try {
        res.json({ success: true });
    } catch (error) {
        console.log(error);
        res.json({ success: false });
    }
}

async function getUserPosts(req, res, next) {
    try {
        const toSerch = req.query.id ? req.query.id : req.user.id;
        const tempPosts = Post.find({ owner: toSerch }).sort({ createdAt: -1 });
        const apiFeatures = new ApiFeatures(tempPosts, req.query).pagination(4);
        const posts = await apiFeatures.query;
        const reqPosts = [];
        for (let i = 0; i < posts.length; i++) {
            const post = posts[i];
            reqPosts.push({ _id: post._id, image: post.image.url, numLikes: post.likes.length, numComments: post.comments.length, caption: post.caption });
        }
        res.json({ success: true, posts: [...reqPosts] });
    } catch (error) {
        console.log(error);
        res.json({ success: false });
    }
}

async function deletePost(req, res, next) {
    try {

        res.json({ success: true });
    } catch (error) {
        console.log(error);
        res.json({ success: false });
    }
}

async function getFeedPosts(req, res, next) {
    try {
        res.json({ posts });
    } catch (error) {
        console.log(error);
        res.json({ success: false });
    }
}

async function updatePost(req, res, next) {
    try {

        res.json({ success: true });
    } catch (error) {
        console.log(error);
        res.json({ success: false });
    }
}

async function commentOnPost(req, res, next) {
    try {
        res.json({ success: true });
    } catch (error) {
        console.log(error);
        res.json({ success: false });
    }
}

async function deleteComment(req, res, next) {
    try {

        res.json({ success: true });
    } catch (error) {
        console.log(error);
        res.json({ success: false });
    }
}
let categories = ["others"];
async function getCategories(req, res, next) {
    res.json({ success: true, categories });
}

async function addCategory(req, res, next) {
    categories.push(req.params.id);
    res.json({ success: true, categories });
}

async function removeAllCategories(req, res, next) {
    categories = ["others"];
    res.json({ success: true, categories });
}

export { commentOnPost, createPost, deleteComment, deletePost, getFeedPosts as getPosts, likeAndUnlikePost, updatePost, getUserPosts, getCategories, addCategory, removeAllCategories };