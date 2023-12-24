import dotenv from "dotenv";
dotenv.config({ path: "backend/config/.env" });
import nodemailer from "nodemailer"

async function sendEmail(options) {
    const transporter=nodemailer.createTransport({
        service:"gmail",
        auth:{
            user:process.env.SMPT_MAIL,
            pass:process.env.SMPT_PASSWORD
        }
    });
    const mailOptions={
        from:process.env.SMPT_MAIL,
        to:options.email,
        subject:options.subject,
        text:options.message
    };
    await transporter.sendMail(mailOptions);
}

export default sendEmail;