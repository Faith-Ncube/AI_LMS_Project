import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'eduai.db');

    return openDatabase(
      path,
      version: 2, // ⬅️ bumped version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// FIRST TIME DB CREATION
  static Future<void> _onCreate(Database db, int version) async {
    // Existing activities table
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        score REAL,
        feedback TEXT,
        synced INTEGER
      )
    ''');

    // NEW: course materials table
    await db.execute('''
      CREATE TABLE course_materials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        course_key TEXT,
        file_name TEXT,
        file_path TEXT,
        file_type TEXT,
        uploaded_at TEXT
      )
    ''');
  }

  /// HANDLE DB UPGRADES SAFELY
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE course_materials (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          course_key TEXT,
          file_name TEXT,
          file_path TEXT,
          file_type TEXT,
          uploaded_at TEXT
        )
      ''');
    }
  }

  /* =========================
     COURSE MATERIALS METHODS
     ========================= */

  static Future<void> insertCourseMaterial({
    required String courseKey,
    required String fileName,
    required String filePath,
    required String fileType,
  }) async {
    final db = await database;

    await db.insert(
      'course_materials',
      {
        'course_key': courseKey,
        'file_name': fileName,
        'file_path': filePath,
        'file_type': fileType,
        'uploaded_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getCourseMaterials(
      String courseKey) async {
    final db = await database;

    return db.query(
      'course_materials',
      where: 'course_key = ?',
      whereArgs: [courseKey],
      orderBy: 'uploaded_at DESC',
    );
  }

  static Future<void> deleteCourseMaterial(int id) async {
    final db = await database;

    await db.delete(
      'course_materials',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
