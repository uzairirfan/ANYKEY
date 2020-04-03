import 'package:flutter/material.dart';
import '../Database/database.dart';
import '../Owner/OwnerPage.dart';

class OwnerAddPage extends StatelessWidget {


  @override
  final _formKey = GlobalKey<FormState>();
  int appid;
  String developer;
  String publisher;
  String title;
  String genre;
  int buyPrice;
  int sellPrice;
  int quantity;
  int ratings;
  int playtime;
TextEditingController _controller = TextEditingController();

  Widget build(BuildContext context) {
    return SingleChildScrollView(
       child:Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Text(
                  'Game Information',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        appid = int.parse(value);
                        return null;
                      }
                      return "Please Enter the Game's Appid.";
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Game Appid")),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        developer = value;
                        return null;
                      }
                      return "Please Enter the Game's Developer(s).";
                    },
                    decoration: InputDecoration(labelText: "Game Developer (if multiple separete with ;)")),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        publisher = value;
                        return null;
                      }
                      return "Please Enter the Game's Publisher(s).";
                    },
                    decoration: InputDecoration(labelText: "Game Publisher (if multiple separate with ;)")),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        title = value;
                        return null;
                      }
                      return "Please Enter the Game's Title.";
                    },
                    decoration: InputDecoration(labelText: "Game Title")),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        genre = value;
                        return null;
                      }
                      return "Please Enter the Game's Genre(s).";
                    },
                    decoration: InputDecoration(labelText: "Game Genre (if multiple separate with ;)")),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        buyPrice = int.parse(value);
                        return null;
                      }
                      return "Please Enter the Game's Buy Price.";
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Buy Price")),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        sellPrice = int.parse(value);
                        return null;
                      }
                      return "Please Enter the Game's Selling Price.";
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Sell Price")),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        quantity = int.parse(value);
                        return null;
                      }
                      return "Please Enter the Game's Quantity.";
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Game Quantity")),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        ratings = int.parse(value);
                        return null;
                      }
                      return "Please Enter the Game's Ratings.";
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Game Ratings")),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        playtime = int.parse(value);
                        return null;
                      }
                      return "Please Enter the Game's Average Playtime.";
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Game Playtime")),
                SizedBox(height: 20.0),
                RaisedButton(
                    child: Text("Add Game to Store"),
                    onPressed: () async {
                      // save the fields..
                      if (_formKey.currentState.validate()) {
                        Database().ownerAdd(appid, developer, publisher, title, genre, buyPrice, sellPrice, quantity, ratings, playtime);
                        Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyOwnerPage(
                                        title: "Owner Page",
                                      )),
                            );
                      }
                      // form.save();
                      //ROUTING
                      // Validate will return true if is valid, or false if invalid.
//                  if (form.validate()) {
//                    print("$_email $_password");
//                  }
                    }),
              ],
            )),
      ),
    );
  }
}
