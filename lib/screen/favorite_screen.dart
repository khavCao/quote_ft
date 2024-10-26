// ignore_for_file: avoid_print, prefer_is_empty

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quote/api/favorite_api.dart';
import 'package:quote/models/quote_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with SingleTickerProviderStateMixin {
  List<Quote> quoteSave = [];
  List<Quote> quoteByUser = [];
  late TabController _tabController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
    getQuoteByUser();
    _tabController = TabController(length: choices.length, vsync: this);
    
    // Start 2-second timer to toggle isLoading
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final data = await FavoriteApi().FetchAll(route: "quote/save", token: token!);

    if (data.statusCode == 200) {
      final jsonData = json.decode(data.body);
      setState(() {
        quoteSave = (jsonData['quotes'] as List)
            .map((data) => Quote.fromJson(data))
            .toList();
      });
    } else {
      print('Failed to load data!');
    }
  }

  void getQuoteByUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final data = await FavoriteApi().FetchAll(route: "quote/user", token: token!);

    if (data.statusCode == 200) {
      final jsonData = json.decode(data.body);
      setState(() {
        quoteByUser = (jsonData['quotes'] as List)
            .map((data) => Quote.fromJson(data))
            .toList();
      });
    } else {
      print('Failed to load data!');
    }
  }

  Widget _buildListView(List<Quote> quotes) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (quotes.isEmpty) {
      return const Center(child: Text('No data found'));
    } else {
      return ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final quote = quotes[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            child: Slidable(
              key: ValueKey(quote.id),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      // Add delete functionality here
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                    borderRadius: BorderRadius.circular(15),
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      // Add more functionality here
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.more_horiz,
                    label: 'More',
                    borderRadius: BorderRadius.circular(15),
                  ),
                ],
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: Text(
                      quote.text.characters.first.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    quote.text,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    quote.creditTo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: choices.map<Widget>((Choice choice) {
            return Tab(
              text: choice.title,
              icon: Icon(choice.icon),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: choices.map((Choice choice) {
          return Padding(
            padding: const EdgeInsets.all(2),
            child: choice == choices[0]
                ? _buildListView(List<Quote>.from(quoteByUser))
                : _buildListView(List<Quote>.from(quoteSave)),
          );
        }).toList(),
      ),
    );
  }
}

class Choice {
  final String title;
  final IconData icon;
  const Choice({required this.title, required this.icon});
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Yours', icon: Icons.person),
  Choice(title: 'Save', icon: Icons.save),
];
