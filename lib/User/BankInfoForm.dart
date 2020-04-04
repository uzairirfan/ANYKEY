import 'package:bookeep/Database/database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';


class BankInfo extends StatefulWidget {
   Map<String, String> addressForm = {};
  BankInfo(Map<String, String> map) {
   addressForm = map;
  }
  BankInfoState createState() => BankInfoState(addressForm);
}

class BankInfoState extends State {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {'Card': null,
    'Back': null,  'Expiry': null,  'First': null,  'Last': null};
  Map<String, String> addressForm = {};
  BankInfoState(Map<String, String> map) {
    addressForm = map;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHECKOUT',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 16.0 ,
            )),
        backgroundColor: Colors.black,
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {

      return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildNameField(),
              _buildCardField(),
              _buildExpiryField(),
              _buildSubmitButton(),
            ],
          ));
    }


  Widget _buildNameField() {
    return Row(
    children: <Widget>[
      Flexible(
      child: TextFormField(
      decoration: InputDecoration(labelText: 'First Name'),
     keyboardType: TextInputType.text,
      onSaved: (String value) {
        _formData['First'] = value;
      },
      )),
      Flexible(child:TextFormField(
        decoration: InputDecoration(labelText: 'Last Name'),
        keyboardType: TextInputType.text,
        onSaved: (String value) {
          _formData['Last'] = value;
        },
      )),

    ]);

  }

  Widget _buildCardField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Card'),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['Card'] = value.toString();
      },
    );
  }

  Widget _buildExpiryField() {
    return Row(
        children: <Widget>[
          Flexible(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Expiry Date'),
                keyboardType: TextInputType.datetime,
                onSaved: (String value) {
                  _formData['Expiry'] = value.toString();
                },
              )),
          Flexible(child:TextFormField(
            decoration: InputDecoration(labelText: ' CVV'),
            keyboardType: TextInputType.number,
            onSaved: (String value) {
              _formData['Back'] = value.toString();
            },
          )),

        ]);
  }



  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: () {
        _submitForm();
      },
      child: Text('SEND'),
    );
  }

  void _submitForm() {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        print(_formData);
        Database().checkOut(addressForm, _formData);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }

}