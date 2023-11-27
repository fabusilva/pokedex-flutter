import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/item.dart';
import 'package:flutter_application_1/pages/Poketime/NewItem.dart';
import 'package:http/http.dart' as http;  // Importe o pacote http

class CharactersList extends StatefulWidget {
  @override
  _CharactersListState createState() => _CharactersListState();
}

class _CharactersListState extends State<CharactersList> {
  List<Item> charactersItems = [];
  final String apiUrl = 'http://localhost:8000/api/user';

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Mapeia a lista de itens usando o construtor fromMap da classe Item
        List<Item> items = (data as List).map((item) {
          return Item.fromMap(item);
        }).toList();

        setState(() {
          // Atualiza o estado com os itens carregados
          charactersItems.addAll(items);
        });
      } else {
        throw Exception('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
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
            title: Text(
              charactersItems[index].nome,
            ),
            subtitle: Text(
              'Idade: ${charactersItems[index].idade.toString()}',
            ),
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
        charactersItems.add(newItem);
      });
    }
  }
}
