import 'package:bookeep/Owner/OwnerAddPage.dart';
import 'package:bookeep/Owner/OwnerRemovePage.dart';
import 'package:bookeep/Owner/OwnerReportPage.dart';
import 'package:flutter/material.dart';
import '../Database/database.dart';

class MyOwnerPage extends StatefulWidget {
  MyOwnerPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyOwnerPageState createState() => _MyOwnerPageState();
}

class _MyOwnerPageState extends State<MyOwnerPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    OwnerAddPage(),
    OwnerRemovePage(),
    OwnerReportPage()
  ];

  void _incrementCounter() {
    setState(() {
      Database().testing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ANYKEY',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 16.0 ,
            )),
        backgroundColor: Colors.black,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColor,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            title: Text('Add'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.remove_circle),
              title: Text('Remove')
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            title: Text('Report'),
          ),
        ],
      ),
    );

  }
  void onTabTapped(int index) {
    setState(() {

      _currentIndex = index;
    });
  }
}