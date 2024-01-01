import dotenv from "dotenv";
dotenv.config({ path: "/backend/config/.env" });
import sendEmail from "../utils/sendEmail.js"
import User from "../models/userModel.js";
import crypto from "crypto"
import Order from "../models/orderModel.js";
import cloudinary from "cloudinary";
import { uploadImage } from "./festControllers.js";
import sendTocken from "../utils/sendCookie.js";
import ApiFeatures from "../utils/apiFeatures.js";

async function register(req, res) {
    try {
        const { name, email, password, rollno } = req.body;
        const user = await User.create({
            name: name,
            email: email,
            password: password,
            rollno: rollno,
        });
        sendTocken(user, res);
    } catch (err) {
        if (err.code == 11000)
            res.json({ success: false, message: "User alredy exits, login" });
        else if (err.message == "User validation failed: email: Please Enter a valid Email") {
            res.json({ success: false, message: "please enter valid Email" });
        } else {
            res.json({ success: false, message: err.message });
        }
    }
}


async function login(req, res) {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email: email }).select("+password").exec();
        if (!user) {
            res.json({
                success: false,
                message: "Email doesn't exist please register"
            });
        } else {
            const isPasswordMatched = await user.comparePassword(password);
            if (!isPasswordMatched) {
                res.json({
                    success: false,
                    message: "Incorrect password"
                });
            } else {
                sendTocken(user, res);
            }
        }
    } catch (e) {
        res.json({ success: false, message: e.message });
    }
}


async function getUserDetails(req, res, next) {
    try {
        const user = await User.findById(req.user._id).populate("myEvents");
        res.json({ success: true, user });
    } catch (error) {
        console.log(error);
        res.json({ success: false, message: error.message });
    }
}

async function getOtherUsersDetails(req, res, next) {
    try {
        const user = await User.findById(req.params.id);
        res.json({ success: true, user });
    } catch (error) {
        console.log(error);
        res.json({ success: false, message: error.message });
    }
}

async function forgotPassword(req, res, next) {
    const user = await User.findOne({ email: req.body.email });
    if (!user) {
        return next(res.json({ success: false, message: "The user doesn't exist please create account" }));
    } else {
        const resetToken = await user.getResetPasswordToken();
        await user.save({ validateBeforeSave: false });
        // const resetPasswordUrl = `${req.protocol}://${req.get("host")}/password/reset/${resetToken}`;
        const resetPasswordUrl = `${process.env.FRONTEND_URL}/password/reset/${resetToken}`
        const message = `your password reset token is \n\n${resetPasswordUrl} \n\nif you have not requsted this email then, please ignore it`;
        try {
            await sendEmail({
                email: user.email,
                subject: "Festing App Password Recovery",
                message: message
            });
            res.json({ success: true, message: `Email sent to ${user.email} successfully` });
        } catch (error) {
            user.resetPasswordToken = undefined;
            user.resetPasswordExpire = undefined;
            await user.save({ validateBeforeSave: false });
            return next(res.json({ success: false, message: error.message }));
        }
    }
}

async function resetPassword(req, res, next) {
    const resetPasswordToken = crypto.createHash("sha256").update(req.params.token).digest("hex");
    const user = await User.findOne({ resetPasswordToken: resetPasswordToken });
    if (!user) {
        return next(res.json({ success: false, message: "The time has been expired or token is invalid" }));
    } else {
        if (req.body.password !== req.body.confirmPassword) {
            return next(res.json({ success: false, message: "The password doesn't match" }));
        } else {
            user.password = req.body.password;
            user.resetPasswordToken = undefined;
            user.resetPasswordExpire = undefined;
            await user.save();
            sendTocken(user, res);
        }
    }
}

async function updatePassword(req, res, next) {
    const user = await User.findById(req.user._id).select("+password");
    if (!user.comparePassword(req.body.oldPassword)) {
        return next(res.json({ message: "The passwords did not match", success: false }));
    }
    if (req.body.newPassword !== req.body.confirmPassword) {
        return next(res.json({ success: false, message: "The new password and the confirm password did not match" }));
    }
    if (req.body.newPassword.length < 8) {
        return next(res.json({ success: false, message: "The password legth should be 8 characters long" }));
    }
    user.password = req.body.newPassword;
    await user.save();
    sendTocken(user, res);
}

async function updateProfile(req, res, next) {
    try {
        const newUserData = req.body;
        const user = await User.findById(req.user.id);
        const temp = JSON.parse(req.body["socialLinks"]);
        newUserData["socialLinks"] = { ...user.socialLinks, ...temp };
        if (req.files) {
            const imageId = user.avatar.public_id;
            if (imageId) {
                cloudinary.v2.uploader.destroy(imageId);
            }
            newUserData.avatar = await uploadImage(req.files.avatar.data, "avatars");
        }
        await User.findByIdAndUpdate(req.user.id, newUserData);
        res.json({ success: true });
    } catch (error) {
        console.log(error.message);
        res.json({ success: false });
    }
}

async function getAllUsers(req, res, next) {
    try {
        const apiFeatures = new ApiFeatures(User.find().sort({ name: 1 }), req.query).search().pagination(100);
        const users = await apiFeatures.query;
        // await users.sort((a, b) => a.name.localeCompare(b.name));
        res.json({ success: true, users });
    } catch (error) {
        console.log(error.message);
        res.json({ success: false });
    }
}

async function logout(req, res) {
    try {
        res.cookie("token", null, {
            expires: new Date(Date.now()),
            httpOnly: true
        }).json({ success: true, message: "logged out successfully" });
    } catch (error) {
        console.log(error.message);
        res.json({ success: false });
    }
}

async function sendRequest(req, res, next) {
    try {
        // order id user id
        const order = await Order.findById(req.body.orderId);
        const idx = order.team.findIndex((member) => member.user.toString() == req.body.userId);
        if (idx != -1) {
            order.team[idx].status = "waiting";
            const user = await User.findById(req.body.userId);
            user.myEvents.push(order._id);
            await Order.findByIdAndUpdate(req.body.orderId, order);
            await User.findByIdAndUpdate(req.body.userId, user);
            return res.json({ success: true, resent: true });
        }
        order.team.push({ user: req.body.userId });
        const user = await User.findById(req.body.userId);
        user.myEvents.push(order._id);

        await Order.findByIdAndUpdate(req.body.orderId, order);
        await User.findByIdAndUpdate(req.body.userId, user);

        res.json({ success: true });
    } catch (error) {
        console.log(error.message);
        res.json({ success: false });
    }
}

async function acceptRequest(req, res, next) {
    try {
        const order = await Order.findById(req.body.orderId)
            .populate("team.user")
            .populate("event");

        const currTeamSize = order.team.filter((member) => member.status === "accepted").length;
        if (order.event.teamSize === currTeamSize) {
            return res.json({ success: false, message: "Team size is maximum" });
        }

        const userIndex = order.team.findIndex((member) => member.user._id == req.body.userId);
        if (userIndex !== -1) {
            order.team[userIndex].status = "accepted";
        }

        await Order.findByIdAndUpdate(req.body.orderId, order);
        res.json({ success: true });
    } catch (error) {
        console.error(error.message);
        res.json({ success: false });
    }
}

const rejectRequest = async (req, res, next) => {
    try {
        const orderId = req.body.orderId;
        const userId = req.body.userId;

        const order = await Order.findById(orderId);

        order.team.forEach(teamMember => {
            if (teamMember.user == userId) {
                teamMember.status = 'rejected';
            }
        });

        const user = await User.findById(userId);
        user.myEvents = user.myEvents.filter(event => event.toString() !== order._id.toString());

        await Order.findByIdAndUpdate(orderId, order);
        await User.findByIdAndUpdate(userId, user);

        res.json({ success: true });
    } catch (error) {
        console.error(error.message);
        res.json({ success: false });
    }
};


export { login, register, getUserDetails, forgotPassword, resetPassword, updatePassword, sendRequest, acceptRequest, rejectRequest, getAllUsers, logout, updateProfile, getOtherUsersDetails };