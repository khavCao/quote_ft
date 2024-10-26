// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:quote/screen/favorite_screen.dart';
import 'package:quote/screen/new_screen.dart';
import 'package:quote/screen/quote_sreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences _preferences;
  bool _isLoading = false;
  int _currentIndex = 0;

  // Initialize SharedPreferences and get user data
  @override
  void initState() {
    super.initState();
    _getUserData();
       checkLoginStatus();
  }

  // This method fetches the user data
  void _getUserData() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    _preferences = await SharedPreferences.getInstance();
    final token = _preferences.getString('token');

    // Redirect to login if token is not found
    if (token == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    }

    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  // This method updates the selected index for the bottom navigation bar
  void _navigateBottomBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List _pages = [
    QuoteScreen(),
    FavoriteScreen(),
    NewQuoteScreen()
  ];

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HomeScreen.isLoggedIn.value = prefs.containsKey('token');
  }

Future<void> logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('user');
  HomeScreen.isLoggedIn.value = false;

  // Navigate to the login page without refreshing
  Navigator.of(context).pushReplacementNamed('/login');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading 
            ? Center(child: CircularProgressIndicator()) 
            : _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateBottomBar,
        items: [
          // Home
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'New',
          ),
        ],
      ),
    );
  }
}
