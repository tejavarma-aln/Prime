import 'package:flutter/material.dart';
import 'package:prime/CreateItem.dart';
import 'package:prime/Db.dart';
import 'package:prime/ItemModel.dart';
import 'package:prime/ItemTransaction.dart';
import 'package:sqflite/sqflite.dart';

class ItemList extends StatefulWidget {

  ItemList({Key key}) : super(key: key);
  @override
  ItemListState createState() => ItemListState();
}

class ItemListState  extends State<ItemList> {


  Future<List<StockItem>> getItems() async {
    Database db = await new Db().getDbHandle();
    ItemTransaction itemTransaction = new ItemTransaction(db);
    List<StockItem> items = await itemTransaction.get();
    if (db.isOpen) {
      db.close();
    }
    return items;
  }

  void alterItem(BuildContext context, StockItem item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateItems(
            mode: 1,
            oldObj: item,
          )),
    );
    setState(() {
      getItems();
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
            "List Of StockItems",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder(
          future: getItems(),
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              return ListView.builder(
                itemCount: snapShot.data.length,
                itemBuilder: (context, index) {
                  StockItem item = snapShot.data[index];
                  return Card(
                      child: ListTile(
                          contentPadding: EdgeInsets.all(5),
                          title: Text(item.name),
                          leading: Icon(Icons.shopping_cart_outlined),
                          subtitle: Text(item.unit),
                          trailing: IconButton(
                              splashColor: Colors.green,
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                alterItem(context, item);
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