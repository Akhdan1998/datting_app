part of '../../pages.dart';

class DatingUser {
  final String uid;
  final String? name;
  final String? email;
  final String? photoUrl;
  final int? age;
  final String? city;
  final String? provider;
  final bool isProfileComplete;

  const DatingUser({
    required this.uid,
    this.name,
    this.email,
    this.photoUrl,
    this.age,
    this.city,
    this.provider,
    this.isProfileComplete = false,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
    'age': age,
    'city': city,
    'provider': provider,
    'isProfileComplete': isProfileComplete,
    'updatedAt': FieldValue.serverTimestamp(),
    'createdAt': FieldValue.serverTimestamp(), // aman karena merge true
  };

  factory DatingUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    return DatingUser(
      uid: (map['uid'] ?? doc.id) as String,
      name: map['name'] as String?,
      email: map['email'] as String?,
      photoUrl: map['photoUrl'] as String?,
      age: (map['age'] as num?)?.toInt(),
      city: map['city'] as String?,
      provider: map['provider'] as String?,
      isProfileComplete: (map['isProfileComplete'] as bool?) ?? false,
    );
  }
}