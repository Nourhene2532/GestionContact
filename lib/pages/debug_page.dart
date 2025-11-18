import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/User.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    final users = await _databaseHelper.getUsers();
    setState(() {
      _users = users;
    });
  }

  void _clearDatabase() async {
    final db = await _databaseHelper.database;
    await db.delete('users');
    _loadUsers();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Base de données effacée"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _addTestUser() async {
    final testUser = User(
      firstName: "Test",
      lastName: "User",
      email: "test@example.com",
      password: "123456",
      createdAt: DateTime.now(),
    );
    
    await _databaseHelper.insertUser(testUser);
    _loadUsers();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Utilisateur test ajouté"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug - Base de données'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          // Boutons d'action
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _addTestUser,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Ajouter Test'),
                ),
                ElevatedButton(
                  onPressed: _clearDatabase,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Tout Effacer'),
                ),
              ],
            ),
          ),
          
          // Statistiques
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Utilisateurs', _users.length.toString(), Colors.blue),
                _buildStatCard('Base', 'SQLite', Colors.green),
              ],
            ),
          ),
          
          // Liste des utilisateurs
          Expanded(
            child: _users.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Aucun utilisateur",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              user.firstName[0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text('${user.firstName} ${user.lastName}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.email),
                              Text(
                                'Créé le: ${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: Text(
                            'ID: ${user.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}