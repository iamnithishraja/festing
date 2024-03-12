import Fest from "../models/festModel.js";
import Event from "../models/eventModel.js";
import Order from "../models/orderModel.js";
import User from "../models/userModel.js";
import sendEmail from "../utils/sendEmail.js";

async function createOrder(req, res, next) {
  try {
    const order = await Order.create({
      event: req.body.eventId,
      team: [{ user: req.body.userId, status: "accepted" }],
    });
    const user = await User.findById(req.body.userId);
    user.myEvents.push(order._id);
    const toSend = await Order.findById(order.id)
      .populate("team.user")
      .populate("event");
    await User.findByIdAndUpdate(user._id, user);
    res.json({ success: true, order: toSend });
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

    for (let i = 0; i < myEvents.length; i++) {
      const order = await Order.findById(myEvents[i])
        .populate("team.user")
        .populate("event");
      orders.push(order);
    }
    orders.sort(
      (a, b) => a.event["schedule"][0][0] - b.event["schedule"][0][0]
    );
    res.json({ success: true, orders });
  } catch (err) {
    console.log(err.message);
    res.json({ success: false });
  }
}

async function getAllOrdersByEvent(req, res, next) {
  try {
    const orders = await Order.find({ event: req.params.id })
      .populate("team.user")
      .populate("event");
    res.json({ success: true, orders });
  } catch (error) {
    console.log(err);
    res.json({ success: false });
  }
}

async function deleteOrder(req, res, next) {
  try {
    const order = await Order.findById(req.params.id).populate("event");
    for (let j = 0; j < order.team.length; j++) {
      const userId = order.team[j].user;
      const user = await User.findById(userId);
      user.myEvents = user.myEvents.filter(
        (userorder) => userorder.toString() != order._id.toString()
      );
      await User.findByIdAndUpdate(userId, user);
      const message = `Your team has been rejected for ${order.event.name}, for not meeting the Qualifications .`;
      sendEmail({
        email: user.email,
        subject: "Festing App Team Rejection",
        message: message,
      });
    }
    await Order.deleteOne({ _id: req.params.id });
    res.json({ success: true, message: "deleted this team" });
  } catch (error) {
    console.log(error);
    res.json({ success: false });
  }
}

async function addCrParticipents(req, res, next) {
  try {
    const { id } = req.params;
    const { rollnos } = req.body;
    const order = await Order.create({
      event: id,
      team: [],
    });
    for (const roll of rollnos) {
      try {
        const user = await User.findOne({ rollno: roll });
        user.myEvents.push(order._id);
        order.team.push({ user: user._id, status: "accepted" });
        await user.save();
      } catch (error) {
        console.error(`Error processing roll number ${roll}:`, error);
      }
    }
    await Order.findByIdAndUpdate(order._id, order);
    console.log({ success: true, message: "access granted" });
  } catch (error) {
    console.log({ success: false, message: "unable to register the team" });
  }
}

export {
  createOrder,
  getAllOrders,
  getAllOrdersByEvent,
  deleteOrder,
  addCrParticipents,
};
