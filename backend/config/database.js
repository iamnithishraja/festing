import dotenv from "dotenv";
dotenv.config({ path: ".env" })
import mongoose from "mongoose";

function connectDatabse(cb) {
    return new Promise((resolve) => {
        return mongoose.connect(process.env.DB_URI).then(
            () => {
                console.log("connected to db");
                cb();
                resolve();
            }
        ).catch(err => {
            console.log(err);
        });
    });
}

export { connectDatabse };
