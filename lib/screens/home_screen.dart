import 'package:flutter/material.dart';
import 'add_edit_screen.dart';
import '../models/article.dart';
import 'settings_screen.dart';
import 'article_repository.dart';

class HomeScreen extends StatefulWidget {
  final List<Article> articles; // Ajoutez le paramètre articles
  HomeScreen({Key? key, required this.articles}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> articles = [];
  bool isSelecting = false;
  List<Article> selectedArticles = [];
  final ArticleRepository articleRepository = ArticleRepository();

  @override
   void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    List<Article> loadedArticles = await articleRepository.getArticlesFromSharedPreferences();
    setState(() {
      articles = loadedArticles;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSelecting ? Text('${selectedArticles.length} sélectionnés') : Text('Liste de Courses'),
        actions: [
          if (isSelecting)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, selectedArticles);
              },
            )
          else
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _openSettingsScreen();
              },
            ),
          IconButton(
            icon: isSelecting ? Icon(Icons.close) : Icon(Icons.check),
            onPressed: () {
              setState(() {
                isSelecting = !isSelecting;
                if (!isSelecting) {
                  selectedArticles.clear();
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Nom')),
            DataColumn(label: Text('Catégorie')),
            DataColumn(label: Text('Quantité')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Heure')),
            if (isSelecting) DataColumn(label: Text('Sélectionner')),
            DataColumn(label: Text('Actions')),
          ],
          rows: articles.map((article) {
            final isSelected = selectedArticles.contains(article);

            return DataRow(
              selected: isSelected,
              onSelectChanged: (selected) {
                setState(() {
                  if (selected!) {
                    selectedArticles.add(article);
                  } else {
                    selectedArticles.remove(article);
                  }
                });
              },
              cells: [
                DataCell(Text(article.name)),
                DataCell(Text(article.category)),
                DataCell(Text(article.quantity.toString())),
                DataCell(Text(article.timestamp.toLocal().toLocal().toString().split('.')[0])),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article.timestamp.toLocal().toLocal().toString().split(' ')[1]), // Afficher l'heure
                    ],
                  ),
                ),
                if (isSelecting) DataCell(Checkbox(value: isSelected, onChanged: (selected) {})),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToAddEditScreen(context, article: article);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, [article]);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: isSelecting
          ? null
          : FloatingActionButton(
              onPressed: () {
                _navigateToAddEditScreen(context);
              },
              child: Icon(Icons.add),
            ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, List<Article> articlesToDelete) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Supprimer les articles sélectionnés ?'),
          content: Text('Voulez-vous vraiment supprimer ces articles ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Confirme la suppression
                Navigator.of(context).pop(true);
                setState(() {
                  articles.removeWhere((article) => articlesToDelete.contains(article));
                  selectedArticles.clear();
                });
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToAddEditScreen(BuildContext context, {Article? article}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditScreen(existingArticle: article),
      ),
    );

    if (result != null) {
      if (result is Article) {
        // Modification d'un article existant
        if (article != null) {
          setState(() {
            articles[articles.indexOf(article)] = result;
          });
        } else {
          // Ajout d'un nouvel article
          setState(() {
            articles.add(result);
          });
        }
      } else if (result is bool && result) {
        // Suppression d'un article
        if (article != null) {
          setState(() {
            articles.remove(article);
          });
        }
      }
    }
  }

  void _openSettingsScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(onSortingOptionChanged: _handleSortingOptionChanged),
      ),
    );

    // Gérez le résultat de SettingsScreen ici si nécessaire
  }

  void _handleSortingOptionChanged(String sortingOption) {
    // Gérez le tri ici en fonction de l'option sélectionnée
    // Par exemple, si vous avez une liste d'articles, vous pourriez trier la liste ici
    if (sortingOption == 'Nom') {
      articles.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortingOption == 'Quantité') {
      articles.sort((a, b) => a.quantity.compareTo(b.quantity));
    }
  }
}
