import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalAuthCache {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'auth.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users(
            uid TEXT PRIMARY KEY,
            email TEXT UNIQUE,
            password TEXT,
            role TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveUser({
    required String uid,
    required String email,
    required String password,
    required String role,
  }) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'uid': uid,
        'email': email,
        'password': password,
        'role': role,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> login(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }
  Future<String?> getUserRole(String email) async {
  final db = await database;
  final result = await db.query(
    'users',
    columns: ['role'],
    where: 'email = ?',
    whereArgs: [email],
  );

  if (result.isEmpty) return null;
  return result.first['role'] as String;
}

}
