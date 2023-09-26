/*import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_application_1/models/pokemon.dart';

abstract class IPokemomRepository {
  Future<List<Pokemon>> getAllPoke();
}

class PokemonRepository implements IPokemomRepository {
  final Dio dio;
  PokemonRepository({required this.dio});
  @override
  @override
Future<List<Pokemon>> getAllPoke() async {
  try {
    final response = await dio.get("https://pokeapi.co/api/v2/pokemon");
    final json = jsonDecode(response.data) as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>;

    final List<Pokemon> pokemonList = results.map((result) {
      return Pokemon(
        name: result['name'],
        url: result['url'],
      );
    }).toList();

    return pokemonList;
  } catch (e) {
    throw e;
  }
}

}
*/