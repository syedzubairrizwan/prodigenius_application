import 'package:flutter/material.dart';
//import 'package:prodigenius_application/providers/task_provider.dart';
//import 'package:prodigenius_application/screens/Calendar_Screen.dart';
import 'package:prodigenius_application/screens/MenuPage.dart';
import 'package:prodigenius_application/screens/add_task_dialog.dart';

import 'package:prodigenius_application/widgets/constant.dart';
import 'package:prodigenius_application/widgets/plans.dart';
import 'package:prodigenius_application/widgets/PrimeSpace.dart';
import 'package:prodigenius_application/widgets/tasks.dart';
import 'package:prodigenius_application/widgets/ai.dart';
//import 'package:prodigenius_application/screens/Calendar_Screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Pages for the bottom navigation
  final List<Widget> _pages = [
    const Homepage(),
    const AIPage(),
    const PlansPage(),
  ];
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: _pages[_activeIndex], // Load the active page
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: _buildAppBarTitle(),
      actions: [_buildMoreActionsButton()],
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        _buildProfileImage(),
        const SizedBox(width: 10),
        const Text(
          'Prodigenius',
          style: TextStyle(
            color: Color.fromARGB(255, 116, 116, 116),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 5),
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/profile.png',
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => const Center(
                child: Icon(
                  Icons.lightbulb_rounded, // if the profile is not loaging
                  color: Color.fromARGB(255, 247, 241, 75),
                  size: 40,
                ),
              ),
        ),
      ),
    );
  }

  IconButton _buildMoreActionsButton() {
    return IconButton(
      icon: const Icon(Icons.more_vert, color: Colors.grey, size: 35),

      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MenuPage()),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey.shade400,
          currentIndex: _activeIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy, size: 30),
              label: 'AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline, size: 30),
              label: 'Plans',
            ),
          ],
          onTap: (index) {
            setState(() {
              _activeIndex = index; // Update the active page index
            });
          },
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Show the AddTaskDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddTaskDialog(
              selectedDate: DateTime.now(),
            ); // Default to today's date
          },
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: kdark,
      child: const Icon(Icons.add, color: kBlueLight, size: 35),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child:
              const MotivationalCarousel(), // Ensure GoPremium is a defined widget
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            'Tasks',
            style: TextStyle(
              color: Color.fromARGB(255, 116, 116, 116),
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Tasks()),
      ],
    );
  }
}
