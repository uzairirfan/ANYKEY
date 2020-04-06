import 'package:flutter/material.dart';
import '../Database/database.dart';
import '../Helper/game.dart';
import 'package:carousel_slider/carousel_slider.dart';

class UserHomePage extends StatelessWidget {
  Future<bool> gotRecommended;
  List<Game> games = new List<Game>();
  List<Game> featured = new List<Game>();

  Future<bool> getGames() async {
    games = await Database().getRecommended();
    featured = await Database().getRandom();
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
        body: Container(
            child: FutureBuilder(
                future: gotRecommended,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(gotRecommended);
                  if (snapshot.hasData) {
                    print("has data");
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('FEATURED',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 14.0,
                                  ))),
                          new Container(
                              child: CarouselSlider(
                            items: featured.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      child: GestureDetector(onTap: () {
                                        return showDialog(
                                          //
                                          context: context,
                                          barrierDismissible: false, // user must tap button for close dialog!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Would you like to add "${i.name}" to your cart?'),
                                              content: Text(i.toString()),
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
                                                          title: Text('Would you like to add "${i.name}" to your cart?'),
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
                                                                Database().addToCart(i.appid, quantity);
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
                                      }),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage('https://steamcdn-a.akamaihd.net/steam/apps/${i.appid}/header.jpg')),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        color: Colors.black,
                                      ));
                                },
                              );
                            }).toList(),
                            aspectRatio: 92/43,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            pauseAutoPlayOnTouch: Duration(seconds: 1),
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          )
                              ),
                          Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('RECOMMENDED',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 14.0,
                                  ))),
                          new Expanded(
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
                                  onTap: () {
                                    return showDialog(
                                      //
                                      context: context,
                                      barrierDismissible: false, // user must tap button for close dialog!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Would you like to add "${games[position].name}" to your cart?'),
                                          content: Text(games[position].toString()),
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
                                                      title: Text('Would you like to add "${games[position].name}" to your cart?'),
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
                                                            Database().addToCart(games[position].appid, quantity);
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
                })));
  }
}
