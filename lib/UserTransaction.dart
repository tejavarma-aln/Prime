import 'package:prime/UserModel.dart';
import 'package:sqflite/sqflite.dart';

class UserTransaction {
  final Database db;
  UserTransaction(this.db);

  Future<void> add(User user) async {
    await db.insert('user_info', user.serialize(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<User>> get() async {
    final List<Map<String, dynamic>> _users = await db.query('user_info');
    return List.generate(_users.length, (index) {
      return User(
          id: _users[index]['id'],
          name: _users[index]['name'],
          company: _users[index]['company'],
          address: _users[index]['address'],
          gstin: _users[index]['gstin'],
          pin: _users[index]['pin'],
          email: _users[index]['email'],
          contact: _users[index]['contact']);
    });
  }
}
