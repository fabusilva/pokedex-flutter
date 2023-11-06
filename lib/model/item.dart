class Item {
  final String id;
  String nomeJogador;
  int iniciante;
  String? jogoPreferido;
  String? pokemonPreferido;

  Item(
      {required this.id,
      required this.nomeJogador,
      required this.iniciante,
      required this.jogoPreferido,
      required this.pokemonPreferido});

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json["id"],
        nomeJogador: json["nomeJogador"],
        iniciante: json["iniciante"],
        jogoPreferido: json["jogoPreferido"],
        pokemonPreferido: json["pokemonPreferido"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nomeJogador": nomeJogador,
        "iniciante": iniciante,
        "jogoPreferido": jogoPreferido,
        "pokemonPreferido": pokemonPreferido,
      };
}
