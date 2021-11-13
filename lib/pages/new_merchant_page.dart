import 'package:flutter/material.dart';

class NewMerchantPage extends StatefulWidget {
  NewMerchantPage({Key? key}) : super(key: key);

  @override
  _NewMerchantPageState createState() => _NewMerchantPageState();
}

class _NewMerchantPageState extends State<NewMerchantPage> {
  final _nameFocusNode = FocusNode();
  final _contactPersonFocusNode = FocusNode();
  final _contactNumberFocusNode = FocusNode();
  final _smsNumberFocusNode = FocusNode();
  final _emailAddressFocusNode = FocusNode();
  final _businessAddressFocusNode = FocusNode();
  final _kmAllocatedFocusNode = FocusNode();
  final _longitudeFocusNode = FocusNode();
  final _latitudeFocusNode = FocusNode();
  final _ratingFocusNode = FocusNode();
  final _statusFocusNode = FocusNode();
  final _dateRegisteredFocusNode = FocusNode();
  final _businessHoursFocusNode = FocusNode();
  final _tokenFocusNode = FocusNode();

  var _isLoading = false;

  var _initValues = {
    'name': '',
    'contactPerson': '',
    'contactNumber': '',
    'smsNumber': '',
    'emailAddress': '',
    'businessAddress': '',
    'kmAllocated': '',
    'longitude': '',
    'latitude': '',
    'rating': '',
    'status': '',
    'dateRegistered': '',
    'businessHours': '',
    'token': '',
  };
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    initialValue: _initValues['name'],
                    decoration: const InputDecoration(labelText: 'Name'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_nameFocusNode);
                    },
                  )
                ],
              )),
    );
  }
}
