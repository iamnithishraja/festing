import express from "express";
import { isAuthenticatedUser, authoriseRoles } from "../middlewares/auth.js";
import { getEligibleFests, getArchivedFests, getAllevents, getFest, updateFest, deleteFest, createEvent, updateEvent, getEvent, deleteEvent, createFest } from "../controllers/festControllers.js";


const festRouter = express.Router();

festRouter.route("/eligible").get(isAuthenticatedUser, getEligibleFests);
festRouter.route("/archived").get(isAuthenticatedUser, getArchivedFests);

festRouter.route("/events/:id").get(isAuthenticatedUser, getAllevents);

festRouter.route("/fest")
    .post(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), createFest)
    .get(isAuthenticatedUser,isAuthenticatedUser, getFest)
    .put(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), updateFest)
    .delete(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), deleteFest);

festRouter.route("/event")
    .get(isAuthenticatedUser, getEvent)
    .post(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), createEvent)
    .put(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), updateEvent)
    .delete(isAuthenticatedUser, (req, res, next) => authoriseRoles(req, res, next, "admin"), deleteEvent);

export { festRouter };