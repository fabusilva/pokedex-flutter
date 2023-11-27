import 'package:flutter_application_1/model/item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  final databaseName = "pokedex.db";
  String SQLitem =
      "CREATE TABLE item (id TEXT PRIMARY KEY, nomeJogador TEXT, iniciante INTEGER, jogoPreferido TEXT, pokemonPreferido TEXT);";

  Future<String> get fullPath async {
    const name = "pokedex.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    dynamic banco;
    try {
      final db =
          await openDatabase(path, version: 1, onCreate: (db, version) async {
        await db.execute(SQLitem);
        banco = db;
        print("Banco aberto");
      });
      return db;
    } catch (e) {
      print('Erro ao inicializar o banco de dados: $e');
      return banco;
    }
  }

  Future<String> createItem(Item item) async {
    final Database db = await initDB();
    try {
      await db.insert('item', item.toMap());
      print("Item criado com sucesso");
      return 'Item criado com sucesso';
    } catch (e) {
      print('Erro ao criar o item: $e');
      return 'Falha ao criar o item';
    }
  }

  Future<List<Item>> getAllItem() async {
    final Database db = await initDB();
    try {
      List<Map<String, Object?>> result = await db.query('item');
      print(result.map((e) => Item.fromMap(e)).toList().toString());
      return result.map((e) => Item.fromMap(e)).toList();
    } catch (e) {
      print('Erro ao buscar itens: $e');
      return [];
    }
  }

  Future<String> deleteItem(int id) async {
    final Database db = await initDB();
    try {
      await db.delete('item', where: 'id = ?', whereArgs: [id]);
      return 'Item excluído com sucesso';
    } catch (e) {
      print('Erro ao excluir o item: $e');
      return 'Falha ao excluir o item';
    }
  }

  Future<String> updateItem(
      nomeJogador, iniciante, jogoPreferido, pokemonPreferido) async {
    final Database db = await initDB();
    try {
      await db.rawUpdate(
          'update item set nomeJogador = ?, iniciante = ?, jogoPreferido = ?, pokemonPreferido = ?',
          [nomeJogador, iniciante, jogoPreferido, pokemonPreferido]);
      return 'Item atualizado com sucesso';
    } catch (e) {
      print('Erro ao atualizar o item: $e');
      return 'Falha ao atualizar o item';
    }
  }
}
