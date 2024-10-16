const express = require("express");
const router = express.Router();

const { register, login, refresh, fetchUserProfile } = require("../controllers/authController");
const authenticateToken = require("../middlewares/auth");
router.post("/", async (req,res) => {
    res.sendStatus(400);
});

router.post("/register", register);
router.post("/login" , login);
router.post("/refresh" , refresh);


module.exports = router;