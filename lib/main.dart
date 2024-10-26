import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quote/screen/login_screen.dart';
import 'package:quote/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MyApp.isLoggedIn.value = prefs.containsKey('token');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: MyApp.isLoggedIn,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: _isLoading 
              ? Center(child: CircularProgressIndicator()) 
              : (MyApp.isLoggedIn.value ? const HomeScreenWithAppBar() : const LoginScreen()),
        );
      },
    );
  }
}

class HomeScreenWithAppBar extends StatelessWidget {
  const HomeScreenWithAppBar({super.key});

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    MyApp.isLoggedIn.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeScreen(),
    );
  }
}
