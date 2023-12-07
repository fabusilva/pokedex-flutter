class Item {
  final String? foto;
  final String? id;
  final int? idade;
  final String? jogoFavorito;
  final String nome;
  final String? pokemonInicial;

  Item({
    required this.foto,
    required this.id,
    required this.idade,
    required this.jogoFavorito,
    required this.nome,
    required this.pokemonInicial,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      foto: json['foto'],
      id: json['id'],
      idade: json['idade'],
      jogoFavorito: json['jogoFavorito'],
      nome: json['nome'],
      pokemonInicial: json['pokemonInicial'],
    );
  }

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json["id"],
        nome: json["nome"],  
        foto: json["foto"],
        jogoFavorito: json["jogoFavorito"],
        pokemonInicial: json["pokemonInicial"], idade: 0,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nome": nome,  // Corrigido o nome da chave
        "foto": foto,        // Adicionada a conversão da chave
        "jogoFavorito": jogoFavorito,  // Corrigido o nome da chave
        "pokemonInicial": pokemonInicial,  // Corrigido o nome da chave
      };
}
