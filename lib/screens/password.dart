import 'package:flutter/material.dart';
import 'package:prodigenius_application/Screens/privacySecurity.dart';

import '../../../components/upper_header.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: he * 0.03, right: he * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              upperHeader(
                "Change Password",
                context,
                false,
                page: const PrivacySecurity(),
              ),
              SizedBox(height: he * 0.042),
              Text(
                'Your password must be atleast 8 characters and should include a combination of numbers,letters and special characters ',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: he * 0.01),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  labelText: 'Current Password',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),

                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                ),
              ),
              SizedBox(height: he * 0.01),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  labelText: 'New Password',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),

                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                ),
              ),
              SizedBox(height: he * 0.01),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),

                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                ),
              ),

              SizedBox(height: he * 0.06),
              SizedBox(
                // Replaced Container with SizedBox for sizing
                width: double.infinity,
                height: he * 0.07,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Defines the button's background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
