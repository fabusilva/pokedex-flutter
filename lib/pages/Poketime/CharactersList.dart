import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/item.dart';
import 'package:flutter_application_1/pages/Poketime/NewItem.dart';
import 'package:http/http.dart' as http;

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

        List<Item> items = (data as List).map((item) {
          return Item.fromMap(item);
        }).toList();

        setState(() {
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    _updateItem(charactersItems[index]);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteItem(charactersItems[index].id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addItem() async {
    try {
      dynamic newItem = await Navigator.of(context).push<Item>(
        MaterialPageRoute(
          builder: (ctx) => NewItem(
            item: null,
          ),
        ),
      );
      if (newItem != null) {
        print('Teste do id do newItem: ${newItem.id}');
        if (newItem.id == null) {
          final response = await http.post(
            Uri.parse("http://localhost:8000/api/user"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(newItem.toMap()),
          );

          if (response.statusCode == 200) {
            print("Objeto adicionado com sucesso!");
            setState(() {
              charactersItems.clear();
              _loadCharacters();
            });
          } else {
            print('Erro ao criar um novo item: ${response.statusCode}');
          }
        } 
        if(newItem.id != null) {
          print('Teste do id do newItem: ${newItem.id}');
          final response = await http.put(
            Uri.parse('http://localhost:8000/api/user/update/${newItem.id}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(newItem.toMap()),
          );
          if (response.statusCode == 200) {
            setState(() {
              charactersItems.clear();
              _loadCharacters();
            });
          } else {
            print('Erro ao Atualizar item: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      print('Erro ao adicionar item: $e');
    }
  }

  void _deleteItem(String? index) async {
    try {
      final response = await http
          .delete(Uri.parse("http://localhost:8000/api/user/delete/$index"));
      if (response.statusCode == 200) {
        setState(() {
          charactersItems.clear();
          _loadCharacters();
        });
      } else {
        print('Erro ao excluir o item: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  void _updateItem(Item item) async {
    dynamic newItem = await Navigator.of(context).push<Item>(
      MaterialPageRoute(
        builder: (ctx) => NewItem(
          item: item,
        ),
      ),
    );
  }
}
