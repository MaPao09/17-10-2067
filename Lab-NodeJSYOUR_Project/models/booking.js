const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
    roomName: { type: String, required: true },
    date: { type: Date, required: true },
    bookings: [{
        timeSlot: { type: Number, required: true },
        bookedBcy: { type: String, default: null } // Not required, defaults to null
    }]
});

const Booking = mongoose.model('Booking', bookingSchema);
module.exports = Booking;
