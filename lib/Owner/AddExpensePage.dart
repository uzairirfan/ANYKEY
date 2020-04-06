import 'package:bookeep/Database/database.dart';
import 'package:bookeep/User/BankInfoForm.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';


class ExpenseForm extends StatefulWidget {
  @override
  ExpenseFormState createState() => ExpenseFormState();
}

class ExpenseFormState extends State {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {'Date': null,
    'Reason': null,  'Amount': null};

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD AN EXPENSE',
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
            _buildDateField(),
            _buildReasonField(),
            _buildAmountField(),
            _buildSubmitButton(),
          ],
        ));
  }


  Widget _buildDateField() {
    return TextFormField(
        decoration: InputDecoration(labelText: 'Date'),
    keyboardType: TextInputType.datetime,
    onSaved: (String value) {
    _formData['Date'] = value;
    },
    );


  }

  Widget _buildReasonField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Reason'),
      keyboardType: TextInputType.text,
      onSaved: (String value) {
        _formData['Reason'] = value;
      },
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Amount'),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['Amount'] = value;
      },
    );
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
      Database().insertExpense(_formData);
      Navigator.pop(context);
    }
  }

}