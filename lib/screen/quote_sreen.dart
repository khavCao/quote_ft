// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quote/api/favorite_api.dart';
import 'package:quote/api/quote_api.dart';
import 'package:quote/models/quote_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  List<QuoteModel> quotes = [];
  void getQuotes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final data = await QuoteApi.fetchAll("quote", token!);

      if (data.isNotEmpty) {
        setState(() {
          quotes = data.cast<QuoteModel>();
        });
      }
    } catch (e) {
      print("Error fetching quotes: $e");
    }
  }

  void toggleFavorite(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final respone = await FavoriteApi().toggleFav(route: "quote", token: token!, id: id);
      if (respone.statusCode == 200) {
        final data = jsonDecode(respone.body);
        final message = data['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      print("Error fetching quotes: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getQuotes();
  }

  final PageController _pageController = PageController();
  int currentPage = 0;

  void nextPage() {
    if (currentPage < quotes.length - 1) {
      setState(() {
        currentPage++;
      });
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: quotes.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.format_quote,
                            size: 50,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            quote.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            quote.credit_to ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                              height: 20), // Add space before the buttons
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.favorite,
                                      size: 30, color: Colors.red),
                                  onPressed: () {
                                    toggleFavorite(quote.id);
                                  },
                                ),
                                const SizedBox(
                                    width: 20), // Spacing between buttons
                                IconButton(
                                  icon: const Icon(Icons.save,
                                      size: 30, color: Colors.green),
                                  onPressed: () {
                                    // Add your save logic here
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Show back button only if it's not the first quote
          if (currentPage > 0)
            Positioned(
              left: 20,
              top: MediaQuery.of(context).size.height * 0.5,
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, size: 40, color: Colors.teal),
                onPressed: previousPage,
              ),
            ),
          // Show forward button only if it's not the last quote
          if (currentPage < quotes.length - 1)
            Positioned(
              right: 20,
              top: MediaQuery.of(context).size.height * 0.5,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward,
                    size: 40, color: Colors.teal),
                onPressed: nextPage,
              ),
            ),
        ],
      ),
    );
  }
}
