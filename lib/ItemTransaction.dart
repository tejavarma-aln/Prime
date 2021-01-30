import 'package:prime/ItemModel.dart';
import 'package:sqflite/sqflite.dart';

class ItemTransaction {
  final Database db;
  final String tableName = "item_master";
  ItemTransaction(this.db);

  Future<void> add(StockItem item) async {
    await db.insert(tableName, item.serialize(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<StockItem>> get() async {
    final List<Map<String, dynamic>> _items = await db.query(tableName);
    return List.generate(_items.length, (index) {
      return StockItem(
          id: _items[index]['id'],
          name: _items[index]['name'],
          unit: _items[index]['unit'],
          hsn: _items[index]['hsn'],
          description: _items[index]['description'],
          gst: _items[index]['gst'],
          mrp: _items[index]['mrp'],
          stdRate: _items[index]['stdRate'],
          opening: _items[index]['opening']);
    });
  }

  Future<int> delete(int id) async{
    assert(id != null);
    return await db.delete(tableName,where: 'id=?',whereArgs: [id]);
  }

  Future<int>update(StockItem item) async{
    assert(item.id != null);
    return await  db.update(tableName, item.serialize(),where:'id=?',whereArgs:[item.id]);

  }
}
