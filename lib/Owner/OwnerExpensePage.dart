import 'package:bookeep/Database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'AddExpensePage.dart';

class OwnerExpensePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new OwnerExpensePageState();
  }
}

class OwnerExpensePageState extends State<OwnerExpensePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EXPENSES',
          style: TextStyle(
            color: Colors.purple,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.black,
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpenseForm()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
          shape: CircleBorder(),
        ),
      body:
          Column( children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            Text(
              'PUBLISHER EXPENSES',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 16.0,
              ),
            ),
      FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return body(snapshot.data);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

            Text(
              'OTHER EXPENSES',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 16.0,
              ),
            ),
            FutureBuilder(
              future: loadExpenseData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return body(snapshot.data);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
    RaisedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text("Would you like to pay the publishers?"),
                  actions: <Widget>[
              FlatButton(
              child: const Text('PAY'),
              onPressed: () {
                Database().payPublisher();
              Navigator.of(context).pop();
              },
              ),]
              );
            }
        );
    },
    child: Text('PAY PUBLISHERS'),
    ),
   ]) );
  }
  Widget body(Map data) {
    return Container(
    child: new Expanded(
    child: new ListView(
    //    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          Container(
            // height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: createTable(data),
            ),
          ),
        ],
      )),
    );
  }

  Widget createTable(Map data) {
    List<TableRow> rows = [];

    for (var k in data.keys) {
      rows.add( TableRow(children: [
           //mainAxisAlignment: MainAxisAlignment.spaceAround,
              new Text("" + k, style: TextStyle(
                color: Colors.purple,
                fontSize: 16.0,
              ),),
              new Text("     \$" + data[k].toString(), style: TextStyle(
                color: Colors.purple,
                fontSize: 16.0,
              ),),

      ]));
    }
    return Table(
        border: TableBorder.all(width: 1.0, color: Colors.black),
        children: rows);
  }

  Future<Map> loadData() async {
    Map data = await Database().getPubExpenses();
    return data;
  }

  Future<Map> loadExpenseData() async {
    Map data = await Database().getExpenses();
    return data;
  }
  }