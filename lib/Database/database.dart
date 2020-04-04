import 'package:postgres/postgres.dart';
import 'dart:async';
import 'dart:convert';
import '../Main/LoginPage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import '../Helper/game.dart';
import 'dart:math';

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

  void updateCart(int appid, int quantity) async{
    await connection.open();

    String query =
        "update user_cart set quantity = $quantity where appid = $appid";

    await connection.query(query);
    await connection.close();
  }

  void addToCart(int appid, int quantity) async {
    await connection.open();

    String query =
        "insert into user_cart values ($appid, '$email', $quantity)";

    await connection.query(query);
    await connection.close();
  }

  Future<double> getCartTotal() async{
    List<Game> cart = await getCart(false);
    double total = 0;
    for (Game g in cart){
      total = total + (g.price*g.quantity);
    }
    return total;
  }

  Future<List<Game>> getAllGames() async{
    await connection.open();
    String query =
        "select * from game natural join publisher natural join developer where available = true";
    var results = await connection.query(query);
    List<Game> games = new List<Game>();
    for (final row in results) {
      //find publisher name from email
      games.add(new Game.short(
          appid: row[2],
          name: row[3],
          developer: row[10],
          publisher: row[9],
          averagePlaytime: row[4],
          sellprice: (row[7] * 1.0),
          price: (row[6] * 1.0)));
    }
    await connection.close();
    return games;
  }

  void removeGame(int appid) async{
    await connection.open();
    String query =
        "update game set available = false where appid = ${appid}";
    await connection.query(query);
  }

  Future<List<Game>> getCart(bool open) async{
    if (!open) await connection.open();
    String query =
        "select * from user_cart natural join game natural join publisher natural join developer where email = '$email'";
    var results = await connection.query(query);

    List<Game> games = new List<Game>();
    for (final row in results) {
      games.add(new Game.mid(
          appid: row[2],
          name: row[5],
          developer: row[12],
          publisher: row[11],
          averagePlaytime: row[6],
          sellprice: (row[9] * 1.0),
          price: (row[8] * 1.0),
          quantity: row[4]));
    }
    if (!open) await connection.close();
    return games;
  }

  void checkOut(Map<String, String> address, Map<String, String> bank) async{
    await connection.open();
    //address(street_no, street, city, province, country)
    print (address);
    var query = "insert into address values ('${address['Street Number']}', '${address['Street']}', '${address['City']}', '${address['Province']}', '${address['Country']}')";
    print(query);
    await connection.query(query);
    //bank_info(card, email, street_no, street, city, first_name, last_name)
    query = "insert into bank_info values ('${bank['Card']}', '$email', '${address['Street Number']}', '${address['Street']}', '${address['City']}', '${bank['First']}', '${bank['Last']}')";
    print (query);
    await connection.query(query);
    //user_bank(email, card)
    query = "insert into user_bank values ('$email', '${bank['Card']}')";
    print (query);
    await connection.query(query);
    //orders(order_id, card, email, street_no, street, city, date, tracking_no)
    String id = (new DateTime.now().millisecondsSinceEpoch).toString();
    id = id.substring(id.length - 10);
    int orderId = (int.parse(id));
    query = "insert into orders values ($orderId, '${bank['Card']}', '$email', '${address['Street Number']}', '${address['Street']}', '${address['City']}', $orderId,  ${DateTime.now().millisecondsSinceEpoch})";
    print (query);
    await connection.query(query);
    //game_order(appid, order_id, quantity)
    List<Game> cart = await getCart(true);
    for (Game g in cart){
      query = "insert into game_order values (${g.appid}, $orderId, ${g.quantity})";
      print (query);
      await connection.query(query);
    }
    query ="delete from user_cart where email = $email}";
    print (query);
    await connection.query(query);
    await connection.close();
  }

  Future<List> searchGames(String s) async {
    await connection.open();
    List<Game> games = new List<Game>();
    String query =
        "SELECT  * FROM  game natural join publisher natural join developer WHERE LOWER(title) LIKE  ANY(SELECT '%' || '${s}'|| '%' FROM game) and available";
    var results = await connection.query(query);
    for (final row in results) {

      Game g = new Game.short(
          appid: row[2],
          name: row[3],
          developer: row[10],
          publisher: row[9],
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
          ",${gamelist.games[i].positiveRatings},${gamelist.games[i].price}, ${Random().nextInt(50)}, true) on conflict do nothing";
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

  ownerAdd(int appid, String developer, String publisher, String name, String genre, int buyPrice, int sellPrice, int quantity, int ratings, int playtime) async {
    await connection.open();

      //insert into pub
      var pubs = (publisher.split(';'));
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
      var devs = (developer.split(';'));
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
          "insert into game values ('$appid', $devid, '$pub','$name',$playtime"
          ",$ratings,$sellPrice, $buyPrice, true) on conflict do nothing";
//      print(query);
      await connection.query(query);

      var genres = (genre.split(';'));
      for (String g in genres) {
        String query = "insert into genre values ('$g') on conflict do nothing";
        await connection.query(query);
      }

      genres = (genre.split(';'));
      for (String g in genres) {
        String query =
            "insert into game_gen values ('$g', '$appid') on conflict do nothing";
        await connection.query(query);
      }

      query =
          "insert into warehouse values ('123456789', '$appid', $quantity) on conflict do nothing";
      await connection.query(query);
    
    await connection.close();
  }

}
