const express = require("express");
const router = express.Router();
const { addBookingTime, updateBooking, getBookingTimes } = require("../controllers/bookingController");
const authenticateToken = require("../middlewares/auth");

router.post("/booking",authenticateToken, addBookingTime);//สร้างคิวแต่ล่ะวัน
router.put("/booking",authenticateToken,updateBooking);//จองห้องประชุม
router.get("/bookings",getBookingTimes);

module.exports = router;
