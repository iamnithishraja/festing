import express from "express";
import catchAsync from "../utils/catchAsync.js";
import { commentOnPost, createPost, getUserPosts, deletePost, getPosts, likeAndUnlikePost, updatePost, getCategories, removeAllCategories, addCategory, getComments } from "../controllers/postControllers.js";
import { isAuthenticatedUser } from "../middlewares/auth.js";

const postRouter = express.Router();

postRouter.route("/post/upload").post(isAuthenticatedUser, catchAsync(createPost));

postRouter
    .route("/post/:id")
    .get(isAuthenticatedUser, catchAsync(likeAndUnlikePost))
    .put(isAuthenticatedUser, catchAsync(updatePost))
    .delete(isAuthenticatedUser, catchAsync(deletePost));

postRouter.route("/all").get(isAuthenticatedUser, catchAsync(getPosts));

postRouter.route("/user/posts").get(isAuthenticatedUser, catchAsync(getUserPosts));

postRouter
    .route("/post/comment/:id")
    .put(isAuthenticatedUser, catchAsync(commentOnPost))

postRouter.route("/comments/:id").get(isAuthenticatedUser, catchAsync(getComments));

postRouter.route("/category").get(catchAsync(getCategories)).delete(catchAsync(removeAllCategories));
postRouter.post("/category/:id", catchAsync(addCategory));

export { postRouter };