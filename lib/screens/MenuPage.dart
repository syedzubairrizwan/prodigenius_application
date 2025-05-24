import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:prodigenius_application/screens/ContactPage.dart';
import 'package:prodigenius_application/screens/HomePage.dart';
import 'package:prodigenius_application/screens/Settings.dart';
import 'package:prodigenius_application/screens/HelpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sign out. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          left: he * 0.03,
          right: he * 0.03,
          top: he * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: he * 0.03, bottom: he * 0.03),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ),
                      );
                    },
                    child: const Icon(Icons.close_rounded, size: 30),
                  ),
                  SizedBox(width: he * 0.01),
                ],
              ),
            ),
            SizedBox(height: he * 0.13),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUs()),
                );
              },
              child: const Text('Contact Us', style: TextStyle(fontSize: 30)),
            ),
            SizedBox(height: he * 0.03),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              },
              child: const Text('Help', style: TextStyle(fontSize: 30)),
            ),
            SizedBox(height: he * 0.03),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const settingsPage()),
                );
              },
              child: const Text('Settings', style: TextStyle(fontSize: 30)),
            ),
            SizedBox(height: he * 0.03),
            GestureDetector(
              onTap: _signOut,
              child: const Text('Logout', style: TextStyle(fontSize: 30)),
            ),
          ],
        ),
      ),
    );
  }
}
