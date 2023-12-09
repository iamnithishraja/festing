import dotenv from "dotenv";
dotenv.config({path:"config/.env"})
import mongoose from "mongoose";

function connectDatabse() {
    mongoose.connect(process.env.DB_URI).then(
        () => { console.log("connected succesfully") }
    ).catch(err => {
        console.log(err);
    });   
}

export {connectDatabse};
