async function createPost(req, res, next) {
    try {
        res.json({ success: true });
    } catch (error) {
        console.log(error);
        res.json({ success: false });
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
        Post(req.params.id);
        res.json({ success: true });
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