import 'package:drip/models/drip.dart';
import 'package:drip/models/water.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _dripsTableName = "driq";
  final String _dripsIdColumnName = "id";
  final String _dripsKeyColumnName = "key";
  final String _dripsContentColumnName = "content";

  final String _drankTableName = "drank";
  final String _drankIdName = "id";
  final String _drankKeyName = "day";
  final String _drankContentName = "water";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 5,
      onCreate: (db, version) {
        debugPrint("Database Oluşturuyor");
        debugPrint("Drip Table Oluşturuluyor");
        db.execute("""
          CREATE TABLE $_dripsTableName (
            $_dripsIdColumnName INTEGER PRIMARY KEY,
            $_dripsKeyColumnName TEXT NOT NULL,
            $_dripsContentColumnName TEXT NOT NULL
          )
        """);
        db.execute("""
          CREATE TABLE $_drankTableName (
            $_drankIdName INTEGER PRIMARY KEY,
            $_drankKeyName TEXT NOT NULL,
            $_drankContentName INTEGER NOT NULL
          )
        """);
      },
    );
    return database;
  }

  Future<void> addRow(String key, dynamic content) async {
    final db = await database;
    await db.insert(_dripsTableName, {
      _dripsKeyColumnName: key,
      _dripsContentColumnName: content,
    });
  }

  Future<void> addRowWater(String key, dynamic content) async {
    final db = await database;
    await db.insert(_drankTableName, {
      _drankKeyName: key,
      _drankContentName: content,
    });
  }

  Future<List<Drip>?> getDrip() async {
    final db = await database;
    final data = await db.query(_dripsTableName);
    List<Drip> drips = data
        .map(
          (e) => Drip(
            id: e["id"] as int,
            key: e["key"] as String,
            content: e["content"],
          ),
        )
        .toList();
    return drips;
  }

  Future<List<Water>?> getWater() async {
    final db = await database;
    final data = await db.query(_drankTableName);
    List<Water> waters = data
        .map(
          (e) => Water(
            id: e["id"] as int,
            key: e["key"] as String,
            content: e["content"] as int,
          ),
        )
        .toList();
    return waters;
  }

  void printd() async {
    final db = await database;
    final data = await db.query(_dripsTableName);
    debugPrint(data.toString());
  }

  Future<void> updateDailyGoal(int id, dynamic dailyGoal) async {
    final db = await database;
    await db.update(
      _dripsTableName,
      {_dripsContentColumnName: dailyGoal},
      where: "id = ?",
      whereArgs: [id],
    );
    final data = await db.query(_dripsTableName);
    debugPrint(data.toString());
  }
}
