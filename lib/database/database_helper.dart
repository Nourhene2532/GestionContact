import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/User.dart';
import '../models/contact.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Table users
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Table contacts
    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        createdAt INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // ============ MÉTHODES POUR LES UTILISATEURS ============

  // Insérer un utilisateur
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  // Vérifier si un email existe déjà
  Future<bool> emailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Vérifier les identifiants de connexion
  Future<User?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Récupérer un utilisateur par son ID
  Future<User?> getUserById(int id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Récupérer tous les utilisateurs (pour debug)
  Future<List<User>> getUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  // ============ MÉTHODES POUR LES CONTACTS ============

  // Insérer un contact
  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert('contacts', contact.toMap());
  }

  // Mettre à jour un contact
  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ? AND userId = ?',
      whereArgs: [contact.id, contact.userId],
    );
  }

  // Supprimer un contact
  Future<int> deleteContact(int contactId, int userId) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ? AND userId = ?',
      whereArgs: [contactId, userId],
    );
  }

  // Récupérer tous les contacts d'un utilisateur
  Future<List<Contact>> getContactsByUser(int userId) async {
    final db = await database;
    final result = await db.query(
      'contacts',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'firstName, lastName',
    );
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  // Récupérer un contact par son ID
  Future<Contact?> getContactById(int contactId, int userId) async {
    final db = await database;
    final result = await db.query(
      'contacts',
      where: 'id = ? AND userId = ?',
      whereArgs: [contactId, userId],
    );
    if (result.isNotEmpty) {
      return Contact.fromMap(result.first);
    }
    return null;
  }

  // Rechercher des contacts par nom ou prénom
  Future<List<Contact>> searchContacts(int userId, String query) async {
    final db = await database;
    final result = await db.query(
      'contacts',
      where: 'userId = ? AND (firstName LIKE ? OR lastName LIKE ?)',
      whereArgs: [userId, '%$query%', '%$query%'],
      orderBy: 'firstName, lastName',
    );
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  // Vérifier si un numéro de téléphone existe déjà pour un utilisateur
  Future<bool> phoneExistsForUser(String phone, int userId) async {
    final db = await database;
    final result = await db.query(
      'contacts',
      where: 'userId = ? AND phone = ?',
      whereArgs: [userId, phone],
    );
    return result.isNotEmpty;
  }

  // Compter le nombre de contacts d'un utilisateur
  Future<int> getContactCount(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM contacts WHERE userId = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Fermer la base de données
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}