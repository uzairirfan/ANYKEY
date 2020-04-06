import 'dart:math';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:bookeep/Database/database.dart';
import '../Helper/game.dart';

class Post {
  final String title;
  final String body;
  final int appid;

  Post(this.title, this.body, this.appid);
}



class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
   bool isReplay = false;
   String dropdownValue = 'Title';
   List<Game> games = new List<Game>();

   Future<List<Post>> search(String search) async {
     games = await Database().searchGames(search, dropdownValue);
     if (games.length == 0) return [];
     return List.generate(games.length, (int index) {
       return Post(
         "${games[index].name.toString()}",
         "${games[index].toString()}",
           games[index].appid
       );
     });
   }
  @override
  Widget build(BuildContext context) {
     int quantity;

    return Scaffold(
      appBar: new AppBar(
          title: Text('SEARCH',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 16.0 ,
              )),
        backgroundColor: Colors.black,),
      body:
          Container(
           // height:500,
              child:
          Column(
              children: <Widget>[

            Container(
              //height: 40,
                child:
           DropdownButton<String>(
            value: dropdownValue,
            isExpanded: true,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
                color: Colors.deepPurple
            ),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['Title', 'Genre', 'Developer', 'Publisher']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
                .toList(),
          )),
      Expanded(child: SafeArea(
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
        leading: ConstrainedBox(
  constraints: BoxConstraints(
    minWidth: 44,
    minHeight: 44,
    maxWidth: 64,
    maxHeight: 64,
  ),
  child: Image.network('https://steamcdn-a.akamaihd.net/steam/apps/${post.appid}/header.jpg'),
),
        title: Text(post.title),
        //subtitle: Text(post.body),
          onTap: () {
          return showDialog(
            //
         context: context,
         barrierDismissible: false, // user must tap button for close dialog!
         builder: (BuildContext context) {
    return AlertDialog(
            title: Text('Would you like to add "${post.title}" to your cart?'),
            content: Text(post.body),
            actions: <Widget>[
            FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
            Navigator.of(context).pop();
            },
            ),
            FlatButton(
            child: const Text('ACCEPT'),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false, // user must tap button for close dialog!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Would you like to add "${post.title}" to your cart?'),
                    content:
                    new TextField(
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Quantity', hintText: 'eg. 1, 2, etc.'),
                      onChanged: (value) {
                        quantity = int.parse(value);
                      },
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('CANCEL'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: const Text('ACCEPT'),
                        onPressed: () {
                          Database().addToCart(post.appid, quantity);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                },
              );
            },
            )
            ],
            );
          },
      );
          }
      );},
        ),
      )),
    ])));
  }
}
