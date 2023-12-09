import dotenv from "dotenv";
dotenv.config({path:"/config/.env"});


async function sendTocken(user,res){
    const token=await user.getJWTTocken();
    const options={
        expires:new Date(Date.now()+process.env.DELETE_COOKIE*24*60*60*1000),
        httpOnly:true,
    };
    res.cookie("token",token,options).json({
        success:true,
        user,
        token
    });
}

export default sendTocken;