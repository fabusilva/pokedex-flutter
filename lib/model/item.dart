class Item {
  final String id;
  String nomeJogador;
  bool iniciante;
  String? jogoPreferido;
  String? pokemonPreferido;

  Item(
      {required this.id,
      required this.nomeJogador,
      required this.iniciante,
      required this.jogoPreferido,
      required this.pokemonPreferido});
}
