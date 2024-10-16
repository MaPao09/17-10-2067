
const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");

exports.fetchUserProfile = async (req, res) => {
    const userId = req.user.userId;

    try {
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        res.json({
            id: user.id,
            name: user.name,
            surname: user.surname,
            role: user.role
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Internal server error' });
    }
};


exports.editProfile = async (req, res) => {
    const userId = req.user.userId; // Assuming the user ID is set by authentication middleware
    const { name, surname, role } = req.body; // Destructure fields from request body

    // Prepare an object to hold the updates
    const updates = {};
    
    // Only add fields to updates object if they are provided
    if (name) {
        updates.name = name;
    }
    if (surname) {
        updates.surname = surname;
    }
    if (role) {
        updates.role = role;
    }

    // If no updates are provided, return an error
    if (Object.keys(updates).length === 0) {
        return res.status(400).json({ message: 'No fields to update. Please provide at least one field.' });
    }

    try {
        // Find the user and update their profile
        const updatedUser = await User.findByIdAndUpdate(
            userId,
            updates,
            { new: true, runValidators: true } // Return the updated user and run validators
        );

        if (!updatedUser) {
            return res.status(404).json({ message: 'User not found.' });
        }

        // Respond with updated user data (excluding sensitive info)
        res.json({
            id: updatedUser.id,
            name: updatedUser.name,
            surname: updatedUser.surname,
            role: updatedUser.role
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Internal server error', error: err.message });
    }
};