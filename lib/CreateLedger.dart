import 'package:flutter/material.dart';
import 'package:prime/Db.dart';
import 'package:prime/LedgerModel.dart';
import 'package:prime/LedgerTransaction.dart';
import 'package:prime/Utils.dart';
import 'package:sqflite/sqflite.dart';

class CreateLedgers extends StatefulWidget {
  final int mode;
  final Ledger oldObj;
  CreateLedgers({Key key, this.mode, this.oldObj}) : super(key: key);
  @override
  LedgerSate createState() {
    return LedgerSate();
  }
}

class LedgerSate extends State<CreateLedgers> {
  final _formKey = GlobalKey<FormState>();
  String _currentGroup;

  List<TextEditingController> form_controllers =
      List<TextEditingController>.generate(
          8, (index) => new TextEditingController());

  void _addLedger(BuildContext context) async {
    Ledger _ledger = makeObject();
    Database db = await new Db().getDbHandle();
    LedgerTransaction ledgerTransaction = new LedgerTransaction(db);
    ledgerTransaction.add(_ledger);
    if (db.isOpen) {
      db.close();
    }
    Navigator.pop(context);
    /*List<Ledger> ledgers = await ledgerTransaction.get();
    for(Ledger led in ledgers){
      print(led.toString());
    }*/
  }

  void _updateLedger(BuildContext context) async {
    Ledger _ledger = makeObject();
    Database db = await new Db().getDbHandle();
    LedgerTransaction ledgerTransaction = new LedgerTransaction(db);
    ledgerTransaction.update(_ledger);
    if (db.isOpen) {
      db.close();
    }
    print("Done");
    Navigator.pop(context);
  }

  void _deleteLedger(BuildContext context) async {
    Database db = await new Db().getDbHandle();
    LedgerTransaction ledgerTransaction = new LedgerTransaction(db);
    int count = await ledgerTransaction.delete(widget.oldObj.id);
    if(db.isOpen){
      db.close();
    }
    print(count);
    Navigator.pop(context);
  }

  Ledger makeObject() {
    String address = form_controllers[1].text.trim().isEmpty
        ? "NA"
        : form_controllers[1].text.trim();
    String state = form_controllers[2].text.trim().isEmpty
        ? "NA"
        : form_controllers[2].text.trim();
    String country = form_controllers[3].text.trim().isEmpty
        ? "NA"
        : form_controllers[3].text.trim();
    String pin = form_controllers[4].text.trim().isEmpty
        ? "NA"
        : form_controllers[4].text.trim();
    String contact = form_controllers[5].text.trim().isEmpty
        ? "NA"
        : form_controllers[5].text.trim();
    String email = form_controllers[6].text.trim().isEmpty
        ? "NA"
        : form_controllers[6].text.trim();
    String gstin = form_controllers[7].text.trim().isEmpty
        ? "NA"
        : form_controllers[7].text.trim();
    return new Ledger(
        id: widget.mode == 0 ? null : widget.oldObj.id,
        name: form_controllers[0].text.trim().toLowerCase(),
        ledParent: _currentGroup,
        address: address,
        state: state,
        country: country,
        pin: pin,
        contact: contact,
        email: email,
        gstin: gstin);
  }

  @override
  void initState() {
    super.initState();
    if (widget.mode == 1) {
      form_controllers[0]
        ..text = widget.oldObj.name
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[0].text.length));
      _currentGroup = widget.oldObj.ledParent;
      form_controllers[1]
        ..text = widget.oldObj.address
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[1].text.length));
      form_controllers[2]
        ..text = widget.oldObj.state
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[2].text.length));
      form_controllers[3]
        ..text = widget.oldObj.country
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[3].text.length));
      form_controllers[4]
        ..text = widget.oldObj.pin
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[4].text.length));
      form_controllers[5]
        ..text = widget.oldObj.contact
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[5].text.length));
      form_controllers[6]
        ..text = widget.oldObj.email
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[6].text.length));
      form_controllers[7]
        ..text = widget.oldObj.gstin
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[7].text.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _dimension = MediaQuery.of(context).size;

    Widget scaffold = Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            splashColor: Colors.green,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.mode == 1 ? "Ledger Alteration" : "Ledger Creation",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              splashColor: Colors.green,
              icon: Icon(Icons.save),
              color: Colors.white,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  widget.mode == 1
                      ? _updateLedger(context)
                      : _addLedger(context);
                  //Navigator.pop(context);
                }
              },
            ),
            Visibility(
              visible: widget.mode == 1,
              child: IconButton(
                splashColor: Colors.green,
                icon: Icon(Icons.delete),
                color: Colors.white,
                onPressed: () {
                  _deleteLedger(context);
                },
              ),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: form_controllers[0],
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "*Name",
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return "Please enter name";
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  value: _currentGroup,
                  onChanged: (value) {
                    setState(() {
                      _currentGroup = value;
                    });
                  },
                  validator: (text) {
                    if (_currentGroup == null) {
                      return "Please select group";
                    }
                    if (_currentGroup.trim().isEmpty) {
                      return "Please select group";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "*Group",
                  ),
                  items: Utils.groups
                      .map<DropdownMenuItem<String>>(
                          (e) => DropdownMenuItem<String>(
                                child: Text(e),
                                value: e,
                              ))
                      .toList(),
                ),
                TextFormField(
                  controller: form_controllers[1],
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "Address",
                  ),
                ),
                TextFormField(
                  controller: form_controllers[2],
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "State/Province",
                  ),
                ),
                TextFormField(
                  controller: form_controllers[3],
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "Country",
                  ),
                ),
                TextFormField(
                  controller: form_controllers[4],
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "PIN",
                  ),
                ),
                TextFormField(
                  controller: form_controllers[5],
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "Contact",
                  ),
                ),
                TextFormField(
                  controller: form_controllers[6],
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                ),
                TextFormField(
                  controller: form_controllers[7],
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "GSTIN",
                  ),
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
                        widget.mode == 1
                            ? _updateLedger(context)
                            : _addLedger(context);
                        //Navigator.pop(context);
                      }
                    },
                    child: Text(
                      widget.mode == 1 ? "ALTER" : "CREATE",
                      style: TextStyle(fontSize: 16, wordSpacing: 2),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
    return scaffold;
  }
}
