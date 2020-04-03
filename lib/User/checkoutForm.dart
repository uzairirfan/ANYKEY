import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';


class ViewWidget extends StatefulWidget {
  @override
  ViewWidgetState createState() => ViewWidgetState();
}

class ViewWidgetState extends State {

  bool address = true;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {'Street Number': null,
    'Street': null,  'City': null,  'Province': null,  'Country': null};

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
    if (address) {
      return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildStreetField(),
              _buildCityField(),
              _buildProvinceField(),
              _buildCountryField(),
              _buildSubmitButton(),
            ],
          ));
    } else{
      return Form(

      );
    }
  }

  Widget _buildStreetField() {
    return Row(
    children: <Widget>[
      Flexible(
      child: TextFormField(
      decoration: InputDecoration(labelText: 'Street Number'),
     keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['Street Number'] = value;
      },
      )),
      Flexible(child:TextFormField(
        decoration: InputDecoration(labelText: 'Street'),
        keyboardType: TextInputType.text,
        onSaved: (String value) {
          _formData['Street'] = value;
        },
      )),

    ]);

  }

  Widget _buildCityField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'City'),
      keyboardType: TextInputType.text,
      onSaved: (String value) {
        _formData['City'] = value;
      },
    );
  }

  Widget _buildProvinceField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Province'),
      keyboardType: TextInputType.text,
      onSaved: (String value) {
        _formData['Province'] = value;
      },
    );
  }
  Widget _buildCountryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Country'),
      keyboardType: TextInputType.text,
      onSaved: (String value) {
        _formData['Country'] = value;
      },
    );
  }



  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: () {
        _submitForm();
        address = false;
      },
      child: Text('SEND'),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_formData);
    }
  }
}