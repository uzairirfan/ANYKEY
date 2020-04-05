import 'package:bookeep/User/SpecificOrderPage.dart';
import 'package:flutter/material.dart';
import '../Helper/order.dart';
import '../Database/database.dart';

class UserOrderPage extends StatelessWidget {
  Future<bool> gotOrders;
  List<Order> orders = new List<Order>();
  Future<bool> getGames() async {
    orders = await Database().getOrders();
    return true;
  }

  UserOrderPage() {
    gotOrders = getGames();
  }
  @override
  Widget build(BuildContext context) {
    getGames();
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            'ORDER TRACKING',
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
                              return Card(
                                //                           <-- Card widget
                                child: ListTile(
                                    leading: Icon(Icons.mail),
                                    title: Text(
                                        "Order number #${orders[position].orderId.toString()}"),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context){
                                                return SpecificOrderPage(orders[position]);
                                              }
                                          ));
                                    }),
                              );
                            },
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
