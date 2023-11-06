import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/db.dart';
import 'package:flutter_application_1/model/item.dart';
import 'package:flutter_application_1/pages/Poketime/NewItem.dart';

class CharactersList extends StatefulWidget {
  @override
  _CharactersListState createState() => _CharactersListState();
}

class _CharactersListState extends State<CharactersList> {
  final List<Item> charactersItems = [];
  final DB db = DB();

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  void _loadCharacters() async {
    final characters = await db.getAllItem();
    setState(() {
      charactersItems.addAll(characters);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personagens'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: charactersItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(charactersItems[index]
                .nomeJogador), // Usar o atributo de nome do item
          );
        },
      ),
    );
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<Item>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem != null) {
      setState(() {
        db.createItem(newItem);
        charactersItems.add(newItem);
      });
    }
  }
}
