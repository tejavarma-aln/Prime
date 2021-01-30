import 'package:flutter/material.dart';
import 'package:prime/CreateUnit.dart';
import 'package:prime/Db.dart';
import 'package:prime/ItemModel.dart';
import 'package:prime/ItemTransaction.dart';
import 'package:prime/UnitModel.dart';
import 'package:prime/UnitTransaction.dart';
import 'package:prime/Utils.dart';
import 'package:sqflite/sqflite.dart';

class CreateItems extends StatefulWidget {
  final int mode;
  final StockItem oldObj;
  CreateItems({Key key, this.mode, this.oldObj}) : super(key: key);
  @override
  ItemsState createState() => ItemsState();
}

class ItemsState extends State<CreateItems> {
  final _formKey = GlobalKey<FormState>();
  String _currentUnit;
  List<DropdownMenuItem<String>> _units;

  List<TextEditingController> form_controllers =
      List<TextEditingController>.generate(
          7, (index) => new TextEditingController());

  Future<void> getUnits() async {
    Database db = await new Db().getDbHandle();
    UnitTransaction unitTransaction = new UnitTransaction(db);
    List<Unit> units = await unitTransaction.get();
    if (db.isOpen) {
      db.close();
    }
    setState(() {
      if (_units != null) {
        _units.clear();
      }
      _units = (units
          .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                child: Text(e.symbol),
                value: e.symbol,
              ))
          .toList());
    });
  }

  void _deleteItem(BuildContext context) async {
    Database db = await new Db().getDbHandle();
    ItemTransaction itemTransaction = new ItemTransaction(db);
    int count = await itemTransaction.delete(widget.oldObj.id);
    print(count);
    Navigator.pop(context);
  }

  void addUnit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UnitCreation()),
    );
    getUnits();
  }

  @override
  void initState() {
    super.initState();
    getUnits();
    if (widget.mode == 1) {
      form_controllers[0]
        ..text = widget.oldObj.name
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[0].text.length));
      _currentUnit = widget.oldObj.unit;
      form_controllers[1]
        ..text = widget.oldObj.hsn
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[1].text.length));
      form_controllers[2]
        ..text = widget.oldObj.description
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[2].text.length));
      form_controllers[3]
        ..text = widget.oldObj.gst.toString()
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[3].text.length));
      form_controllers[4]
        ..text = widget.oldObj.mrp.toString()
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[4].text.length));
      form_controllers[5]
        ..text = widget.oldObj.stdRate.toString()
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[5].text.length));
      form_controllers[6]
        ..text = widget.oldObj.opening.toString()
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: form_controllers[6].text.length));
    }
  }

  StockItem makeObject() {
    double gst = form_controllers[3].text.trim().isEmpty
        ? 0
        : double.parse(form_controllers[3].text.trim());
    double mrp = form_controllers[4].text.trim().isEmpty
        ? 0
        : double.parse(form_controllers[4].text.trim());
    double stdRate = form_controllers[5].text.trim().isEmpty
        ? 0
        : double.parse(form_controllers[5].text.trim());
    double opening = form_controllers[6].text.trim().isEmpty
        ? 0
        : double.parse(form_controllers[6].text.trim());
    StockItem _item = new StockItem(
        id: widget.mode == 1 ? widget.oldObj.id : null,
        name: form_controllers[0].text.trim().toLowerCase(),
        unit: _currentUnit,
        hsn: form_controllers[1].text.trim().isEmpty
            ? "NA"
            : form_controllers[1].text.trim(),
        description: form_controllers[2].text.trim().isEmpty
            ? "NA"
            : form_controllers[2].text.trim(),
        gst: gst,
        mrp: mrp,
        stdRate: stdRate,
        opening: opening);
    return _item;
  }

  void _add() async {
    StockItem _item = makeObject();
    Database db = await new Db().getDbHandle();
    ItemTransaction itemTransaction = new ItemTransaction(db);
    itemTransaction.add(_item);
    List<StockItem> _items = await itemTransaction.get();
    for (StockItem item in _items) {
      print(item.toString());
    }
  }

  void _update(BuildContext context) async {
    StockItem _item = makeObject();
    Database db = await new Db().getDbHandle();
    ItemTransaction itemTransaction = new ItemTransaction(db);
    itemTransaction.update(_item);
    if (db.isOpen) {
      db.close();
    }
    print("Done");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var _dimension = MediaQuery.of(context).size;

    return Scaffold(
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
        actions: <Widget>[
          Visibility(
            visible: widget.mode == 0,
            child: IconButton(
                splashColor: Colors.green,
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  addUnit(context);
                }),
          ),
          IconButton(
              splashColor: Colors.green,
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  widget.mode == 1 ? _update(context) : _add();
                }
              }),
          Visibility(
            visible: widget.mode == 1,
            child: IconButton(
              splashColor: Colors.green,
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                _deleteItem(context);
              },
            ),
          )
        ],
        title: Text(
          widget.mode == 0 ? "Stock Item Creation" : "Stock Item Alteration",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
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
                  value: _currentUnit,
                  onChanged: (value) {
                    setState(() {
                      _currentUnit = value;
                    });
                  },
                  validator: (text) {
                    if (_currentUnit == null) {
                      return "Please select unit";
                    }
                    if (_currentUnit.trim().isEmpty) {
                      return "Please select unit";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "*Unit",
                  ),
                  items: _units),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: form_controllers[1],
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: "HSN"),
              ),
              TextFormField(
                  controller: form_controllers[2],
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(labelText: "Description")),
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: form_controllers[3],
                  style: TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return null;
                    }
                    if (!Utils.parseDouble(value.trim())) {
                      return "Invalid GST";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "GST")),
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: form_controllers[4],
                  style: TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return null;
                    }
                    if (!Utils.parseDouble(value.trim())) {
                      return "Invalid MRP";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "MRP")),
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: form_controllers[5],
                  style: TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return null;
                    }
                    if (!Utils.parseDouble(value.trim())) {
                      return "Invalid Rate";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "Standard rate")),
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: form_controllers[6],
                  style: TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return null;
                    }
                    if (!Utils.parseDouble(value.trim())) {
                      return "Invalid Opening";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "Opening qty")),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: _dimension.width / 2,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      widget.mode == 1 ? _update(context) : _add();
                    }
                  },
                  padding: EdgeInsets.all(8),
                  color: Colors.lightGreen,
                  splashColor: Colors.green,
                  child: Text(widget.mode == 0 ? "CREATE" : "ALTER",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 0.5)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
