import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/config/varbles.dart';
import 'package:project/model/booking_model.dart'; // Make sure you import your model

class BookingService {
  Future<List<Welcome>?> fetchBookings(String date, String? room) async {
    try {
      // Construct the URL with date and optional room parameters
      final uri = Uri.parse(
          '$apiURL/api/booking/bookings?date=$date${room != null ? '&room=$room' : ''}');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Welcome.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateBooking(String id, String token) async {
    final response = await http.put(
      Uri.parse('$apiURL/api/booking/booking'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update booking');
    }
  }
}
