import 'package:flutter/material.dart';
import 'package:project/controller/user_service.dart';
import 'package:project/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  final String token; // Accept token as a parameter

  ProfilePage({required this.token});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User?> userProfile;
  late User? user;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  bool _isEditable = false; // Variable to track edit state

  @override
  void initState() {
    super.initState();
    userProfile = UserService().fetchUserProfile(widget.token); // Fetch user profile data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[50], // Light blue background
        padding: const EdgeInsets.all(16.0), // Add padding around the container
        child: FutureBuilder<User?>(
          future: userProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingIndicator(); // Show loading indicator
            } else if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString()); // Show error message with retry option
            } else if (snapshot.hasData && snapshot.data != null) {
              user = snapshot.data;
              // Initialize controllers with user data
              _nameController.text = user!.name;
              _surnameController.text = user!.surname;
              _roleController.text = user!.role;

              return _buildUserProfileForm(); // Build user profile form
            } else {
              return _buildNoDataState(); // Handle case with no data
            }
          },
        ),
      ),
    );
  }

  // Method to build loading indicator
  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  // Method to build error state
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: $error',
            style: TextStyle(color: Colors.red, fontSize: 16), // Red error text
            textAlign: TextAlign.center, // Center the error message
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), // Button color
            onPressed: () {
              setState(() {
                userProfile = UserService().fetchUserProfile(widget.token); // Retry fetching user profile
              });
            },
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }

  // Method to build user profile form
  Widget _buildUserProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Center the column vertically
        crossAxisAlignment: CrossAxisAlignment.center, // Align text to center
        children: [
          _buildEditableField('Name', _nameController),
          SizedBox(height: 10),
          _buildEditableField('Surname', _surnameController),
          SizedBox(height: 10),
          _buildEditableField('Role', _roleController),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), // Button color
            onPressed: _submitForm,
            child: Text("Update Profile"), // Button to submit changes
          ),
        ],
      ),
    );
  }

  // Method to build editable text field with pencil icon
  Widget _buildEditableField(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the row
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.blue[800]), // Label color
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue[800]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue[600]!),
              ),
              prefixIcon: const Icon(Icons.person, color: Colors.blue), // Prefix icon
            ),
            style: const TextStyle(color: Colors.blue), // Set text color to blue
            readOnly: !_isEditable, // Make the field read-only if not editable
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your $label';
              }
              return null;
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit), // Pencil icon
          onPressed: () {
            setState(() {
              _isEditable = true; // Enable editing mode
            });
          },
        ),
      ],
    );
  }

  // Method to handle form submission
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, proceed with the update
      final updatedUser = User(
        id: user!.id,
        name: _nameController.text,
        surname: _surnameController.text,
        role: _roleController.text,
      );

      try {
        await UserService().updateUserProfile(widget.token, updatedUser); // Call the update method
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        setState(() {
          userProfile = UserService().fetchUserProfile(widget.token); // Refresh profile
          _isEditable = false; // Disable editing mode after submission
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $error')),
        );
      }
    }
  }

  // Method to handle no data state
  Widget _buildNoDataState() {
    return Center(
      child: Text(
        'No data found.',
        style: TextStyle(fontSize: 16, color: Colors.blue[900]), // Darker blue for text
      ),
    );
  }
}
