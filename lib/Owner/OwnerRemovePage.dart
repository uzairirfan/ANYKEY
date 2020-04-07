import 'package:flutter/material.dart';
import '../Helper/game.dart';
import '../Database/database.dart';

class OwnerRemovePage extends StatelessWidget {
  Future<bool> gotGames;
  List<Game> games = new List<Game>();
  Future<bool> getGames() async {
    games = await Database().getAllGames();
    print ("got games");
    return true;
  }

  OwnerRemovePage() {
    gotGames = getGames();
  }

  void submit(){

  }

  @override
  Widget build(BuildContext context) {
    getGames();
    return new Scaffold(
        appBar: AppBar(
          title: Text('REMOVE',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 16.0 ,
            ),
          ),
          backgroundColor: Colors.black,),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            height: 700,
            child: FutureBuilder(
                future: gotGames,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        children: <Widget>[
                          new Container(
                              height: 600,
                              child:
                              ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, position) {
                                  return ListTile(
                                    title: Text(games[position].name),
                                    subtitle: Text(games[position].toOwnerString()),
                                      onTap: () {
                                        return showDialog(
                                          context: context,
                                          barrierDismissible: false, // user must tap button for close dialog!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Would you like to delete "${games[position].name}?'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: const Text('CANCEL'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: const Text('REMOVE'),
                                                  onPressed: () {
                                                    Database().removeGame(games[position].appid);
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }
                                  );
                                },
                                itemCount: games.length,
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                              )),
                        ]);
                  } else {
                    return SizedBox.shrink();
                  }
                }))
    );
  }
}