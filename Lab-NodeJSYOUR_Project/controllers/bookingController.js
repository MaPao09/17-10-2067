const Booking = require("../models/booking"); // Corrected path reference

exports.addBookingTime = async (req, res) => {
  const { roomName, date } = req.body;

  try {
    // Check if a booking with the same room name and date already exists
    const existingBooking = await Booking.findOne({
      roomName: roomName,
      date: new Date(date),
    });

    if (existingBooking) {
      return res
        .status(400)
        .json({
          message: "This room name is already booked for the selected date.",
        });
    }

    // Create a new Booking document with provided values
    const newBooking = new Booking({
      roomName: roomName,
      date: new Date(date), // Ensure the date is a JavaScript Date object
      bookings: [
        { timeSlot: 1, bookedBy: null },
        { timeSlot: 2, bookedBy: null },
        { timeSlot: 3, bookedBy: null },
        { timeSlot: 4, bookedBy: null },
        { timeSlot: 5, bookedBy: null },
      ],
    });

    const savedBooking = await newBooking.save();

    res.status(201).json(savedBooking);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.updateBooking = async (req, res) => {
    const bookedBy = req.user.userId;
    const { id } = req.body;

    // Validate that the ID is provided
    if (!id) {
        return res.status(400).json({ message: "Booking ID is required" });
    }

    console.log("Request Body:", req.body);
    console.log("User ID:", bookedBy);

    try {
        // Find the booking by ID and update the bookedBy field
        const updatedBooking = await Booking.findOneAndUpdate(
            { "bookings._id": id },  // Correct query to find booking by ID
            { $set: { "bookings.$.bookedBcy": bookedBy } },  // Correct update path
            { new: true }  // Return the updated document
        );

        if (!updatedBooking) {
            console.log("404: Booking not found");
            return res.status(404).json({ message: "Booking not found" });
        }

        console.log("Updated Booking:", updatedBooking);
        res.status(200).json(updatedBooking);
    } catch (err) {
        console.error("Error updating booking:", err);
        res.status(500).json({ message: "Internal Server Error" });
    }
};


exports.getBookingTimes = async (req, res) => {
  const { room, date } = req.query; // Extract both room and date from the query
  console.log(room);
  try {
    // Validate and parse the date
    const parsedDate = new Date(date);
    if (isNaN(parsedDate.getTime())) {
      return res
        .status(400)
        .json({ message: "Invalid date format. Expected format: YYYY-MM-DD." });
    }

    // Check if room is provided and is not empty
    if (!room || typeof room !== "string" || room.trim() === "") {
      return res.status(400).json({ message: "Invalid room name provided." });
    }

    // Create start and end of the day for querying
    const startOfDay = new Date(parsedDate.setHours(0, 0, 0, 0));
    const endOfDay = new Date(parsedDate.setHours(23, 59, 59, 999));

    // Find all bookings for the specified date range and room name
    const bookings = await Booking.find({
      date: {
        $gte: startOfDay,
        $lte: endOfDay,
      },
      roomName: room, // Filter by room name
    });

    // Check if there are any bookings for the given date and room
    if (bookings.length === 0) {
      return res
        .status(404)
        .json({
          message: "No bookings found for the specified date and room name.",
        });
    }

    // Prepare response data, including the _id field for each booking
    const response = bookings.map((booking) => ({
      roomName: booking.roomName,
      date: booking.date.toISOString().split("T")[0], // YYYY-MM-DD format
      bookings: booking.bookings.map(({ _id, timeSlot, bookedBcy }) => ({
        id: _id, // Include the ID of each individual booking
        timeSlot,
        bookedBy: bookedBcy, // Optional: Change bookedBcy to bookedBy
      })),
    }));

    // Respond with the bookings for the specified date and room
    res.status(200).json(response);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal Server Error" });
  }
};
