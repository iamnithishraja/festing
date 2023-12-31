import express from "express";
import cookieParser from "cookie-parser";
import bodyParser from "body-parser";
import fileUpload from "express-fileupload";
import { userRouter } from "./routes/userRoutes.js";
import { festRouter } from "./routes/festRoutes.js";
import cors from "cors";
import orderRouter from "./routes/orderRoutes.js";
import { postRouter } from "./routes/postRoutes.js";

const app = express();
app.use(cors());
app.use(bodyParser.json({ limit: '35mb' }));
app.use(cookieParser());

app.use(bodyParser.urlencoded({ extended: true, limit: '35mb', parameterLimit: 50000 }));
app.use(fileUpload());



app.use('/user', userRouter);
app.use('/fests', festRouter);
app.use("/orders", orderRouter);
app.use("/post", postRouter);

app.get("/", (req, res, next) => {
    res.json({ success: true, message: "working", pid: process.pid });
});

export default app;