// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quote/api/user_api.dart';
import 'package:quote/screen/home_screen.dart';
import 'package:quote/screen/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void loginUser() async {
    final userData = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    final result = await UserApi().Register(route: 'login', data: userData);
    final response = jsonDecode(result.body);
    print("API Response: $response");

    if (response['status'] == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String userJson = jsonEncode(response['user']);
      await preferences.setString('user', userJson);
      await preferences.setString('token', response['access_token']);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    } else {
      // Handle error response
      print("Can't login: ${response['message']}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])), // Show error message
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 80), // Adjust top spacing
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              controller: _passwordController,
              label: 'Password',
              obscureText: _obscurePassword,
              onToggleVisibility: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                loginUser(); // Call loginUser when button is pressed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 152, 74, 166), // Purple color for the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Handle forgot password (add functionality here)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Forgot Password functionality is not implemented.')),
                );
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
