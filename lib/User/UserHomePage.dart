import 'package:flutter/material.dart';
import '../Database/database.dart';
import '../Helper/game.dart';

class UserHomePage extends StatelessWidget {
  Future<bool> gotRecommended;
  List<Game> games = new List<Game>();

  Future<bool> getGames() async {
    print("in get");
    games = await Database().getRecommended();
    print("after get");
    return true;
  }

  UserHomePage() {
    gotRecommended = getGames();
  }

  void submit() {}

  @override
  Widget build(BuildContext context) {
    int quantity;
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            'HOME',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 16.0,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('RECOMMENDED',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 14.0,
                  ))),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder(
                  future: gotRecommended,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print(gotRecommended);
                    if (snapshot.hasData) {
                      print("has data");
                      return Column(children: <Widget>[
                        new Container(
                            height: 550,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, position) {
                                return ListTile(
                                    leading: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: 44,
                                        minHeight: 44,
                                        maxWidth: 64,
                                        maxHeight: 64,
                                      ),
                                      child: Image.network(
                                          'https://steamcdn-a.akamaihd.net/steam/apps/${games[position].appid}/header.jpg'),
                                    ),
                                    title: Text(games[position].name),
                                    subtitle: Text(games[position].toString()),
                                    onTap: () {
                                      return showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false, // user must tap button for close dialog!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Would you like to add "${games[position].name}" to your cart?'),
                                            content: new TextField(
                                              autofocus: true,
                                              decoration: new InputDecoration(
                                                  labelText: 'Quantity',
                                                  hintText: 'eg. 1, 2, etc.'),
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
                                                  Database().addToCart(
                                                      games[position].appid,
                                                      quantity);
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    });
                              },
                              itemCount: games.length,
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                            )),
                      ]);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }))
        ]));
  }
}
