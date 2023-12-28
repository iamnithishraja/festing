import dotenv from "dotenv";
dotenv.config({ path: ".env" })
import mongoose from "mongoose";

function connectDatabse() {
    return new Promise((resolve) => {
        mongoose.connect(process.env.DB_URI).then(
            () => {
                console.log("connected to db");
                resolve();
            }
        ).catch(err => {
            console.log("error connecting to db");
            console.log(err);
            resolve();
        });
    });
}

export { connectDatabse };
