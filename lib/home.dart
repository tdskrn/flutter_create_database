import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, 'banco.db');

    var bd = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sql =
          'CREATE TABLE usuarios(id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)';
      db.execute(sql);
    });

    return bd;
  }

  _salvar() async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome": "Alberto",
      "idade": 26,
    };
    bd.insert("usuarios", dadosUsuario);
  }

  _listarUsuario() async {
    Database bd = await _recuperarBancoDados();

    /*String sql = "SELECT * FROM usuarios";
    String sql = "SELECT * FROM usuarios WHERE id = 5";
    String sql = "SELECT * FROM usuarios WHERE idade >=30 AND idade<=58";
    String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 30 AND 50";
    String sql = "SELECT * FROM usuarios WHERE nome LIKE '%Jamilton%'";
    String sql = "SELECT * FROM usuarios";*/
    String sql = "SELECT * FROM usuarios WHERE idade <26 ";

    List usuarios = await bd.rawQuery(sql);
    print('sast ' + usuarios.toString());
  }

  _recuperarUsuario(int id) async {
    Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query(
      "usuarios",
      columns: ["id", "nome", "idade"],
      where: "id = ? ",
      whereArgs: [id],
    );

    for (var usuario in usuarios) {
      print("item id: " +
          usuario['id'].toString() +
          " nome: " +
          usuario['nome'] +
          " idade: " +
          usuario['idade'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    _recuperarUsuario(2);
    return Container();
  }
}
