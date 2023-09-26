import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    const title = 'Pokedex Boladona';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    PokemonList(),
    GamesList(),
    CharactersList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _widgetOptions[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(""),
            ),
            ListTile(
              title: const Text('Pokémon'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Jogos'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Personagens'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final String apiUrl = "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0";
  late Dio dio;
  late List<dynamic> pokemonList;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    fetchPokemonData();
  }

  Future<void> fetchPokemonData() async {
    try {
      final response = await dio.get(apiUrl);
      if (response.statusCode == 200) {
        setState(() {
          pokemonList = response.data['results'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String letraMaiuscula(String word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    return pokemonList == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              final pokemon = pokemonList[index];
              final pokemonName = pokemon['name'];
              final pokemonUrl = pokemon['url'];
              int num = index + 1;
              String formattedNumber = num.toString().padLeft(3, '0');
              return ListTile(
                title:
                    Text('$formattedNumber - ${letraMaiuscula(pokemonName)}'),
                onTap: () {
                  // Navegar para a tela de detalhes do Pokémon
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PokemonDetailScreen(
                          pokemonName: pokemonName, pokemonUrl: pokemonUrl),
                    ),
                  );
                },
              );
            },
          );
  }
}

class GamesList extends StatefulWidget {
  @override
  _GamesListState createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  final String apiUrl = "https://pokeapi.co/api/v2/version-group?limit=27&offset=0";
  late Dio dio;
  late List<dynamic> gameList;
  int selectedGameIndex = -1; 
  bool isButtonPressed = false;

  String formatandotexto(String input) {
  List<String> words = input.split('-');
  String result = words.map((word) {
    if (word.isNotEmpty) {
      String firstLetter = word[0].toUpperCase();
      String restOfWord = word.substring(1).toLowerCase();
      return '$firstLetter$restOfWord';
    }
    return '';
  }).join('/');

  return result;
}
  @override
  void initState() {
    super.initState();
    dio = Dio();
    fetchGameData();
  }

  Future<void> fetchGameData() async {
    try {
      final response = await dio.get(apiUrl);
      if (response.statusCode == 200) {
        setState(() {
          gameList = response.data['results'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gameList.length,
      itemBuilder: (context, index) {
        final game = gameList[index];
        final gameName = game['name'];

        final isSelected = index == selectedGameIndex;

        return InkWell(
          onTap: () {
            setState(() {
              selectedGameIndex = index;
              isButtonPressed = true;
            });

            Future.delayed(Duration(seconds: 1), () {
              setState(() {
                isButtonPressed = false;
              });
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500), 
            color: isSelected && isButtonPressed ? Colors.blue : Colors.white,
            child: ListTile(
              title: Text(
                formatandotexto(gameName),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CharactersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> charactersItems =
        List.generate(100, (index) => 'Personagens $index');

    return ListView.builder(
      itemCount: charactersItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(charactersItems[index]),
        );
      },
    );
  }
}

class PokemonDetailScreen extends StatefulWidget {
  final String pokemonName;
  final String pokemonUrl;

  const PokemonDetailScreen(
      {Key? key, required this.pokemonName, required this.pokemonUrl})
      : super(key: key);

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  Dio dio = Dio();
  late Map<String, dynamic> pokemonData;

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

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

  Future<void> fetchPokemonData() async {
    try {
      Response response = await dio.get(widget.pokemonUrl);
      if (response.statusCode == 200) {
        setState(() {
          pokemonData = response.data;
        });
      } else {
        print("Failed to load Pokemon data");
      }
    } catch (e) {
      print("Network error: $e");
    }
  }

  String letraMaiuscula(String word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pokémon'),
      ),
      body: Center(
        // ignore: unnecessary_null_comparison
        child: pokemonData != null
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      letraMaiuscula(pokemonData["name"]),
                      style: TextStyle(fontSize: 24),
                    ),
                    if (!isLandscape)
                      Container(
                        height: 130,
                        width: 150,
                        child: Image.network(
                          pokemonData["sprites"]["versions"]["generation-v"]
                              ["black-white"]["animated"]["front_default"],
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
                        itemCount: pokemonData["types"].length,
                        itemBuilder: (context, index) {
                          final type =
                              pokemonData["types"][index]["type"]["name"];
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
                      rows: pokemonData["stats"]
                          .map<DataRow>((stat) => DataRow(
                                cells: [
                                  DataCell(Text(
                                      letraMaiuscula(stat["stat"]["name"]))),
                                  DataCell(Text(stat["base_stat"].toString())),
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
