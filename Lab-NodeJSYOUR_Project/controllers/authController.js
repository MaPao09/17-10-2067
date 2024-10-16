const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");

// Register
exports.register = async (req, res) => {
    const { id, name, surname, password, role = 'user' } = req.body;

    try {
        // Check if a user with the same ID already exists
        const existingUser = await User.findOne({ id });
        if (existingUser) {
            return res.status(409).json({ message: "User with this ID already exists" });
        }
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create and save the user
        const user = new User({ id, name, surname, password: hashedPassword, role });
        await user.save();

        res.status(201).json({ message: "User registered successfully" });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Internal server error" });
    }
};

// Get Profile 


// Login
exports.login = async (req, res) => {
    const { id, password } = req.body;

    try {
        const user = await User.findOne({ id });
        if (!user) {
            return res.status(400).json({ message: "User not found" });
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ message: "Invalid credentials" });
        }

        const accessToken = jwt.sign(
            { userId: user._id, role: user.role },
            process.env.ACCESS_TOKEN_SECRET,
            { expiresIn: "3h" }
        );

        const refreshToken = jwt.sign(
            { userId: user._id },
            process.env.REFRESH_TOKEN_SECRET
        );

        res.json({
            user: {
                id: user.id,
                name: user.name,
                surname: user.surname,
                role: user.role
            },
            accessToken,
            refreshToken
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Internal server error" });
    }
};

// Refresh
exports.refresh = async (req, res) => {
    const { token } = req.body;
    if (!token) return res.sendStatus(401);

    jwt.verify(token, process.env.REFRESH_TOKEN_SECRET, (err, user) => {
        if (err) return res.sendStatus(403);

        const accessToken = jwt.sign(
            { userId: user.userId },
            process.env.ACCESS_TOKEN_SECRET,
            { expiresIn: "15m" }
        );
        res.json({ accessToken });
    });
};

// Check username
exports.check_username = async (req, res) => {
    const { username } = req.body;
    try {
        const user = await User.findOne({ username });
        return res.json({ exists: !!user });
    } catch (err) {
        console.error(err);
        res.status(500).send(err.message);
    }
};
