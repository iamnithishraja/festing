import express from "express";
import { login, register, getUserDetails, fergotPassword, resetPassword, updatePassword, sendRequest, acceptRequest, rejectRequest, getAllUsers, logout, updateProfile } from "../controllers/userController.js"
import { isAuthenticatedUser } from "../middlewares/auth.js";

const userRouter = express.Router();

userRouter.route("/login").post(login);
userRouter.route("/register").post(register);
userRouter.route("/logout").get(logout);
userRouter.route("/me").get(isAuthenticatedUser, getUserDetails).put(isAuthenticatedUser, updateProfile);
userRouter.post("/password/fergotpassword", fergotPassword);
userRouter.put("/password/reset/:token", resetPassword);
userRouter.put("/password/update", isAuthenticatedUser, updatePassword);

userRouter.route("/request").post(isAuthenticatedUser, sendRequest)
        .put(isAuthenticatedUser, acceptRequest).delete(isAuthenticatedUser, rejectRequest);


userRouter.route("/all").get(isAuthenticatedUser, getAllUsers);

export { userRouter };