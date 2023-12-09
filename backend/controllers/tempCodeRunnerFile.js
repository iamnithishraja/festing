        if (req.files != null) {
            await cloudinary.v2.uploader.destroy(fest.poster.public_id);
            req.body.poster = await uploadImage(req.files.poster.data, fest.poster.public_id.split("/")[0]);
        }