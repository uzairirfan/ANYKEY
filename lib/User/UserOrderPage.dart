import 'package:flutter/material.dart';
import '../Helper/order.dart';
import '../Database/database.dart';

class UserOrderPage extends StatelessWidget {
  Future<bool> gotOrders;
  List<Order> orders = new List<Order>();
  Future<bool> getGames() async {
    orders = await Database().getOrders();
  }

  UserOrderPage() {
    gotOrders = getGames();
  }

  void submit() {}

  @override
  Widget build(BuildContext context) {
    getGames();
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
                future: gotOrders,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    getGames();
                    print(orders.length);
                    print(orders.length);
                    return Column(children: <Widget>[
                      new Container(
                          height: 550,
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, position) {
                              return ListTile(
//                                  leading: ConstrainedBox(
//                                    constraints: BoxConstraints(
//                                      minWidth: 44,
//                                      minHeight: 44,
//                                      maxWidth: 64,
//                                      maxHeight: 64,
//                                    ),
//                                    child: Image.network(
//                                        'https://steamcdn-a.akamaihd.net/steam/apps/${orders[position].appid}/header.jpg'),
//                                  ),
                                  title: Text(orders[position].orderId.toString()),
                                 // subtitle: Text(games[position].toCart()),;
                              );},
                            itemCount: orders.length,
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                          )),
                    ]);
                  } else {
                    return SizedBox.shrink();
                  }
                })));
  }
}
