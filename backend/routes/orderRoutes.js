import express from "express";
import { isAuthenticatedUser } from "../middlewares/auth.js";
import {
  createOrder,
  getAllOrders,
  getAllOrdersByEvent,
  deleteOrder,
  addCrParticipents,
} from "../controllers/orderControllder.js";
import { authoriseRoles } from "../middlewares/auth.js";

const orderRouter = express.Router();
orderRouter.get("/all/:id", getAllOrders);
orderRouter.route("/order").post(isAuthenticatedUser, createOrder);
orderRouter
  .route("/event/:id")
  .get(
    isAuthenticatedUser,
    (req, res, next) => authoriseRoles(req, res, next, "admin", "cr"),
    getAllOrdersByEvent
  )
  .delete(
    isAuthenticatedUser,
    (req, res, next) => authoriseRoles(req, res, next, "admin", "cr"),
    deleteOrder
  );
orderRouter
  .route("/event/cr/:id")
  .post(
    isAuthenticatedUser,
    (req, res, next) => authoriseRoles(req, res, next, "cr"),
    addCrParticipents
  );

export default orderRouter;
