// ignore_for_file: avoid_print

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

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Quote> quotes = [];

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final data = await FavoriteApi().FetchAll(route: "quote", token: token!);

    if (data.statusCode == 200) {
      final jsonData = json.decode(data.body);
      setState(() {
        quotes = (jsonData['quotes'] as List)
            .map((data) => Quote.fromJson(data))
            .toList();
      });
    } else {
      print('Failed to load data!');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget _buildListView() {
    if (quotes.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
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
                      // Add a favorite action here
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                    borderRadius: BorderRadius.circular(15),
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      // Add a favorite action here
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
      body: _buildListView(),
    );
  }
}
