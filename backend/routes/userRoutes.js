import express from "express";
import { login, register, getUserDetails, forgotPassword, resetPassword, updatePassword, sendRequest, acceptRequest, rejectRequest, getAllUsers, logout, updateProfile, getOtherUsersDetails } from "../controllers/userController.js"
import { isAuthenticatedUser } from "../middlewares/auth.js";

const userRouter = express.Router();

userRouter.route("/login").post(login);
userRouter.route("/register").post(register);
userRouter.route("/logout").get(logout);
userRouter.get("/getotheruserdetails/:id", isAuthenticatedUser, getOtherUsersDetails);
userRouter.route("/me").get(isAuthenticatedUser, getUserDetails).put(isAuthenticatedUser, updateProfile);
userRouter.post("/password/forgotpassword", forgotPassword);
userRouter.put("/password/reset/:token", resetPassword);
userRouter.put("/password/update", isAuthenticatedUser, updatePassword);

userRouter.route("/request").post(isAuthenticatedUser, sendRequest)
        .put(isAuthenticatedUser, acceptRequest).delete(isAuthenticatedUser, rejectRequest);


userRouter.route("/all").get(isAuthenticatedUser, getAllUsers);

export { userRouter };