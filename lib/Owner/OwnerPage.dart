import 'package:bookeep/Owner/OwnerCheckoutPage.dart';
import 'package:bookeep/Owner/OwnerHomePage.dart';
import 'package:bookeep/Owner/OwnerSearchPage.dart';
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
    OwnerAddPage(Colors.white),
    OwnerRemovePage(Colors.deepOrange),
    OwnerReportPage(Colors.green)
  ];

  void _incrementCounter() {
    setState(() {
      testing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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