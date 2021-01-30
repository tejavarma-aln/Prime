import 'package:flutter/material.dart';
import 'package:prime/UserModel.dart';
import 'package:prime/UserTransaction.dart';
import 'package:sqflite/sqflite.dart';

import 'Db.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> form_controllers =
      List<TextEditingController>.generate(
          7, (index) => new TextEditingController());

  void add_user(User user) async {
    final Database db = await new Db().getDbHandle();
    UserTransaction userTransaction = new UserTransaction(db);
    userTransaction.add(user);
    List<User> _user = await userTransaction.get();
    for (User usr in _user) {
      print(usr.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var _dimension = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Create Account",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.add_business_rounded,
                  color: Colors.lightGreen, size: 50),
              TextFormField(
                controller: form_controllers[0],
                style: TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    icon: Icon(Icons.account_box_outlined),
                    labelText: "*Name",
                    contentPadding: EdgeInsets.all(5)),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Please enter name";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: form_controllers[1],
                style: TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    icon: Icon(Icons.add_business),
                    labelText: "*Company",
                    contentPadding: EdgeInsets.all(5)),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Please enter company name";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: form_controllers[2],
                style: TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    icon: Icon(Icons.add_location),
                    labelText: "*Address",
                    contentPadding: EdgeInsets.all(5)),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Please enter address";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: form_controllers[3],
                style: TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    icon: Icon(Icons.perm_identity),
                    labelText: "GSTIN",
                    contentPadding: EdgeInsets.all(5)),
              ),
              TextFormField(
                controller: form_controllers[4],
                style: TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    icon: Icon(Icons.assistant_photo),
                    labelText: "*PIN",
                    contentPadding: EdgeInsets.all(5)),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Please enter pincode";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: form_controllers[5],
                style: TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: "*Email",
                    contentPadding: EdgeInsets.all(5)),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Please enter email id";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: form_controllers[6],
                style: TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    icon: Icon(Icons.call),
                    labelText: "*Contact",
                    contentPadding: EdgeInsets.all(5)),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Please enter contact number";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: _dimension.width / 2,
                child: RaisedButton(
                  color: Colors.lightGreen,
                  splashColor: Colors.green,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      List<String> data = List.generate(
                          7, (index) => form_controllers[index].text);
                      add_user(new User(
                          name: data[0],
                          company: data[1],
                          address: data[2],
                          gstin: data[3],
                          pin: data[4],
                          email: data[5],
                          contact: data[6]));
                    }
                  },
                  child: Text(
                    "REGISTER",
                    style: TextStyle(fontSize: 16, wordSpacing: 2),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
