import express from "express";
import { isAuthenticatedUser } from "../middlewares/auth.js";
import { createOrder, getAllOrders, getAllOrdersByEvent, deleteOrder } from "../controllers/orderControllder.js"
import { authoriseRoles } from "../middlewares/auth.js";


const orderRouter = express.Router();
orderRouter.get("/all/:id", getAllOrders);
orderRouter.route("/order").post(isAuthenticatedUser, createOrder);
orderRouter.route("/event/:id").get(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), getAllOrdersByEvent).delete(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), deleteOrder);

export default orderRouter;