import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importez le package SharedPreferences
import '../models/article.dart';
import 'dart:convert';

class AddEditScreen extends StatefulWidget {
  final Article? existingArticle;

  const AddEditScreen({Key? key, this.existingArticle}) : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _categoryController = TextEditingController();
    _quantityController = TextEditingController();

    if (widget.existingArticle != null) {
      _nameController.text = widget.existingArticle!.name;
      _categoryController.text = widget.existingArticle!.category;
      _quantityController.text = widget.existingArticle!.quantity.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _saveArticle(Article newArticle) async {
    // Lire les données actuelles depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedArticles = prefs.getStringList('articles') ?? [];

    // Convertir la liste de chaînes en une liste d'objets Article
    final List<Article> articles = savedArticles.map((articleString) {
      return Article.fromJson(jsonDecode(articleString));
    }).toList();

    // Ajouter le nouvel article à la liste
    articles.add(newArticle);

    // Convertir la liste d'objets Article en une liste de chaînes
    final List<String> articlesAsString = articles.map((article) {
      return jsonEncode(article.toJson());
    }).toList();

    // Enregistrer la liste de chaînes JSON dans SharedPreferences
    prefs.setStringList('articles', articlesAsString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingArticle != null
            ? 'Modifier l\'Article'
            : 'Ajouter un Article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom de l\'article'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'article';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Catégorie'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la quantité';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newArticle = Article(
                      id: 'unique_id', // Remplacez 'unique_id' par la valeur réelle de l'ID
                      name: _nameController.text,
                      category: _categoryController.text,
                      quantity: int.parse(_quantityController.text),
                      timestamp: DateTime.now(),
                    );

                    // Enregistrer l'article dans SharedPreferences
                    _saveArticle(newArticle);

                    // Envoyer l'article au parent (home_screen.dart) pour traitement
                    Navigator.pop(context, newArticle);
                  }
                },
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
