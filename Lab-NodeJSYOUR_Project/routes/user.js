const express = require("express");
const router = express.Router();

const { register, login, refresh, fetchUserProfile, editProfile } = require("../controllers/userController");
const authenticateToken = require("../middlewares/auth");
router.post("/", async (req,res) => {
    res.sendStatus(400);
});


router.get("/profile" ,authenticateToken, fetchUserProfile);
router.put("/profile" ,authenticateToken, editProfile);

module.exports = router;