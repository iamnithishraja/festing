import mongoose from "mongoose";


const orderScema = new mongoose.Schema({
    event: {
        type:
            mongoose.Schema.ObjectId,
        ref: "Event"
    },
    team: [
        {
            user: {
                type: mongoose.Schema.ObjectId,
                ref: "User"
            },
            status: {
                type: String,
                default:"waiting"
            }
        }
    ]
});

const Order = mongoose.model("Order", orderScema);

export default Order;