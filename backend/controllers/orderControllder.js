import Fest from "../models/festModel.js";
import Event from "../models/eventModel.js";
import Order from "../models/orderModel.js";
import User from "../models/userModel.js";


async function createOrder(req, res, next) {
    try {
        const order = await Order.create({
            event: req.body.eventId,
            team: [{ user: req.body.userId, status: "accepted" }]
        });
        const user = await User.findById(req.body.userId);
        user.myEvents.push(order._id);
        const toSend = await Order.findById(order.id).populate("team.user").populate("event")
        await User.findByIdAndUpdate(user._id, user);
        res.json({ success: true, "order": toSend });
    } catch (err) {
        console.log(err);
        res.json({ success: false });
    }
}

async function getAllOrders(req, res, next) {
    try {
        const user = await User.findById(req.params.id);
        const myEvents = user.myEvents;
        const orders = [];
        const date = new Date();
        const now_utc = Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate());
        console.log(now_utc);
        
        for (let i = 0; i < myEvents.length; i++) {
            const order = await Order.findById(myEvents[i]).populate("team.user").populate("event");

            if (new Date(order.event["schedule"][order.event["schedule"].length - 1][1]) >= new Date(now_utc)) {
                orders.push(order);
            }
        }
        res.json({ success: true, orders });
    } catch (err) {
        console.log(err.message);
        res.json({ success: false });
    }
}
async function resendRequest(req, res, next) {
    try {
        const order = await Order.findById(req.body.OrderId);
        for (var i = 0; i < order.team.length; i++) {
            if (order.team[i].user == req.body.userId) {
                order.team[i].status = "waiting";
            }
        }
        const user = await User.findById(req.body.userId);
        user.myEvents.push(order._id);

        await Order.findByIdAndUpdate(req.body.OrderId, order);
        await User.findByIdAndUpdate(req.body.userId, user);
        res.json({ success: true });
    } catch (error) {
        console.log(err);
        res.json({ success: false });
    }
}


export { createOrder, getAllOrders };