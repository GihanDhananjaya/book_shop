
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/app_button.dart';
import '../../../common/app_password_field.dart';
import '../../../common/app_text_field.dart';
import '../../../utils/app_colors.dart';

class RegistrationLoginScreen extends StatefulWidget {
  @override
  _RegistrationLoginScreenState createState() =>
      _RegistrationLoginScreenState();
}

class _RegistrationLoginScreenState extends State<RegistrationLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _userName = '';
  String _phoneNumber = '';
  String _profileImageURL = ''; // Firebase Storage එකට URL

  bool _isRegistering = false;

  void _registerUser() async {
    if (_password != _confirmPassword) {
      _showAlertDialog('Password Mismatch', 'Passwords do not match. Please try again.');
      return;
    }

    setState(() {
      _isRegistering = true;
    });

    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);

      final User? user = userCredential.user;
      if (user != null) {
        // Firebase Firestore එකට user data ඇතුලත් කරනවා
        await _firestore.collection('users').doc(user.uid).set({
          'userName': _userName,
          'email': _email,
          'phoneNumber': _phoneNumber,
          'profileImageURL': _profileImageURL,
        });

        _showAlertDialog('Registration Successful', 'User registration was successful.');
        _clearInputFields();
      }
    } catch (e) {
      print('Error during registration: $e');
      _showAlertDialog('Registration Error', 'An error occurred during registration. Please try again.');
    } finally {
      setState(() {
        _isRegistering = false;
      });
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearInputFields() {
    setState(() {
      _email = '';
      _password = '';
      _confirmPassword = '';
      _userName = '';
      _phoneNumber = '';
      _profileImageURL = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.fontColorWhite.withOpacity(0.5),
              AppColors.colorPrimary.withOpacity(0.5),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(26.0),
            child: Column(
              children: [
                SizedBox(height: 50,),
                Text('User Registration',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                    color: AppColors.fontColorDark)),

                SizedBox(height: 20),
                AppTextField(
                  onTextChanged: (value) {
                    setState(() {
                      _userName = value;
                    });
                  },
                  hint: "User Name",
                ),
                SizedBox(height: 10),
                AppTextField(
                  onTextChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  hint: "Email Address",
                ),
                SizedBox(height: 10),
                AppTextField(
                  onTextChanged: (value) {
                    setState(() {
                      _phoneNumber = value;
                    });
                  },
                  hint: "Phone Number",
                ),
                SizedBox(height: 10),
                AppPasswordField(
                  onTextChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  hint: "Password",
                ),
                SizedBox(height: 10),
                AppPasswordField(
                  onTextChanged: (value) {
                    setState(() {
                      _confirmPassword = value;
                    });
                  },
                  hint: "Confirm Password",
                ),
                SizedBox(height: 250,),
                // ElevatedButton(
                //   onPressed: _isRegistering ? null : _registerUser,
                //   child: _isRegistering
                //       ? CircularProgressIndicator()
                //       : Text('Register'),
                // ),
                AppButton(buttonText: "Register",
                    onTapButton: _registerUser

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
