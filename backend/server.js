import dotenv from "dotenv";
dotenv.config({path:"/config/.env"});
import app from "./app.js";
import { connectDatabse } from "./config/database.js";
import cloudinary from "cloudinary"

connectDatabse();
cloudinary.config({
    cloud_name: process.env.CLOUDINARY_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
});
  
app.listen(process.env.PORT,()=>{
    console.log("listning on port "+process.env.PORT);
});