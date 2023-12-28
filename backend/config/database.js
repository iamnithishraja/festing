import dotenv from "dotenv";
dotenv.config({ path: "config/.env" })
import mongoose from "mongoose";

function connectDatabse() {
    return new Promise((resolve) => {
        return mongoose.connect(process.env.DB_URI).then(
            () => {
                console.log("connected succesfully");
                resolve();
            }
        ).catch(err => {
            console.log(err);
        });
    });
}

export { connectDatabse };
