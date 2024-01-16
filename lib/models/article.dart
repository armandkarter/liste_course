import 'dart:convert';

class Article {
  final String id; // Assurez-vous que le champ id est déclaré dans votre modèle

  final String name;
  final String category;
  final int quantity;
  final DateTime timestamp;

  Article({
    required this.id, // Assurez-vous que le champ id est requis
    required this.name,
    required this.category,
    required this.quantity,
    required this.timestamp,
  });
  // Méthode pour convertir un Article en un objet JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Créer une instance d'Article à partir d'un objet JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Autres membres et méthodes de la classe Article...

  // Méthode pour convertir un Article en une chaîne JSON
  String articleToJson() {
    return jsonEncode(toJson());
  }
}
