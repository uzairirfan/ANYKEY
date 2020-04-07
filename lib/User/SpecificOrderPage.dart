import 'package:flutter/material.dart';
import '../Helper/order.dart';
import '../Database/database.dart';

class SpecificOrderPage extends StatelessWidget {
  Order order;
  SpecificOrderPage(Order x) {
    order = x;
  }
  @override
  Widget build(BuildContext context) {
    String x = "TRACKING NUMBER #" + order.tracking.toString();
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            'ORDER #${order.orderId.toString()}',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 16.0,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: <Widget>[
              Container(
                width: 400,
                height: 110,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.purple,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.mail, size: 70),
                        title: Text("ORDER PLACED ON ${order.date.day.toString().padLeft(2, '0')}/${order.date.month.toString().padLeft(2, '0')}/2020",
                            style: TextStyle(color: Colors.black)),
                        subtitle: Text('SHIPPING TO: \n${order.streetNo} ${order.street},\n${order.city}, ${order.province}\n${order.country}', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 400,
                height: 100,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.purple,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                       ListTile(
                        leading: Icon(Icons.local_shipping, size: 70),
                        title: Text("$x",
                            style: TextStyle(color: Colors.black)),
                        subtitle: Text('CURRENTLY ON ROUTE', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'GAMES IN ORDER',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 16.0,
                ),
              ),
                      new Container(
                          height: 500,
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, position) {
                              return Card( //                           <-- Card widget
                                child: ListTile(
                                  leading: Icon(Icons.mail),
                                  title: Text("${order.orders[position].name}"),
                                  subtitle: Text("${order.orders[position].toCart()}"),
                                ),
                              );
                            },
                            itemCount: order.orders.length,
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                          )),
                    ])));
                  }
}
