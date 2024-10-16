const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
    {
        id: { type: String, required: true, unique: true }, // Unique user ID
        name: { type: String, required: true },
        surname: { type: String, required: true },
        password: { type: String, required: true },
        role: { type: String, required: true, default: 'user' } // Default role is 'user'
    },
    { timestamps: true, versionKey: false } // Automatic createdAt and updatedAt fields
);

// Create the User model from the schema
const User = mongoose.model('User', userSchema);

module.exports = User;
