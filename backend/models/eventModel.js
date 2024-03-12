import mongoose from "mongoose";

const eventSchema = new mongoose.Schema({
  name: {
    type: String,
    require: [true, "name is a required feild"],
  },
  description: {
    type: String,
    require: [true, "description is a required feild"],
  },
  details: [{ type: String }],
  price: {
    type: Number,
    require: [true, "price is a required feild"],
    maxLength: [8, "price cannot exceed 8 figures"],
  },
  poster: {
    public_id: {
      type: String,
      require: true,
    },
    url: {
      type: String,
      require: true,
    },
  },
  category: {
    type: String,
    require: [true, "event category is a required feild"],
  },
  venue: String,
  location: String,
  schedule: [[{ type: Date }]],
  teamSize: {
    type: Number,
    require: [true, "please enter Team Size"],
  },
  isLimitedNumberOfTeams: {
    type: Boolean,
    require: [true, "this is required feild"],
  },
});

const Event = mongoose.model("Event", eventSchema);

export default Event;
