import 'package:postgres/postgres.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'game.dart';

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/gamedata.json');
}

Future<GameList> getGames() async{
  String jsonString = await loadAsset();
  final jsonResponse = json.decode(jsonString);
  GameList gameData = new GameList.fromJson(jsonResponse);
  return gameData;
}

testing() async {
  var connection = new PostgreSQLConnection("ec2-184-72-236-3.compute-1.amazonaws.com", 5432, "d3bujikbsk6o86", username: "ajomrhjjziksqi", password: "b5ee3764068c5cbfa5a9534565e4a367d8d235ea42fdb326e67b98b8f72ca274", useSSL: true);
  print("after connect");
  await connection.open();
  // print("Poopy");
  connection.query("drop table gamedata");
  connection.query("create table gamedata (name varchar(500), developer varchar(1000), price numeric(4,2), appid numeric(10,0), primary key (appid))");

  GameList gamelist = await getGames();

  for(int i=0;i<gamelist.games.length;i++){
    //insert into pub
    List<List<dynamic>> results = await connection.query("select exists (select * from publisher where publisher = '${gamelist.games[i].publisher}')");

    var exists;
    String id = (new DateTime.now().millisecondsSinceEpoch).toString();
    id = id.substring(id.length - 10);
    for (final row in results) {
      print(row[0]);
      exists = row[0].toString();
    }

    if (exists == "false") {
      String query = "insert into publisher values ('$id', '${gamelist.games[i].publisher}')";
      await connection.query(query);
    }

    //insert into dev
    results = await connection.query("select exists (select *"
        " from developer where name = '${gamelist.games[i].developer}')");
    for (final row in results) {
      exists = row[0].toString();
    }
    if (exists == "false") {
      String query = "insert into developer values ('$id', '${gamelist.games[i].developer}')";
      await connection.query(query);
    }
    //insert into genre
    results = await connection.query("select * from publisher where publisher = '${gamelist.games[i].publisher}'");

    var pubid;

    for (final row in results) {
      pubid = row[0];
    }
    results = await connection.query("select * from developer where name = '${gamelist.games[i].developer}'");

    var devid;

    for (final row in results) {
      devid = row[0];
    }
    String query = "insert into genre values ('${gamelist.games[i].genres}') on conflict do nothing";
    await connection.query(query);

    
    query = "insert into warehouse values ('123456789', 10, '${gamelist.games[i].appid}') on conflict do nothing";
    await connection.query(query);

    //insert into game
    query = "insert into game values ('${gamelist.games[i].appid}', '$devid', '$pubid', "
        "'123456789','${gamelist.games[i].genres}','${gamelist.games[i].name}',${gamelist.games[i].averagePlaytime}"
        ",${gamelist.games[i].positiveRatings},${gamelist.games[i].price}, 4)";
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
