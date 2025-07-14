import 'dart:ffi';

import 'package:drip/models/task.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tasksTableName = "driq";
  final String _tasksIdColumnName = "id";
  final String _tasksKeyColumnName = "key";
  final String _tasksContentColumnName = "content";

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
      version: 4,
      onCreate: (db, version) {
        debugPrint("Database oluşturuluyor");
        db.execute("""
          CREATE TABLE $_tasksTableName (
            $_tasksIdColumnName INTEGER PRIMARY KEY,
            $_tasksKeyColumnName TEXT NOT NULL,
            $_tasksContentColumnName INTEGER NOT NULL
          )
        """);
      },
    );
    return database;
  }

  Future<void> addRow(String key, int content) async {
    final db = await database;
    await db.insert(_tasksTableName, {
      _tasksKeyColumnName: key,
      _tasksContentColumnName: content,
    });
  }

  Future<List<Drip>?> getDrip() async {
    final db = await database;
    final data = await db.query(_tasksTableName);
    List<Drip> drips = data
        .map(
          (e) => Drip(
            id: e["id"] as int,
            key: e["key"] as String,
            content: e["content"] as int,
          ),
        )
        .toList();
    return drips;
  }

  void printd() async {
    final db = await database;
    final data = await db.query(_tasksTableName);
    debugPrint(data.toString());
  }

  void updateDailyGoal(int id, int dailyGoal) async {
    final db = await database;
    await db.update(
      _tasksTableName,
      {_tasksContentColumnName: dailyGoal},
      where: "id = ?",
      whereArgs: [id],
    );
    final data = await db.query(_tasksTableName);
    debugPrint(data.toString());
  }
}
