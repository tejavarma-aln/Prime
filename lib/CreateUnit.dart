import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prime/Db.dart';
import 'package:prime/UnitTransaction.dart';
import 'package:sqflite/sqflite.dart';

import 'UnitModel.dart';

class UnitCreation extends StatefulWidget {
  final int mode;
  final Unit oldObj;
  UnitCreation({Key key,this.mode,this.oldObj}) : super(key: key);

  @override
  UnitState createState() => UnitState();
}

class UnitState extends State<UnitCreation> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> form_controllers =

      List<TextEditingController>.generate(
          3, (index) => new TextEditingController());


  void addUnit(BuildContext context) async {
    Unit unit = makeObject();
    Database db = await Db().getDbHandle();
    UnitTransaction unitTransaction = new UnitTransaction(db);
    unitTransaction.add(unit);
   /* List<Unit> _units = await unitTransaction.get();
    for (Unit u in _units) {
      print(u.toString());
    }*/
    if(db.isOpen){
      db.close();
    }
    Navigator.pop(context);

  }

  Unit makeObject(){
    return new Unit(
        id: widget.mode == 1?widget.oldObj.id:null,
        name: form_controllers[0].text.trim().toLowerCase(),
        symbol: form_controllers[1].text.trim().toLowerCase(),
        uqc: (form_controllers[2].text.trim().isEmpty
            ? "NA"
            : form_controllers[2].text.trim()));
  }

  void _updateUnit(BuildContext context) async{
    Unit unit  = makeObject();
    Database db = await Db().getDbHandle();
    UnitTransaction unitTransaction = new UnitTransaction(db);
    unitTransaction.update(unit);
    if(db.isOpen){
      db.close();
    }
    Navigator.pop(context);

  }


  void _deleteUnit(BuildContext context) async{
    Database db = await Db().getDbHandle();
    UnitTransaction unitTransaction = new UnitTransaction(db);
    int count =  await unitTransaction.delete(widget.oldObj.id);
    if(db.isOpen){
      db.close();
    }
    print(count);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if(widget.mode == 1){
      form_controllers[0]
        ..text = widget.oldObj.name
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[0].text.length));
      form_controllers[1]
        ..text = widget.oldObj.symbol
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[1].text.length));
      form_controllers[2]
        ..text = widget.oldObj.uqc
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[2].text.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _dimension = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        excludeHeaderSemantics: false,
        title: Text(
          "Create Unit",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          splashColor: Colors.green,
          icon:  Icon(Icons.arrow_back,color: Colors.white),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            splashColor: Colors.green,
            icon: Icon(Icons.save),
            color: Colors.white,
            onPressed: (){
              if (_formKey.currentState.validate()) {
                widget.mode == 1?_updateUnit(context):addUnit(context);
              }
            },
          ),
          Visibility(
            visible: widget.mode == 1,
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                _deleteUnit(context);
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
            children: <Widget>[
              TextFormField(
                controller: form_controllers[0],
                style: TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    labelText: "*Name", contentPadding: EdgeInsets.all(5)),
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
                    labelText: "*Symbol", contentPadding: EdgeInsets.all(5)),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Please enter symbol";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: form_controllers[2],
                style: TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    labelText: "UQC", contentPadding: EdgeInsets.all(5)),
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
                      widget.mode == 1?_updateUnit(context):addUnit(context);
                    }
                  },
                  child: Text(
                    widget.mode ==1?"ALTER":"CREATE",
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
