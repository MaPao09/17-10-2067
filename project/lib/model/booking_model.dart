// lib/model/booking_model.dart

class Welcome {
  String roomName;
  DateTime date;
  List<Booking> bookings;

  Welcome({
    required this.roomName,
    required this.date,
    required this.bookings,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) {
    var bookingsFromJson = json['bookings'] as List;
    List<Booking> bookingsList =
        bookingsFromJson.map((i) => Booking.fromJson(i)).toList();

    return Welcome(
      roomName: json['roomName'],
      date: DateTime.parse(json['date']),
      bookings: bookingsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomName': roomName,
      'date': date.toIso8601String(),
      'bookings': bookings.map((e) => e.toJson()).toList(),
    };
  }
}

class Booking {
  int timeSlot;
  dynamic bookedBy;
  dynamic id;


  Booking({
    required this.timeSlot,
    required this.bookedBy,
    required this.id,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      timeSlot: json['timeSlot'],
      bookedBy: json['bookedBy'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeSlot': timeSlot,
      'bookedBy': bookedBy,
      'id': id,
    };
  }
}
