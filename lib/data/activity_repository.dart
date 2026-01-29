import 'local_db.dart';

class ActivityRepository {
  static Future<void> saveActivity(double score, String feedback) async {
    final db = await LocalDB.database;
    await db.insert('activities', {
      'score': score,
      'feedback': feedback,
      'synced': 0,
    });
  }

  static Future<List<Map<String, dynamic>>> getUnsynced() async {
    final db = await LocalDB.database;
    return db.query('activities', where: 'synced = 0');
  }

  static Future<void> markSynced(int id) async {
    final db = await LocalDB.database;
    await db.update(
      'activities',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
