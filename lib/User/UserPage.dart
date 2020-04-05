import 'package:bookeep/User/UserCheckoutPage.dart';
import 'package:bookeep/User/UserOrderPage.dart';
import 'package:bookeep/User/UserSearchPage.dart';
import 'package:flutter/material.dart';
import '../Database/database.dart';
import 'package:bookeep/User/UserHomePage.dart';

class MyUserPage extends StatefulWidget {
  MyUserPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyUserPageState createState() => _MyUserPageState();
}

class _MyUserPageState extends State<MyUserPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    UserHomePage(),
    UserSearchPage(),
    UserCheckoutPage(),
    UserOrderPage(),
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
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purple,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search')
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            title: Text('Orders'),
          ),
        ],
      ),
    );

  }
  void onTabTapped(int index) {
    setState(() {
    //  _incrementCounter();
      _currentIndex = index;
      print(_currentIndex);
    });
  }
}
