// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class NewQuoteScreen extends StatefulWidget {
  @override
  _NewQuoteScreenState createState() => _NewQuoteScreenState();
}

class _NewQuoteScreenState extends State<NewQuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quoteController = TextEditingController();
  final _creditToController = TextEditingController();

  @override
  void dispose() {
    _quoteController.dispose();
    _creditToController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final quote = _quoteController.text;
      final creditTo = _creditToController.text;

      // You can add your logic to save the quote here

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote added successfully!')),
      );

      // Clear the form
      _quoteController.clear();
      _creditToController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[100]!, Colors.purple[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _quoteController,
                decoration: InputDecoration(
                  labelText: 'Quote',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quote';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _creditToController,
                decoration: InputDecoration(
                  labelText: 'Credit To',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the credit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Add Quote',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
