import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:project/controller/auth_sevice.dart';
import 'package:project/pages/booking.dart';
import 'package:project/pages/profile.dart';
import 'package:project/pages/status.dart';
import 'package:project/providers/user_provider.dart';
import 'package:provider/provider.dart';

// Assuming these views exist in your codebase
class DriverView extends StatelessWidget {
  const DriverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Driver View'));
  }
}

class RequestsView extends StatelessWidget {
  const RequestsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Requests View'));
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Notification View'));
  }
}


class UserindexView extends StatefulWidget {
  const UserindexView({Key? key}) : super(key: key);

  @override
  _UserindexViewState createState() => _UserindexViewState();
}

class _UserindexViewState extends State<UserindexView> {
  int _selectedIndex = 0;

  // Handle navigation bar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
backgroundColor: Colors.blue,
        actions: [
          IconButton(
  icon: const Icon(Icons.login, size: 30, color: Colors.white),
  onPressed: () {
    // Call the logout method
    AuthService().logout(context);
  },
),

        ],
        automaticallyImplyLeading: false,
        shape: const BeveledRectangleBorder(
          side: BorderSide(color: Colors.black38),
        ),
      ),
      body: _getBodyContent(), // Get the body based on selected index
      bottomNavigationBar: StyleProvider(
        style: Style(),
        child: ConvexAppBar(
          style: TabStyle.textIn,
          items: const [
       
            TabItem(
                icon: Icons.check_box_outlined,
                title: 'จองหอพัก'),
            TabItem(
                icon: Icons.person,
                title: 'Profile'),
          ],
          initialActiveIndex: _selectedIndex,
          onTap: _onItemTapped, // Update selected index
          activeColor: Colors.white,
          color: Colors.white,
          backgroundColor:  Colors.blue,
          height: 65,
        ),
      ),
    );
  }

  // Helper method to get the current view based on selected index

  // Helper method to get the current view based on selected index
  Widget _getBodyContent() {
    final userProvider = Provider.of<UserProvider>(context); // ใช้ UserProvider

    switch (_selectedIndex) {
      case 0:
        return StatusPage(); // Display DriverView for index 0
      
      case 1:
        return ProfilePage(token: userProvider.accessToken); // ใช้ token จาก UserProvider
      default:
        return const Center(child: Text('Unknown View')); // Default fallback view
    }
  }
}



class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 35;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 15, color: color);
  }
}
