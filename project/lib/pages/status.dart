import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/controller/bookin_service.dart';
import 'package:project/model/booking_model.dart';
import 'package:project/providers/user_provider.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  DateTime selectedDate = DateTime.now();
  List<Welcome> bookings = [];
  final BookingService bookingService = BookingService();
  bool isLoading = false;

  List<String> rooms = ["Room A", "Room B", "Room C", "Room D"];
  String? selectedRoom;

  Future<void> fetchBookings() async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    setState(() {
      isLoading = true;
    });

    try {
      List<Welcome>? fetchedBookings = await bookingService.fetchBookings(formattedDate, selectedRoom);
      setState(() {
        bookings = fetchedBookings ?? [];
      });

      if (bookings.isEmpty) {
        _showSnackBar('No bookings found for the selected date and room.');
      }
    } catch (e) {
      _showSnackBar('Error fetching bookings: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    selectedRoom = rooms[0]; // Set default selected room
    fetchBookings();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        bookings.clear();
      });
      fetchBookings();
    }
  }

  Future<void> _confirmBooking(String id) async {
    bool confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: Text('Are you sure you want to book this slot?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Confirm')),
          ],
        );
      },
    ) ?? false;

    if (confirm) {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final response = await bookingService.updateBooking(id, userProvider.accessToken);
        _showSnackBar('Booking updated successfully!');
        fetchBookings();
      } catch (error) {
        _showSnackBar('Error updating booking: $error');
      }
    }
  }

  String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date.toLocal());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Selected Date: ${formatDate(selectedDate)}', style: TextStyle(fontSize: 16)),
                IconButton(icon: Icon(Icons.calendar_today), onPressed: () => _selectDate(context)),
              ],
            ),
            DropdownButton<String>(
              hint: Text('Select Room'),
              value: selectedRoom,
              onChanged: (String? newValue) {
                setState(() {
                  selectedRoom = newValue;
                  bookings.clear();
                });
                fetchBookings();
              },
              items: rooms.map<DropdownMenuItem<String>>((String room) {
                return DropdownMenuItem<String>(value: room, child: Text(room));
              }).toList(),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : fetchBookings,
              child: isLoading
                  ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                  : Text('Fetch Bookings'),
            ),
            SizedBox(height: 20),
            bookings.isEmpty
                ? Text('No bookings found. Please select a room and date, and fetch bookings.')
                : DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.blue),
                    columnSpacing: 12,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    columns: [
                      DataColumn(label: Text('Room', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Date', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Time Slot', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Booked', style: TextStyle(color: Colors.white))),
                    ],
                    rows: bookings.expand((booking) {
                      return booking.bookings.map((b) {
                        return DataRow(cells: [
                          DataCell(Text(booking.roomName)),
                          DataCell(Text(formatDate(booking.date))),
                          DataCell(Text(b.timeSlot.toString())),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                if (b.bookedBy == null) {
                                  _confirmBooking(b.id);
                                } else {
                                  _showSnackBar('Already booked');
                                }
                              },
                              child: Text(
              b.bookedBy != null ? 'Booked' : 'Available',
         style: TextStyle(color: b.bookedBy == null ? Colors.green : Colors.red),
            ),
                            ),
                          ),
                        ]);
                      });
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
