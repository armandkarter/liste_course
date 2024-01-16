import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String) onSortingOptionChanged;

  const SettingsScreen({Key? key, required this.onSortingOptionChanged}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _sortingOption = 'Nom';

  void _sortListByName() {
    // Vous devrez adapter cela en fonction de votre modèle Article et de votre liste
    // Par exemple, si vous avez une liste d'articles dans HomeScreen, vous pourriez appeler une fonction de tri de là-bas
    // En supposant que vous avez un callback onSortingOptionChanged, vous pourriez faire quelque chose comme :
    widget.onSortingOptionChanged('Nom');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Options de tri :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            RadioListTile<String>(
              title: Text('Nom'),
              value: 'Nom',
              groupValue: _sortingOption,
              onChanged: (value) {
                setState(() {
                  _sortingOption = value!;
                });
                _sortListByName();
              },
            ),
            // ... (autres options de tri)
          ],
        ),
      ),
    );
  }
}
