import express from "express";
import { isAuthenticatedUser, authoriseRoles } from "../middlewares/auth.js";
import { getEligibleFests, getArchivedFests, getAllevents, getFest, updateFest, deleteFest, createEvent, updateEvent, getEvent, deleteEvent, createFest } from "../controllers/festControllers.js";
import catchAsync from "../utils/catchAsync.js";


const festRouter = express.Router();

festRouter.route("/eligible").get(isAuthenticatedUser, catchAsync(getEligibleFests));
festRouter.route("/archived").get(isAuthenticatedUser, catchAsync(getArchivedFests));

festRouter.route("/events/:id").get(isAuthenticatedUser, catchAsync(getAllevents));

festRouter.route("/fest")
    .post(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), catchAsync(createFest))
    .get(isAuthenticatedUser,isAuthenticatedUser, catchAsync(getFest))
    .put(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), catchAsync(updateFest))
    .delete(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), catchAsync(deleteFest));

festRouter.route("/event")
    .get(isAuthenticatedUser, catchAsync(getEvent))
    .post(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), catchAsync(createEvent))
    .put(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), catchAsync(updateEvent))
    .delete(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), catchAsync(deleteEvent));

export { festRouter };