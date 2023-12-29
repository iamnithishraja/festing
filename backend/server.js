import dotenv from "dotenv";
dotenv.config({ path: "/config/.env" });
import cluster from 'node:cluster';
import process from 'node:process';
import os from 'node:os';
import app from "./app.js";
import { connectDatabse } from "./config/database.js";
import cloudinary from "cloudinary";

const numCpus = os.cpus().length;

if (cluster.isPrimary) {
    console.log(`Primary ${process.pid} is running`);
    for (let i = 0; i < numCpus; i++) {
        cluster.fork();
    }
    cluster.on('exit', (worker, code, signal) => {
        console.log(`worker ${worker.process.pid} died`);
    });
} else {
    cloudinary.config({
        cloud_name: process.env.CLOUDINARY_NAME,
        api_key: process.env.CLOUDINARY_API_KEY,
        api_secret: process.env.CLOUDINARY_API_SECRET,
    });

    connectDatabse();
    app.listen(process.env.PORT, () => {
        console.log("listning on port " + process.env.PORT);
    });
}