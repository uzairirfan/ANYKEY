import 'package:bookeep/User/AddressForm.dart';
import 'package:flutter/material.dart';
import '../Helper/game.dart';
import '../Database/database.dart';

class UserCheckoutPage extends StatelessWidget {
  Future<bool> gotCart;
  double price;
  List<Game> games = new List<Game>();
  var genredata = new Map<String, List<int>>();
  Future<bool> getGames() async {
    games = await Database().getCart(false);
    price = await Database().getCartTotal();
    genredata = await Database().getGenreData();
    print (genredata);
    print("after games");
    for (Game g in games) print(g.toString());
    return true;
  }

  UserCheckoutPage() {
    gotCart = getGames();
  }

  void submit() {}

  @override
  Widget build(BuildContext context) {
    getGames();
    int quantity;
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            'CART',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 16.0,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder(
                future: gotCart,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    getGames();
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
                                  subtitle: Text(games[position].toCart()),
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button for close dialog!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Would you like to change the quantity for ${games[position].name}?'),
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
                                                Database().updateCart(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Your total price is \$${price.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          new RaisedButton(
                            child: new Text(
                              'Submit',
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return AddressForm();
                              }));
                            },
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ]);
                  } else {
                    return SizedBox.shrink();
                  }
                })));
  }
}
