import 'package:bookeep/Database/database.dart';
import 'package:flutter/material.dart';
import 'signupPage.dart';
import 'package:bookeep/Owner/OwnerPage.dart';
import 'package:bookeep/User/UserPage.dart';

String email;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _type = "users";
  bool _check = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 16.0 ,
            )),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                SizedBox(height: 20.0),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        email = value;
                        return null;
                      }
                      return "Please Enter Your Email.";
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email Address")),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        _password = value;
                        return null;
                      }
                      return "Please Enter Your Password.";
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password")),
                SizedBox(height: 20.0),
                new CheckboxListTile(
                  title: Text("Are you an owner?"),
                  value: _check,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (bool value) {
                    setState(() {
                      if (value)
                        _type = "admin";
                      else
                        _type = "users";
                      _check = value;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                RaisedButton(
                    child: Text("LOGIN"),
                    onPressed: () async {
                      print("IN ON PRESSED");
                      // save the fields..
                      if (_formKey.currentState.validate()) {
                        if (await Database()
                            .checkLogin(email, _password, _type)) {
                          print("AFTER DB CALL");
                          if (_check) {
                            print("IN OWNER ROUTE");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyOwnerPage(
                                        title: "Owner Page",
                                      )),
                            );
                          } else {
                            print("IN USER ROUTE");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyUserPage(
                                        title: "User Page",
                                      )),
                            );
                          }
                        }
                      }
                      // form.save();
                      //ROUTING
                      // Validate will return true if is valid, or false if invalid.
//                  if (form.validate()) {
//                    print("$_email $_password");
//                  }
                    }),
                RaisedButton(
                    child: Text("SIGN UP"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage(
                                  title: "Sign Up",
                                )),
                      );
                    })
              ],
            )),
      ),
    );
  }
}
