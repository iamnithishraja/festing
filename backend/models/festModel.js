import mongoose from "mongoose";

const festSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, "Please Enter Fest Name"],
    },
    collegeName: {
        type: String,
        required: [true, "Please Enter college Name"],
    },
    description: {
        type: String,
        required: [true, "Please Enter Description"],
    },
    collegeWebsite: {
        type: String,
    },
    festWebsite: {
        type: String,
    },
    location: {
        type: String, required: [true, "Please Enter Location Name"],
    },
    isArchived:{   
        type:Boolean,
        default:false,
    },
    poster: {
        public_id: {
            type: String,
            required: [true, "Please Enter Public ID"],
        },
        url: {
            type: String,
            required: [true, "Please Enter URL"]
        },
    },
    broture: {
        type: String,
        required: [true, "Please Enter broture url"]
    },
    startDate: {
        type: Date,
        required: [true, "Please Enter start Date"]
    },
    endDate: {
        type: Date,
        required: [true, "Please Enter end Date"]
    },
    events: [
        {
            type: mongoose.Schema.ObjectId,
            ref: "Event",
        }
    ]
});

const Fest = mongoose.model("Fest", festSchema);

export default Fest;