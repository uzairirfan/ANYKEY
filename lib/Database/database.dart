import 'package:postgres/postgres.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import '../Helper/game.dart';
import 'dart:convert' show utf8;
import 'dart:typed_data';


class Database {
  var connection = new PostgreSQLConnection(
      "ec2-184-72-236-3.compute-1.amazonaws.com", 5432, "d3bujikbsk6o86",
      username: "ajomrhjjziksqi",
      password:
          "b5ee3764068c5cbfa5a9534565e4a367d8d235ea42fdb326e67b98b8f72ca274",
      useSSL: true);


  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/GameData.json');
  }

  Future<GameList> getGames() async {
    String jsonString = await loadAsset();
    final jsonResponse = json.decode(jsonString);
    GameList gameData = new GameList.fromJson(jsonResponse);
    return gameData;
  }

  void addToCart(int appid, String email, int quantity) async{
    var connection = new PostgreSQLConnection(
        "ec2-184-72-236-3.compute-1.amazonaws.com", 5432, "d3bujikbsk6o86",
        username: "ajomrhjjziksqi",
        password:
        "b5ee3764068c5cbfa5a9534565e4a367d8d235ea42fdb326e67b98b8f72ca274",
        useSSL: true);
    await connection.open();
    String query =
        "insert into user_cart values ($appid, '$email', $quantity)";
    var results = await connection.query(query);
  }

  Future<List> searchGames(String s) async {
    var connection = new PostgreSQLConnection(
        "ec2-184-72-236-3.compute-1.amazonaws.com", 5432, "d3bujikbsk6o86",
        username: "ajomrhjjziksqi",
        password:
            "b5ee3764068c5cbfa5a9534565e4a367d8d235ea42fdb326e67b98b8f72ca274",
        useSSL: true);
    await connection.open();
    List<Game> games = new List<Game>();
    String query =
        "SELECT  * FROM  game WHERE LOWER(title) LIKE  ANY(SELECT '%' || '${s}'|| '%' FROM game WHERE title IS NOT NULL)";
    var results = await connection.query(query);
    for (final row in results) {

      //find publisher name from email
      query =
          "SELECT pub_name FROM  publisher where pub_email = '${row[2]}'";
      var found = await connection.query(query);
      String pub = row[2];
      for (final row in found) {
        pub = row[0];
      }

      // find developer name from dev id
      query =
      "SELECT dev_name FROM  developer where dev_id = ${row[1]}";
      found = await connection.query(query);
      String dev = "none";
      for (final row in found) {
        dev = row[0];
      }
      Game g = new Game.short(
        appid: row[0],
        name: row[3],
        developer: dev,
        publisher: pub,
       averagePlaytime: row[4],
        sellprice: (row[7]*1.0),
          price:(row[6]*1.0)
      );
      print ("adding");
      print(g.toString());
      games.add(g);
    }
    return games;
  }

  testing() async {
    print("after connect");
    await connection.open();

    GameList gamelist = await getGames();

    for (int i = 0; i < gamelist.games.length; i++) {
      //insert into pub
      var pubs = (gamelist.games[i].publisher.split(';'));
      List<List<dynamic>> results;
      var exists;
      String pub = "-1";
      int devid = -1;
      results = await connection.query(
          "select exists (select * from publisher where pub_name = '${pubs[0]}')");
      for (final row in results) {
        exists = row[0].toString();
      }

      String email = pubs[0]
          .replaceAll(" ", "")
          .replaceAll("'", "")
          .replaceAll(":", "")
          .replaceAll("-", "")
          .replaceAll(",", "")
          .replaceAll(".", "")
          .replaceAll("(", "")
          .replaceAll(")", "")
          .replaceAll("/", "");

      email = "${pubs[0]}" + "@email.com";

      String query =
          "insert into publisher values ('$email', '${pubs[0]}') on conflict do nothing";
      await connection.query(query);
      pub = email;

      //insert into dev
      var devs = (gamelist.games[i].developer.split(';'));
      exists = await connection.query(
          "select exists (select * from developer where dev_name = '${devs[0]}')");
      print("THIS IS EXIst " + exists.toString());
      for (var e in exists) {
        if (!e[0]) {
          String id = (new DateTime.now().millisecondsSinceEpoch).toString();
          id = id.substring(id.length - 10);
          devid = int.parse(id);
          results = await connection
              .query("insert into developer values ($devid, '${devs[0]}')");
        } else {
          results = await connection.query(
              "select dev_id from developer where dev_name = '${devs[0]}'");
              for(var id in results){
                devid = id[0];
              }
        }
      }
      // for (String d in devs) {
      //   results = await connection.query("select dev_id from developer where dev_name = '${gamelist.games[i].developer}'");
      //   print("zTHIS RESULTD"+results.toString());
      //   for (final row in results) {
      //     print("THIS IS ROW"+row[0].toString());
      //     devid = int.parse(row[0]);
      //   }
      //   print("THIS IS DEVID "+devid.toString());
      //   if (devid == -1) {
      //     String id = (new DateTime.now().millisecondsSinceEpoch).toString();
      //   id = id.substring(id.length - 10);
      //   devid = int.parse(id);
      //     String query = "insert into developer values ($devid, '$d')";
      //     await connection.query(query);
      //   }
      //   break;
      // }

      //insert into game
      query =
          "insert into game values ('${gamelist.games[i].appid}', ${devid}, '${pub}','${gamelist.games[i].name}',${gamelist.games[i].averagePlaytime}"
          ",${gamelist.games[i].positiveRatings},${gamelist.games[i].price}, 4)";
      print(query);
      await connection.query(query);

      var genres = (gamelist.games[i].genres.split(';'));
      for (String g in genres) {
        String query = "insert into genre values ('$g') on conflict do nothing";
        await connection.query(query);
      }

      genres = (gamelist.games[i].genres.split(';'));
      for (String g in genres) {
        String query =
            "insert into game_gen values ('$g', '${gamelist.games[i].appid}') on conflict do nothing";
        await connection.query(query);
      }

      query =
          "insert into warehouse values ('123456789', 10, '${gamelist.games[i].appid}') on conflict do nothing";
      await connection.query(query);

      print("added number " + i.toString());
    }
  }

  saveUser(String email, String username, String password, String type) async {
    await connection.open();
    String query;
    if (type.toLowerCase() == "users")
      query = "insert into $type values ('$email', '$password')";
    else
      query = "insert into $type values ('$password', '$email')";
    await connection.query(query);
  }
}
