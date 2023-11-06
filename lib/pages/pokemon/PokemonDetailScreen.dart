// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/Pokemon.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemonData;

  const PokemonDetailScreen({Key? key, required this.pokemonData}) : super(key: key);

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  String letraMaiuscula(String word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pokémon'),
      ),
      body: Center(
        child: widget.pokemonData != null
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      letraMaiuscula(widget.pokemonData.name),
                      style: TextStyle(fontSize: 24),
                    ),
                    if (!isLandscape)
                      Container(
                        height: 130,
                        width: 150,
                        child: Image.network(
                          widget.pokemonData.imagemUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Tipo do Pokemon"),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxHeight: 50,
                      ),
                      child: ListView.builder(
                        itemCount: widget.pokemonData.types.length, 
                        itemBuilder: (context, index) {
                          final type = widget.pokemonData.types[index]; 
                          return Center(
                            child: Text(letraMaiuscula(type)),
                          );
                        },
                      ),
                    ),
                    Text("Estatísticas"),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text("Stat")),
                        DataColumn(label: Text("Valor")),
                      ],
                      rows: widget.pokemonData.stats
                          .map<DataRow>((stat) => DataRow(
                                cells: [
                                  DataCell(Text(letraMaiuscula(stat.name))),
                                  DataCell(Text(stat.baseStat.toString())),  
                                  ],
                              ))
                          .toList(),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
