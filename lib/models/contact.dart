class Contact {
  final int? id;
  final int userId; // ← NOUVEAU : Lien vers l'utilisateur
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final DateTime createdAt;

  Contact({
    this.id,
    required this.userId, // ← AJOUT
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId, // ← AJOUT
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      userId: map['userId'], // ← AJOUT
      firstName: map['firstName'],
      lastName: map['lastName'],
      phone: map['phone'],
      email: map['email'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  // Pour l'édition - crée une copie avec de nouvelles valeurs
  Contact copyWith({
    int? id,
    int? userId,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    DateTime? createdAt,
  }) {
    return Contact(
      id: id ?? this.id,
      userId: userId ?? this.userId, // ← AJOUT
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}