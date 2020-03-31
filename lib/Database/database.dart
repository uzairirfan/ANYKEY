import 'package:postgres/postgres.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import '../Helper/game.dart';
import 'dart:convert' show utf8;
import 'dart:typed_data';
import '../Helper/game.dart';

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

  void addToCart(int appid, String email, int quantity) async {
    var connection = new PostgreSQLConnection(
        "ec2-184-72-236-3.compute-1.amazonaws.com", 5432, "d3bujikbsk6o86",
        username: "ajomrhjjziksqi",
        password:
            "b5ee3764068c5cbfa5a9534565e4a367d8d235ea42fdb326e67b98b8f72ca274",
        useSSL: true);
    await connection.open();

    email = "bushrawsyed@gmail.com";
    String query =
        "insert into user_cart values ($appid, '$email', $quantity)";
    
    await connection.close();
    await connection.query(query);
  }

  Future<List<Game>> getCart(String email) async{
    var connection = new PostgreSQLConnection(
        "ec2-184-72-236-3.compute-1.amazonaws.com", 5432, "d3bujikbsk6o86",
        username: "ajomrhjjziksqi",
        password:
        "b5ee3764068c5cbfa5a9534565e4a367d8d235ea42fdb326e67b98b8f72ca274",
        useSSL: true);
    await connection.open();
    String query =
        "select * from user_cart natural join game where email = '$email'";
    var results = await connection.query(query);

    List<Game> games = new List<Game>();
    for (final row in results) {
      //find publisher name from email
      query =
      "SELECT pub_name FROM  publisher where pub_email = '${row[4]}'";
      var found = await connection.query(query);
      String pub = row[4];
      for (final row in found) {
        pub = row[0];
      }
      // find developer name from dev id
      query =
      "SELECT dev_name FROM  developer where dev_id = ${row[3]}";
      found = await connection.query(query);
      String dev = "none";
      for (final row in found) {
        dev = row[0];
      }
      games.add(new Game.short(
          appid: row[0],
          name: row[5],
          developer: dev,
          publisher: pub,
          averagePlaytime: row[6],
          sellprice: (row[9] * 1.0),
          price: (row[8] * 1.0)));
    }
    await connection.close();
    return games;
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
      query = "SELECT pub_name FROM  publisher where pub_email = '${row[2]}'";
      var found = await connection.query(query);
      String pub = row[2];
      for (final row in found) {
        pub = row[0];
      }

      // find developer name from dev id
      query = "SELECT dev_name FROM  developer where dev_id = ${row[1]}";
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
          sellprice: (row[7] * 1.0),
          price: (row[6] * 1.0));
      print("adding");
      print(g.toString());
      games.add(g);
    }
    await connection.close();
    return games;
  }

  testing() async {
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

      email = "$email" + "@email.com";

      String query =
          "insert into publisher values ('$email', '${pubs[0]}') on conflict do nothing";
      await connection.query(query);
      pub = email;

      //insert into dev
      var devs = (gamelist.games[i].developer.split(';'));
      exists = await connection.query(
          "select exists (select * from developer where dev_name = '${devs[0]}')");
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
          for (var id in results) {
            devid = id[0];
          }
        }
      }
      query =
          "insert into game values ('${gamelist.games[i].appid}', ${devid}, '${pub}','${gamelist.games[i].name}',${gamelist.games[i].averagePlaytime}"
          ",${gamelist.games[i].positiveRatings},${gamelist.games[i].price}, 4) on conflict do nothing";
//      print(query);
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
          "insert into warehouse values ('123456789', '${gamelist.games[i].appid}', 10) on conflict do nothing";
      await connection.query(query);

      print("added number " + i.toString());
    }
    await connection.close();
  }

  saveUser(String email, String username, String password, String type) async {
    await connection.open();
    String query;
    query = "insert into $type values ('$email', '$password')";
    await connection.query(query);
    await connection.close();
  }

  Future<bool> checkLogin(String email, String password, String type) async {
    await connection.open();
    print("IN CHECK");
    var results =
        await connection.query("select * from $type where email = '$email'");
    await connection.close();
    for (var r in results) {
      print("IN FOr");
      print(r[0] + r[1]);
      if (email == r[0] && password == r[1]) return Future<bool>.value(true);
    }
    print("object");
    return Future<bool>.value(false);
  }
}
