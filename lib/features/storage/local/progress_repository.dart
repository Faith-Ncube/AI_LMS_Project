import 'local_database.dart';

class ProgressRepository {
  Future<void> saveProgressOffline({
    required String course,
    required double progress,
  }) async {
    final db = await LocalDatabase.database;

    await db.insert('progress', {
      'course': course,
      'progress': progress,
      'synced': 0,
    });
  }

  Future<List<Map<String, dynamic>>> getUnsyncedProgress() async {
    final db = await LocalDatabase.database;

    return await db.query(
      'progress',
      where: 'synced = ?',
      whereArgs: [0],
    );
  }

  Future<void> markAsSynced(int id) async {
    final db = await LocalDatabase.database;

    await db.update(
      'progress',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
