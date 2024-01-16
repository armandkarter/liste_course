import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';
import 'dart:convert';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialisation des préférences partagées
  await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liste de Courses',
      home: FutureBuilder<List<Article>>(
        // Récupérer la liste des articles depuis SharedPreferences
        future: _getSavedArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return HomeScreen(articles: snapshot.data ?? []);
          }
        },
      ),
    );
  }

  Future<List<Article>> _getSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticles = prefs.getStringList('articles') ?? [];

    // Convertir la liste de chaînes en une liste d'objets Article
    return savedArticles.map((articleString) {
      return Article.fromJson(jsonDecode(articleString));
    }).toList();
  }
}
