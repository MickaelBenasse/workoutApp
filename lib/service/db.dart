import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:workout/models/profile.dart';

class Service {

  // Define a function that inserts dogs into the database
  Future<void> insertHistory(History history, var database) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'history',
      history.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<History>> histories(var database) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('history');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return History(
        id: maps[i]['id'],
        workoutName: maps[i]['workoutName'],
        time: maps[i]['time'],
        date: maps[i]['date'],
        points: maps[i]['points'],
      );
    });
  }

  Future<void> updateHistory(History history, var database) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'history',
      history.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [history.id],
    );
  }

  Future<void> deleteHistory(int id, var database) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'history',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
