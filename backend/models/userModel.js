import dotenv from "dotenv";
dotenv.config({ path: "config/.env" });
import mongoose from "mongoose";
import validator from "validator";
import bcryptjs from "bcryptjs";
import jsonwebtoken from "jsonwebtoken";
import crypto from "crypto";

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, "Please Enter Your Name"],
  },
  rollno: {
    type: String,
    required: [true, "Please Enter Your Roll Number"],
    unique: true,
  },
  email: {
    type: String,
    required: [true, "Please Enter Your Email"],
    unique: true,
    validate: [validator.isEmail, "Please Enter a valid Email"],
  },
  password: {
    type: String,
    required: [true, "Please Enter Your Password"],
    minLength: [8, "Password should be greater than 8 characters"],
    select: false,
  },
  avatar: {
    public_id: {
      type: String,
    },
    url: {
      type: String,
    },
  },
  role: {
    type: String,
    default: "user",
  },
  bio: String,
  myEvents: [
    {
      type: mongoose.Schema.ObjectId,
      Ref: "Order"
    }
  ],
  createdAt: {
    type: Date,
    default: Date.now,
  },
  socialLinks: {
    github: String,
    linkdlin: String,
    codingPlatform: String,
  },
  resetPasswordToken: String,
  resetPasswordExpire: Date,
});

userSchema.pre("save", async function (next) {

  if (!this.isModified("password")) {
    next();
  }
  this.password = await bcryptjs.hash(this.password, 10);
});

userSchema.methods.getJWTTocken = function () {
  return jsonwebtoken.sign({ id: this._id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE
  });
}


userSchema.methods.comparePassword = function (enteredPassword) {
  return bcryptjs.compare(enteredPassword, this.password);
}

userSchema.methods.getResetPasswordToken = function () {
  const resetToken = crypto.randomBytes(20).toString("hex");
  this.resetPasswordToken = crypto.createHash("sha256").update(resetToken).digest("hex");
  this.resetPasswordExpire = Date.now() + 15 * 60 * 1000;
  return resetToken;
}

const User = mongoose.model("User", userSchema);
export default User;