import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "students.db";
  static final _databaseVersion = 1;

  static final table = 'students';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnFaculty = 'faculty';
  static final columnGroup = 'hunar';
  static final columnPassCode = 'passcode';
  static final columnStart = 'start';
  static final columnEnd = 'end';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onConfigure: _onConfigure);
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS bellik (
            id INTEGER PRIMARY KEY,
            wagt TEXT NOT NULL,
            barkod TEXT NOT NULL,
            ady TEXT NOT NULL,
            talyp_id INTEGER NOT NULL,
            FOREIGN KEY(talyp_id) REFERENCES $table(id) ON DELETE CASCADE)
          ''');

    await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnFaculty TEXT NOT NULL,
            $columnGroup TEXT NOT NULL,
            $columnPassCode TEXT NOT NULL,
            $columnStart TEXT NOT NULL,
            $columnEnd TEXT NOT NULL)
          ''');
  }

  Future<int> insert1(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert("bellik", row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows1({String? sort, String? query}) async {
    Database db = await instance.database;
    return await db.query("bellik",
        orderBy: 'wagt ${sort ?? 'ASC'}', where: "wagt LIKE ?", whereArgs: ['%${query ?? ''}%']);
  }

  Future<int?> queryRowCount1() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM bellik'));
  }

  Future<List<Map<String, dynamic>>?> queryByCode(String barcode) async {
    Database db = await instance.database;
    return await db.query(table, where: '$columnPassCode = ?', whereArgs: [barcode]);
  }

  Future<int> update1(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update("bellik", row,
        where: '$columnId = ?', whereArgs: [id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> delete1(int id) async {
    Database db = await instance.database;
    return await db.delete("bellik", where: '$columnId = ?', whereArgs: [id]);
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows({String? sort, String? query}) async {
    Database db = await instance.database;
    return await db.query(table,
        orderBy: '$columnId ${sort ?? 'ASC'}',
        where: "$columnName LIKE ?",
        whereArgs: ['%${query ?? ''}%']);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row,
        where: '$columnId = ?', whereArgs: [id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
