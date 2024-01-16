import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/article.dart'; // Assurez-vous d'importer votre modèle Article

class ArticleRepository {
  // ... Autres méthodes de la classe ...

  Future<List<Article>> getArticlesFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticles = prefs.getStringList('articles') ?? [];

    return savedArticles.map((articleString) {
      return Article.fromJson(jsonDecode(articleString));
    }).toList();
  }

  // ... Autres méthodes de la classe ...
}
