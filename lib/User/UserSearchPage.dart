import 'dart:math';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:bookeep/Database/database.dart';
import '../Helper/game.dart';

class Post {
  final String title;
  final String body;

  Post(this.title, this.body);
}



class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
   bool isReplay = false;

   List<Game> games = new List<Game>();

   Future<List<Post>> search(String search) async {
     games = await searchGames(search);
     if (games.length == 0) return [];
     return List.generate(games.length, (int index) {
       return Post(
         "Title : ${games[index].name}",
         "Description :$search $index",
       );
     });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<Post>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 20),
          headerPadding: EdgeInsets.symmetric(horizontal: 20),
          listPadding: EdgeInsets.symmetric(horizontal: 20),
          loader: Center(
            child: CircularProgressIndicator(),
          ),
          placeHolder: Center(
            child: Text("Placeholder"),
          ),
          onError: (error) {
            return Center(
              child: Text("Error occurred : $error"),
            );
          },
          emptyWidget: Center(
            child: Text("Empty"),
          ),
          icon: Icon(Icons.videogame_asset),
          onSearch: search,
        onItemFound: (Post post, int index) {
      return ListTile(
        title: Text(post.title),
        subtitle: Text(post.body),
      );},
        ),
      ),
    );
  }
}
