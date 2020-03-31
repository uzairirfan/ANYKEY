import 'package:flutter/material.dart';
import '../Helper/game.dart';
import '../Database/database.dart';

class UserCheckoutPage extends StatelessWidget {
  Future<bool> gotCart;
  List<Game> games = new List<Game>();
  Future<bool> getGames() async{
    games = await Database().getCart();
    print ("after games");
    for (Game g in games) print(g.toString());
    return true;
  }

  UserCheckoutPage(){
    gotCart = getGames();
  }


  @override
  Widget build(BuildContext context) {
   return new Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        height: 600,
        child: FutureBuilder(
            future: gotCart,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
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
                );
              } else {
                return SizedBox.shrink();
              }
            }));
  }
}