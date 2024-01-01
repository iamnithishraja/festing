import mongoose from "mongoose";
const Schema = mongoose.Schema;
const categorySchema = new Schema({
    categories:[
        {
            type:String,
            unique:true
        }
    ]
})

const Category = mongoose.model('Category',categorySchema);
export default Category;