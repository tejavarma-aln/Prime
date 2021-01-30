import 'package:prime/UnitModel.dart';
import 'package:sqflite/sqflite.dart';

class UnitTransaction {
  final Database db;
  final String tableName = "unit_master";
  UnitTransaction(this.db);

  Future<void> add(Unit unit) async {
    await db.insert(tableName, unit.serialize(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> delete(int id) async{
    assert(id != null);
    return await db.delete(tableName,where: 'id=?',whereArgs: [id]);
  }

  Future<int>update(Unit unit) async{
    assert(unit.id != null);
    return await  db.update(tableName, unit.serialize(),where:'id=?',whereArgs:[unit.id]);

  }

  Future<List<Unit>> get() async {
    final List<Map<String, dynamic>> _units = await db.query(tableName);
    return List.generate(_units.length, (index) {
      return Unit(
          id: _units[index]['id'],
          name: _units[index]['name'],
          symbol: _units[index]['symbol'],
          uqc: _units[index]['uqc']);
    });
  }
}
