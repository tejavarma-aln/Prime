import 'package:flutter/material.dart';
import 'package:prime/CreateLedger.dart';
import 'package:prime/Db.dart';
import 'package:prime/LedgerModel.dart';
import 'package:prime/LedgerTransaction.dart';
import 'package:sqflite/sqflite.dart';

class LedgerList extends StatefulWidget {
  LedgerList({Key key}) : super(key: key);
  @override
  LedgerListState createState() => LedgerListState();
}

Future getLedgers() async {
  Database db = await new Db().getDbHandle();
  LedgerTransaction ledgerTransaction = new LedgerTransaction(db);
  List<Ledger> ledgers = await ledgerTransaction.get();
  if (db.isOpen) {
    db.close();
  }
  return ledgers;
}

class LedgerListState extends State<LedgerList> {

  void alterLedger(BuildContext context, Ledger led) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateLedgers(
                mode: 1,
                oldObj: led,
              )),
    );
    setState(() {
      getLedgers();
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
          onPressed: () {},
        ),
        title: Text(
          "List Of Ledgers",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: getLedgers(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return ListView.builder(
              itemCount: snapShot.data.length,
              itemBuilder: (context, index) {
                Ledger led = snapShot.data[index];
                return Card(
                    child: ListTile(
                        contentPadding: EdgeInsets.all(5),
                        title: Text(led.name),
                        leading: Icon(Icons.person),
                        subtitle: Text(led.ledParent),
                        trailing: IconButton(
                            splashColor: Colors.green,
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              alterLedger(context, led);
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
