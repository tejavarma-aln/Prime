import 'package:prime/LedgerModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

class LedgerTransaction {
  final Database db;
  final String tableName = "led_master";

  LedgerTransaction(this.db);

  Future<void> add(Ledger ledger) async {
    await db.insert(tableName, ledger.serialize(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> delete(int id) async{
    assert(id != null);
    return await db.delete(tableName,where: 'id=?',whereArgs: [id]);
  }

  Future<int>update(Ledger ledger) async{
    assert(ledger.id != null);
    return await  db.update(tableName, ledger.serialize(),where:'id=?',whereArgs:[ledger.id]);

  }

  Future<List<Ledger>> get() async {
    final List<Map<String, dynamic>> _ledgers = await db.query(tableName);
    return List.generate(_ledgers.length, (index) {
      return Ledger(
          id: _ledgers[index]['id'],
          name: _ledgers[index]['name'],
          ledParent: _ledgers[index]['ledParent'],
          address: _ledgers[index]['address'],
          state: _ledgers[index]['state'],
          country: _ledgers[index]['country'],
          pin: _ledgers[index]['pin'],
          contact: _ledgers[index]['contact'],
          email: _ledgers[index]['email'],
          gstin: _ledgers[index]['gstin']);
    });
  }
}
