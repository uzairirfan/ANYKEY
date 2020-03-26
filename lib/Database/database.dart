import 'package:postgres/postgres.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import '../Helper/game.dart';

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/GameData.json');
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

  GameList gamelist = await getGames();

  for(int i=0;i<gamelist.games.length;i++){

    //insert into game
    String query = "insert into game values ('${gamelist.games[i].appid}','${gamelist.games[i].name}',${gamelist.games[i].averagePlaytime}"
        ",${gamelist.games[i].positiveRatings},${gamelist.games[i].price}, 4) on conflict do nothing";
    // print(query);
    await connection.query(query);


    //insert into pub
    var pubs = (gamelist.games[i].publisher.split(','));
    List<List<dynamic>> results;
    var exists;
    for (String p in pubs){
      results = await connection.query("select exists (select * from publisher where publisher = '${p}')");
      for (final row in results) {
        exists = row[0].toString();
      }
      String id = (new DateTime.now().millisecondsSinceEpoch).toString();
      id = id.substring(id.length - 10);
      if (exists == "false") {
        String email = "$p" + "@email.com";
        email = email.replaceAll(" ", "").replaceAll("'", "").replaceAll(":", "");
        String query = "insert into publisher values ('$id', '${p}', '$email', '${gamelist.games[i].appid}')";
        await connection.query(query);
      }
    }


    //insert into dev
    String id = (new DateTime.now().millisecondsSinceEpoch).toString();
    id = id.substring(id.length - 10);
    results = await connection.query("select exists (select *"
        " from developer where name = '${gamelist.games[i].developer}')");
    for (final row in results) {
      exists = row[0].toString();
    }
    if (exists == "false") {
      var devs = (gamelist.games[i].developer.split(','));
      for(String d in devs){
        String query = "insert into developer values ('$id', '$d', '${gamelist.games[i].appid}')";
        await connection.query(query);
      }
    }
    //insert into genre
    // results = await connection.query("select * from publisher where publisher = '${gamelist.games[i].publisher}'");

    // var pubid;

    // for (final row in results) {
    //   pubid = row[0];
    // }
    // var devs = (gamelist.games[i].developer.split(','));
    // for(String d in devs){
    // results = await connection.query("select * from developer where name = '${gamelist.games[i].developer}'");
    // }
    // var devid;

    // for (final row in results) {
    //   devid = row[0];
    // }
    var genres = (gamelist.games[i].genres.split(','));
    for(String g in genres){
    String query = "insert into genre values ('$g', '${gamelist.games[i].appid}') on conflict do nothing";
    await connection.query(query);
    }

    
    query = "insert into warehouse values ('123456789', 10, '${gamelist.games[i].appid}') on conflict do nothing";
    await connection.query(query);

    print("added number "+i.toString());
  }
}
