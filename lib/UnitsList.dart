
import 'package:flutter/material.dart';
import 'package:prime/CreateUnit.dart';
import 'package:prime/Db.dart';
import 'package:prime/UnitModel.dart';
import 'package:prime/UnitTransaction.dart';
import 'package:sqflite/sqlite_api.dart';

class UnitList extends StatefulWidget{
  UnitList({Key key}):super(key: key);
  @override
  UnitListState createState() => UnitListState();
}


class UnitListState extends State<UnitList>{


  Future<List<Unit>> getUnits() async {
    Database db = await new Db().getDbHandle();
    UnitTransaction unitTransaction = new UnitTransaction(db);
    List<Unit> units = await unitTransaction.get();
    if (db.isOpen) {
      db.close();
    }
    return units;
  }

  void alterUnit(BuildContext context, Unit unit) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UnitCreation(
            mode: 1,
            oldObj: unit,
          )),
    );
    setState(() {
      getUnits();
    });

  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          "List Of Units",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:  FutureBuilder(
        future: getUnits(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return ListView.builder(
              itemCount: snapShot.data.length,
              itemBuilder: (context, index) {
                Unit unit = snapShot.data[index];
                return Card(
                    child: ListTile(
                        contentPadding: EdgeInsets.all(5),
                        title: Text(unit.name),
                        leading: Icon(Icons.linear_scale_rounded),
                        subtitle: Text(unit.symbol),
                        trailing: IconButton(
                          splashColor: Colors.green,
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              alterUnit(context, unit);
                            })));
              },
            );
          }
          return Center(
            child: Text("Data not found !"),
          );
        },
      ),
    );
  }

}