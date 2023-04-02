import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/globals.dart';

Future<bool> connectDB() async {
  db = await openDatabase(
    'todo.db',
    version: 1,
    onCreate: (db, version) {
      db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {}).catchError((error) {
        print('error');
      });
    },
    onOpen: (db) {
      print('db open');
    },
  );

  return true;
}

Future<bool> insertRow(title,date,time,status) async{
  await db.transaction((txn) async {
    try {
      await txn.execute('INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time","$status")');
    } catch (e, s) {
     return false;
    }
  });
  return true;
}

Future<List<Map>> getTasks() async{
  return await db.rawQuery('SELECT * FROM tasks');
}