import 'package:bookeep/User/checkoutForm.dart';
import 'package:flutter/material.dart';
import '../Helper/game.dart';
import '../Database/database.dart';

class UserCheckoutPage extends StatelessWidget {
  Future<bool> gotCart;
  double price;
  List<Game> games = new List<Game>();
  Future<bool> getGames() async {
    games = await Database().getCart();
    price = await Database().getCartTotal();
    print("after games");
    for (Game g in games) print(g.toString());
    return true;
  }

  UserCheckoutPage() {
    gotCart = getGames();
  }

  void submit(){

  }

  @override
  Widget build(BuildContext context) {
    getGames();
    return new Scaffold(
        appBar: AppBar(
        title: Text('CART',
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
            future: gotCart,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: <Widget>[
                      new Container(
                        height: 550,
                          child:
                  ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, position) {
                      return ListTile(
                        title: Text(games[position].name),
                        subtitle: Text(games[position].toCart()),
                      );
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
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
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
                      Navigator.of(context).push(
                      MaterialPageRoute(
                      builder: (context){
                      return ViewWidget();
                      }
                      ));
                      },
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ]);
              } else {
                return SizedBox.shrink();
              }
            }))
    );
  }
}
