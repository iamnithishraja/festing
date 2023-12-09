import dotenv from "dotenv";
dotenv.config({ path: "/config/config.env" });
import User from "../models/userModel.js";
import Order from "../models/orderModel.js";
import cloudinary from "cloudinary";
import sendTocken from "../utils/sendCookie.js";
import ApiFeatures from "../utils/apiFeatures.js";

async function register(req, res) {
    let myCloud;
    let avatar = null;
    try {

        if (req.body.avatar) {
            myCloud = await cloudinary.v2.uploader.upload(req.body.avatar,
                {
                    folder: "avatars",
                    width: 150,
                    crop: "scale"
                });
            avatar = {
                public_id: myCloud.public_id ? myCloud.public_id : undefined,
                url: myCloud.secure_url ? myCloud.secure_url : undefined
            }
        }

        const { name, email, password, rollno } = req.body;
        const user = await User.create({
            name: name,
            email: email,
            password: password,
            rollno: rollno,
            avatar: avatar
        });
        sendTocken(user, res);
    } catch (err) {
        // await cloudinary.uploader.destroy(myCloud.public_id);
        if (err.code == 11000)
            res.json({ success: false, message: "user alredy exits login" });
        else if (err.message == "User validation failed: email: Please Enter a valid Email") {
            res.json({ success: false, message: "please enter valid e mail" });
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
                message: "email dosent exist please register"
            });
        } else {
            const isPasswordMatched = await user.comparePassword(password);
            if (!isPasswordMatched) {
                res.json({
                    success: false,
                    message: "incorrect password"
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
        res.json({ success: false, user: undefined });
    }
}

async function fergotPassword(req, res, next) {
    const user = await User.findOne({ email: req.body.email });
    if (!user) {
        return next(res.json({ success: false, message: "the user dosent exist please create account" }));
    } else {
        const resetToken = await user.getResetPasswordToken();
        await user.save({ validateBeforeSave: false });
        const resetPasswordUrl = `${req.protocol}://${req.get("host")}/password/reset/${resetToken}`;
        // const resetPasswordUrl = `${process.env.FRONTEND_URL}/password/reset/${resetToken}`
        const message = `your password reset token is \n\n${resetPasswordUrl} \n\nif you have not requsted this email then, please ignore it`;
        try {
            await sendEmail({
                email: user.email,
                subject: "Ecommerse Password Recovery",
                message: message
            });
            res.json({ success: true, message: `email sent to ${user.email} successfully` });
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
        return next(res.json({ success: false, message: "the time has been expired or token is invalid" }));
    } else {
        if (req.body.password !== req.body.confirmPassword) {
            return next(res.json({ success: false, message: "the password dosent match" }));
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
        return next(res.json({ message: "the passwords did not match", success: false }));
    }
    if (req.body.newPassword !== req.body.confirmPassword) {
        return next(res.json({ success: false, message: "the new password conform password did not match" }));
    }
    if (req.body.newPassword.length < 8) {
        return next(res.json({ success: false, message: "the password legth should be 8 charactors long" }));
    }
    user.password = req.body.newPassword;
    await user.save();
    sendTocken(user, res);
}

async function getAllUsers(req, res, next) {
    try {
        const apiFeatures = new ApiFeatures(User, req.query).search().pagination(100);
        const users = await apiFeatures.query;
        await users.sort((a, b) => a.name.localeCompare(b.name));
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
        const order = await Order.findById(req.body.OrderId).populate("User").populate("Event");
        const currTeamSize = order.team.filter((member) => member.status == "accepted").length;
        if (order.event.teamSize == currTeamSize) {
            res.json({ success: "false", message: "team size is maximum" });
            next();
        }
        for (var i = 0; i < order.team.length; i++) {
            if (order.team[i].user._id == req.body.userId) {
                order.team[i].status = "accepted";
            }
        }

        await Order.findByIdAndUpdate(req.body.OrderId, order);
        res.json({ success: true });
    } catch (error) {
        console.log(error.message);
        res.json({ success: false });
    }
}

async function rejectRequest(req, res, next) {
    try {
        //order id user id
        const order = await Order.findById(req.body.OrderId);
        for (var i = 0; i < order.team.length; i++) {
            if (order.team[i].user == req.body.userId) {
                order.team[i].status = "rejected";
            }
        }

        const user = await User.findById(req.body.userId);
        user.myEvents = user.myEvents.filter((event) => event != order._id);


        await Order.findByIdAndUpdate(req.body.OrderId, order);
        await User.findByIdAndUpdate(req.body.userId, user);

        res.json({ success: true });
    } catch (error) {
        console.log(error.message);
        res.json({ success: false });
    }
}

export { login, register, getUserDetails, fergotPassword, resetPassword, updatePassword, sendRequest, acceptRequest, rejectRequest, getAllUsers, logout };