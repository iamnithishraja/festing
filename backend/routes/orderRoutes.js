import express from "express";
import { isAuthenticatedUser } from "../middlewares/auth.js";
import { createOrder, getAllOrders } from "../controllers/orderControllder.js"

const orderRouter = express.Router();
orderRouter.get("/all/:id", getAllOrders);
orderRouter.route("/order").post(isAuthenticatedUser, createOrder);

export default orderRouter;