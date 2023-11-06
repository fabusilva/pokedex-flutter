import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/item.dart';

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeJogadorController = TextEditingController();
  int _iniciante = 0;
  String? _pokemonPreferido;
  String? _jogoPreferido;
  bool _termosDeUsoAceitos = false;

  void _saveItem() {
  if (_formKey.currentState!.validate() && _termosDeUsoAceitos) {
    _formKey.currentState!.save();

    // Criar um objeto Item com os valores coletados
    Item newItem = Item(
      id: DateTime.now().toString(),
      nomeJogador: _nomeJogadorController.text,
      iniciante: _iniciante,
      pokemonPreferido: _pokemonPreferido,
      jogoPreferido: _jogoPreferido,
    );

    print('ID: ${newItem.id} Nome:${newItem.nomeJogador} Iniciante?${newItem.iniciante} Game favorito:${newItem.jogoPreferido} Poke preferido:${newItem.pokemonPreferido}');
    Navigator.of(context).pop(newItem);
  } else {
    // Adicione um aviso ao usuário, informando que os termos de uso precisam ser aceitos.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Você deve aceitar os termos de uso para inserir o item.'),
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
                  const Text('Iniciante:'),
                  Switch(
                    value: true,
                    onChanged: (value) {
                      setState(() {
                        _iniciante = value? 1 : 0;
                      });
                    },
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
              DropdownButton<String>(
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
