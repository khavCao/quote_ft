// ignore_for_file: non_constant_identifier_names

class QuoteModel {
  final int id;
  final String text;
  final String ?credit_to;

    //constructor
  QuoteModel({required this.text, this.credit_to, required this.id});

  static fromJson(quote) {}

}


class Quote {
  final int id;
  final String text;
  final String creditTo;
  final int favs;

  Quote({
    required this.id,
    required this.text,
    required this.creditTo,
    required this.favs,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      text: json['text'],
      creditTo: json['credit_to'],
      favs: json['favs'],
    );
  }
}
