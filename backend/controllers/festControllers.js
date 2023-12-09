import mongoose from "mongoose";
import Fest from "../models/festModel.js";
import Event from "../models/eventModel.js";
import streamifier from "streamifier";
import cloudinary from "cloudinary";
import { query } from "express";

async function uploadImage(image, folder_name) {
    return new Promise((resolve, reject) => {
        const upload_stream = cloudinary.v2.uploader.upload_stream({
            resource_type: "image",
            width: 300,
            crop: 'scale',
            folder: folder_name,
        }, (error, uploadResult) => {
            if (error) {
                reject(error);
            } else {
                resolve(uploadResult);
            }
        });

        upload_stream.end(image);
    }).then((uploadResult) => {
        return {
            public_id: uploadResult.public_id,
            url: uploadResult.secure_url
        };
    }).catch((error) => {
        throw new Error(`Error uploading image: ${error.message}`);
    });
}

async function createFest(req, res, next) {
    try {
        cloudinary.v2.api
            .create_folder(req.body.name);

        const poster = await uploadImage(req.files.poster.data, req.body.name);

        const { name, collegeName, description, collegeWebsite, festWebsite, location, startDate, endDate, broture } = req.body;
        const fest = await Fest.create({
            name: name,
            collegeName: collegeName,
            description: description,
            collegeWebsite: collegeWebsite,
            festWebsite: festWebsite,
            location: location,
            startDate: new Date(startDate),
            endDate: new Date(endDate),
            broture: broture,
            poster: poster
        });
        res.json({ success: true, fest, message: "succefully created new fest" });
    } catch (error) {
        console.log(error.message);
        res.json({ success: false, message: error.message });
    }
}

async function getEligibleFests(req, res, next) {
    try {
        const fests = await Fest.find({ endDate: { $gte: Date.now() } });
        res.send({ success: true, fests });
    } catch (error) {
        console.log(error.message);
        res.json({ success: false, message: error.message });
    }
}

async function getArchivedFests(req, res, next) {
    try {
        const fests = await Fest.find({ endDate: { $lt: Date.now() } });
        res.send({ success: true, fests });
    } catch (error) {
        console.log(error.message);
        res.json({ success: false, message: error.message });
    }
}

async function getAllevents(req, res, next) {
    try {
        const fest = await Fest.findById(req.params.id).populate("events");
        const events = fest.events;
        res.json({ success: true, events });
    } catch (error) {
        res.json({ success: false, message: error.message });
    }
}

async function getFest(req, res, next) {

}

async function updateFest(req, res, next) {
    try {
        const fest = await Fest.findById(req.body.id);
        if (req.files != null) {
            await cloudinary.v2.uploader.destroy(fest.poster.public_id);
            req.body.poster = await uploadImage(req.files.poster.data, fest.poster.public_id.split("/")[0]);
        }
        const new_fest = await Fest.findByIdAndUpdate(req.body.id, req.body);
        res.json({ success: true, new_fest });
    } catch (e) {
        console.log(e.message);
        res.json({ success: false, message: e.message });
    }
}

async function deleteFest(req, res, next) {
    try {
        const fest = await Fest.findById(req.body.id);
        await cloudinary.v2.uploader.destroy(fest.poster.public_id);
        await Fest.findByIdAndDelete(req.body.id);
        res.send({ success: true });
    } catch (e) {
        console.log(e.message);
        res.json({ success: false, message: e.message });
    }
}

async function createEvent(req, res, next) {
    try {
        const fest = await Fest.findById(req.body.festId);
        const poster = await uploadImage(req.files.poster.data, fest.poster.public_id.split("/")[0] + "/" + req.body.name);
        const schedule = [];
        for (let i = 0; req.body[`schedule[${i}]`] != undefined; i++) {
            schedule.push([new Date(req.body[`schedule[${i}]`][0]), new Date(req.body[`schedule[${i}]`][1])]);
        }

        const event = await Event.create({
            name: req.body.name,
            description: req.body.description,
            details: req.body.details,
            teamSize: req.body.teamSize,
            price: req.body.price,
            poster: poster,
            location: req.body.location,
            venue: req.body.venue,
            category: req.body.category,
            schedule: schedule,
        });
        fest.events.push(event._id);
        await Fest.findByIdAndUpdate(fest.id, fest);
        res.json({ success: true, message: "event added successfully" });
    } catch (error) {
        console.log(error.message);
        res.json({ success: false, message: error.message });
    }
}

async function updateEvent(req, res, next) {
    try {
        const event = await Event.findById(req.body.eventId);
        if (req.files != null) {
            await cloudinary.v2.uploader.destroy(event.poster.public_id);
            req.body.poster = await uploadImage(req.files.poster.data, event.poster.public_id.split("/")[0]);
        }
        const schedule = [];
        for (let i = 0; req.body[`schedule[${i}]`] != undefined; i++) {
            schedule.push([new Date(req.body[`schedule[${i}]`][0]), new Date(req.body[`schedule[${i}]`][1])]);
        }
        const new_event = await Event.findByIdAndUpdate(req.body.eventId, { ...req.body, schedule: schedule });
        res.json({ success: true, new_event });
    } catch (error) {
        console.log(error.message);
        res.json({ success: false, message: error.message });
    }
}

async function getEvent(req, res, next) {

}


async function deleteEvent(req, res, next) {
    try {
        const event = await Event.findById(req.body.id);
        await cloudinary.v2.uploader.destroy(event.poster.public_id);
        await Event.findByIdAndDelete(req.body.id);
        res.send({ success: true });
    } catch (e) {
        console.log(e.message);
        res.json({ success: false, message: e.message });
    }
}


export { getEligibleFests, getAllevents, getFest, updateFest, deleteFest, createEvent, getEvent, updateEvent, deleteEvent, createFest, getArchivedFests };