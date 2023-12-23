import express from "express";

import { commentOnPost, createPost, getUserPosts, deletePost, getPosts, likeAndUnlikePost, updatePost, getCategories, removeAllCategories, addCategory, getComments } from "../controllers/postControllers.js";
import { isAuthenticatedUser } from "../middlewares/auth.js";

const postRouter = express.Router();

postRouter.route("/post/upload").post(isAuthenticatedUser, createPost);

postRouter
    .route("/post/:id")
    .get(isAuthenticatedUser, likeAndUnlikePost)
    .put(isAuthenticatedUser, updatePost)
    .delete(isAuthenticatedUser, deletePost);

postRouter.route("/all").get(isAuthenticatedUser, getPosts);

postRouter.route("/user/posts").get(isAuthenticatedUser, getUserPosts);

postRouter
    .route("/post/comment/:id")
    .put(isAuthenticatedUser, commentOnPost)

postRouter.route("/comments/:id").get(isAuthenticatedUser, getComments);

postRouter.route("/category").get(getCategories).delete(removeAllCategories);
postRouter.post("/category/:id", addCategory);

export { postRouter };