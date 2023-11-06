// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/StatusPokemon.dart';
import '../../model/Pokemon.dart';
import 'PokemonDetailScreen.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  List<Pokemon> pokemonList = [];
  int PokemonId = 1;

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
  }

  void fetchPokemonData() async {
    final Dio dio = Dio();
    for (int i = 1; i <= 30; i++) {
      try {
        final response = await dio.get('https://pokeapi.co/api/v2/pokemon/$i');
        final abilities = response.data['abilities'] as List;
        final stats = response.data['stats'] as List;
        final types = response.data['types'] as List;

        final pokemon = Pokemon(
          name: response.data['name'],
          imagemGifUrl: response.data["sprites"]["versions"]["generation-v"]
              ["black-white"]["animated"]["front_default"],
          imagemUrl: response.data['sprites']['front_default'],
          stats: stats.map((statData) {
            return StatusPokemon(
              baseStat: statData['base_stat'],
              name: statData['stat']['name'],
            );
          }).toList(),
          types: types.map((typeData) {
            return typeData['type']['name'];
          }).toList(),
        );

        setState(() {
          pokemonList.add(pokemon);
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  String letraMaiuscula(String word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Defina o número de colunas desejado
      ),
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        final pokemon = pokemonList[index];
        final pokemonName = pokemon.name;
        final pokemonImg = pokemon.imagemGifUrl;
        final pokemonUrl = pokemon.imagemUrl;
        int num = index + 1;
        String formattedNumber = num.toString().padLeft(3, '0');
        return Card(
          // Você pode personalizar o visual do Card
          child: InkWell(
            onTap: () {
              // Navegar para a tela de detalhes do Pokémon
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailScreen(
                    pokemonData: pokemon,
                  ),
                ),
              );
            },
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('$formattedNumber - ${letraMaiuscula(pokemonName)}'),
              Container(
                height: 47,
                width: 50,
                child: Image.network(pokemonImg, fit: BoxFit.cover),
              ),
            ]),
          ),
        );
      },
    );
  }
}
