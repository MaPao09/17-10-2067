import 'package:flutter/material.dart';

import 'package:project/controller/auth_sevice.dart'; // Ensure you have the correct path for your AuthService

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController(); // Changed from username to ID
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController(); // New surname controller
  bool _isPasswordVisible = false;

  final AuthService authService = AuthService();
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final result = await authService.register(
        idController.text, // Updated from usernameController to idController
        nameController.text,
        surnameController.text, // Added surname
        passwordController.text,
        'user', // Default role
      );

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'], style: TextStyle(color: Colors.white)),
          backgroundColor: result['success'] ? Colors.green : Colors.red, // Different color based on success
        ),
      );

      if (result['success']) {
        _formKey.currentState?.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'REGISTER',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        _buildTextField(idController, 'ID', Icons.person), // Updated field
                        SizedBox(height: 20),
                        _buildTextField(passwordController, 'Password', Icons.lock, isPassword: true),
                        SizedBox(height: 20),
                        _buildTextField(nameController, 'Name', Icons.person_outline),
                        SizedBox(height: 20),
                        _buildTextField(surnameController, 'Surname', Icons.person_outline), // New surname field
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(width * 1, 50),
                            backgroundColor: Colors.blue[700],
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue),
        prefixIcon: Icon(icon, color: Colors.blue),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
    
        enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[600]!),
                  ),
      ),
      style: TextStyle(color: Colors.blue),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }
}
