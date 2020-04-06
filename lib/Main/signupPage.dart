import 'package:bookeep/Database/database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../User/AddressForm.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  @override
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _email;
  String _username;
  String _type = "users";
  bool owner = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Text(
                  'Registration Information',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        _email = value;
                        if(!EmailValidator.validate(_email))return "Please Enter an Email.";
                        return null;
                      }
                      return "Please Enter an Email.";
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email Address")),
                TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty) {
                        _password = value;
                        return null;
                      }
                      return "Please Enter a Password.";
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password")),
                SizedBox(height: 20.0),
                new CheckboxListTile(
                  title: Text("Are you an owner?"),
                  value: owner,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (bool value) {
                    setState(() {
                      owner = value;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                RaisedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState.validate()) {
                      if (owner) _type = "admin";
                      Database().saveUser(_email, _username, _password, _type);
                      Navigator.pop;
                    }
                  },
                  child: Text('Sign Up!'),
                ),
              ],
            )),
      ),
    );
  }
}
