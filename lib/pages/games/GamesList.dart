import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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