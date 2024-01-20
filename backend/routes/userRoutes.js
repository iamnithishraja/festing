import express from "express";
import { login, register, getUserDetails, forgotPassword, resetPassword, updatePassword, sendRequest, acceptRequest, rejectRequest, getAllUsers, logout, updateProfile, getOtherUsersDetails } from "../controllers/userController.js"
import { isAuthenticatedUser } from "../middlewares/auth.js";
import catchAsync from "../utils/catchAsync.js";

const userRouter = express.Router();

userRouter.route("/login").post(catchAsync(login));
userRouter.route("/register").post(register);//its in try and catch blocks, so no async error handler
userRouter.route("/logout").get(catchAsync(logout));
userRouter.get("/getotheruserdetails/:id", isAuthenticatedUser, catchAsync(getOtherUsersDetails));
userRouter.route("/me").get(isAuthenticatedUser, catchAsync(getUserDetails))
                        .put(isAuthenticatedUser, catchAsync(updateProfile));
userRouter.post("/password/forgotpassword", catchAsync(forgotPassword));
userRouter.put("/password/reset/:token", catchAsync(resetPassword));
userRouter.put("/password/update", isAuthenticatedUser, catchAsync(updatePassword));

userRouter.route("/request").post(isAuthenticatedUser, catchAsync(sendRequest))
        .put(isAuthenticatedUser, catchAsync(acceptRequest))
        .delete(isAuthenticatedUser, catchAsync(rejectRequest));

userRouter.route("/all").get(isAuthenticatedUser, catchAsync(getAllUsers));

export { userRouter };