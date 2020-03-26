import 'package:postgres/postgres.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'game.dart';

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/GameData.json');
}

Future<GameList> printGame() async{
  String jsonString = await loadAsset();
  final jsonResponse = json.decode(jsonString);
  GameList bookData = new GameList.fromJson(jsonResponse);
  return bookData;
}

testing() async {
  var connection = new PostgreSQLConnection("ec2-184-72-236-3.compute-1.amazonaws.com", 5432, "d3bujikbsk6o86", username: "ajomrhjjziksqi", password: "b5ee3764068c5cbfa5a9534565e4a367d8d235ea42fdb326e67b98b8f72ca274", useSSL: true);
  print("after connect");
  await connection.open();
  // print("Poopy");
  connection.query("drop table gamedata");
  connection.query("create table gamedata (name varchar(500), developer varchar(1000), price numeric(4,2), appid numeric(10,0), primary key (appid))");

  GameList gamelist = await printGame();

  for(int i=0;i<gamelist.games.length;i++){
    String query = "insert into gamedata values ('${gamelist.games[i].name}', '${gamelist.games[i].developer}', '${gamelist.games[i].price}', '${gamelist.games[i].appid}')";
    // print(query);
    await connection.query(query);
    print("added number "+i.toString());
  }
  print("Before *");
  List<List<dynamic>> results = await connection.query("select * from gamedata");
  print("After *");

  for (final row in results) {
    var a = row[0];
    var b = row[1];
    var c = row[2];
    var d = row[3];

    print("Title: "+a+" Developer: "+b+" Price: "+c+" Appid: "+d.toString());
  }
}
