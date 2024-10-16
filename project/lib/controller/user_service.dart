import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/config/varbles.dart';
import 'package:project/model/user_model.dart';

class UserService {
Future<User?> fetchUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$apiURL/api/user/profile'),
        headers: {
          'Authorization': 'Bearer $token', // ส่ง token ใน headers
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body)); // แปลง JSON เป็น User
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

 Future<void> updateUserProfile(String token, User user) async {
    final response = await http.put(
      Uri.parse('$apiURL/api/user/profile'), // Endpoint to update user profile
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': user.name,
        'surname': user.surname,
        'role': user.role,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}'); // Throw an error if the update fails
    }
  }
  
}