import 'package:flutter_application_1/model/StatusPokemon.dart';

class Pokemon {
  final String name;
  final String imagemGifUrl;
  final String imagemUrl;
  final List<StatusPokemon> stats;
  final List<dynamic> types;

  Pokemon(
      {required this.name,
      required this.imagemGifUrl,
      required this.imagemUrl,
      required this.stats,
      required this.types});
}
