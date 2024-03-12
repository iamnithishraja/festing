import dotenv from "dotenv";
dotenv.config({ path: "backend/config/config.env" });
import User from "../models/userModel.js";
import jsonwebtoken from "jsonwebtoken";

async function isAuthenticatedUser(req, res, next) {
  try {
    const token = req.cookies.token;
    if (!token) {
      res.json({ success: false, message: "no token sent" });
    } else {
      const decoded_data = jsonwebtoken.verify(token, process.env.JWT_SECRET);
      req.user = await User.findById(decoded_data.id);
      next();
    }
  } catch (error) {
    console.log(error.message);
    res.json({ success: false, message: error.message });
  }
}

async function authoriseRoles(req, res, next, role1, role2) {
  try {
    if (!role1.includes(req.user.role) && !role2.includes(req.user.role)) {
      res.json({ success: false, message: `only ${role1} can access this` });
    } else {
      next();
    }
  } catch (e) {
    res.json({ success: false, message: e.message });
  }
}

export { isAuthenticatedUser, authoriseRoles };
