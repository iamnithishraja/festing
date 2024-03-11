import express from "express";
import cookieParser from "cookie-parser";
import bodyParser from "body-parser";
import fileUpload from "express-fileupload";
import { userRouter } from "./routes/userRoutes.js";
import { festRouter } from "./routes/festRoutes.js";
import cors from "cors";
import orderRouter from "./routes/orderRoutes.js";
import { postRouter } from "./routes/postRoutes.js";
import { fileURLToPath } from 'url';
import path,{ dirname } from 'path';

const app = express();
app.use(cors({ credentials: true, origin: true }));
app.use(bodyParser.json({ limit: "35mb" }));
app.use(cookieParser());

app.use(
  bodyParser.urlencoded({
    extended: true,
    limit: "35mb",
    parameterLimit: 50000,
  })
);
app.use(fileUpload());

app.use("/user", userRouter);
app.use("/fests", festRouter);
app.use("/orders", orderRouter);
app.use("/post", postRouter);

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
app.use(express.static(path.join(__dirname, "/frontend")));
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "/frontend/index.html"));
});

export default app;
