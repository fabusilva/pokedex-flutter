import 'dart:convert'; // Adicione esta importação

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  final Item? item;

  NewItem({Key? key, required this.item}) : super(key: key);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeJogadorController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  String? _pokemonPreferido;
  String? _jogoPreferido;
  String? _id;
  bool _termosDeUsoAceitos = false;

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      _id = widget.item!.id;
      _nomeJogadorController.text = widget.item!.nome;
      _idadeController.text = widget.item!.idade.toString();
      _pokemonPreferido = widget.item!.jogoFavorito;
      _jogoPreferido = widget.item!.pokemonInicial;
    }
  }

  Future<void> updateItem(Item newItem) async {
    try {
      if (newItem.id != null) {
        // Corrigi aqui, usando _id em vez de newItem.id
        print('Teste do id do newItem: ${newItem.id}');

        final response = await http.put(
          Uri.parse('http://localhost:8000/api/user/update/${newItem.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(newItem
              .toMap()), // Corrigi aqui, usando widget.item em vez de newItem
        );

        if (response.statusCode == 200) {
          print("Put realizado com sucesso!");
        } else {
          print('Erro ao Atualizar item: ${response.statusCode}');
        }
      } else {
        print('ID do newItem é nulo. A atualização não é possível.');
      }
    } catch (e) {
      print('Erro ao adicionar item: $e');
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate() && _termosDeUsoAceitos) {
      _formKey.currentState!.save();

      Item newItem = Item(
        id: _id,
        nome: _nomeJogadorController.text,
        foto:
            "https://example.com/default-image.jpg", // Adicionei uma URL de imagem
        jogoFavorito: _pokemonPreferido,
        pokemonInicial: _jogoPreferido,
        idade: int.tryParse(_idadeController.text),
      );

      updateItem(newItem);
      print("Novo Item:");
      print("ID: ${newItem.id}");
      print("Nome: ${newItem.nome}");
      print("Foto: ${newItem.foto}");
      print("Jogo Favorito: ${newItem.jogoFavorito}");
      print("Pokemon Inicial: ${newItem.pokemonInicial}");
      print("Idade: ${newItem.idade}");

      Navigator.of(context).pop(newItem);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Você deve aceitar os termos de uso para inserir o item.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Novo Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeJogadorController,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Nome do Jogador',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Deve-se especificar no máximo 50 caracteres.';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _idadeController,
                      decoration: const InputDecoration(
                        labelText: 'Idade do Jogador',
                      ),
                    ),
                  ),
                ],
              ),
              const Text('Pokemon Preferido:'),
              Row(
                children: [
                  Radio<String>(
                    value: 'Bulbasaur',
                    groupValue: _pokemonPreferido,
                    onChanged: (value) {
                      setState(() {
                        _pokemonPreferido = value;
                      });
                    },
                  ),
                  const Text('Bulbasaur'),
                ],
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'Charmander',
                    groupValue: _pokemonPreferido,
                    onChanged: (value) {
                      setState(() {
                        _pokemonPreferido = value;
                      });
                    },
                  ),
                  const Text('Charmander'),
                ],
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'Squirtle',
                    groupValue: _pokemonPreferido,
                    onChanged: (value) {
                      setState(() {
                        _pokemonPreferido = value;
                      });
                    },
                  ),
                  const Text('Squirtle'),
                ],
              ),
              const Text('Jogo Preferido:'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _jogoPreferido,
                      items: [
                        DropdownMenuItem(
                          value: 'Red/Blue',
                          child: const Text('Red/Blue'),
                        ),
                        DropdownMenuItem(
                          value: 'Gold/Silver',
                          child: const Text('Gold/Silver'),
                        ),
                        DropdownMenuItem(
                          value: 'Ruby/Sapphire',
                          child: const Text('Ruby/Sapphire'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _jogoPreferido = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _termosDeUsoAceitos,
                    onChanged: (value) {
                      setState(() {
                        _termosDeUsoAceitos = value!;
                      });
                    },
                  ),
                  const Text('Aceitar os termos de uso'),
                ],
              ),
              ElevatedButton(
                onPressed: _saveItem,
                child: const Text('Inserir item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
