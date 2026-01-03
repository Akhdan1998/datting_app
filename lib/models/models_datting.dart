part of '../../pages.dart';

class DatingUser {
  final String uid;
  final String? name;
  final String? email;
  final String? photoUrl;
  final int? age;
  final double? lat;
  final double? lng;
  final String? city;
  final String? provider;
  final Gender? gender;
  final Gender? showMe;
  final bool isProfileComplete;

  const DatingUser({
    required this.uid,
    this.name,
    this.email,
    this.photoUrl,
    this.age,
    this.lat,
    this.lng,
    this.city,
    this.provider,
    this.gender,
    this.showMe,
    this.isProfileComplete = false,
  });

  Map<String, dynamic> toPrivateMap() => {
        'uid': uid,
        'email': email ?? '',
        'provider': provider ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> toPublicMap() => {
        'uid': uid,
        'name': name,
        'photoUrl': photoUrl,
        'age': age,
        'city': city,
        'isProfileComplete': isProfileComplete,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  factory DatingUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    return DatingUser(
      uid: (map['uid'] ?? doc.id) as String,
      name: map['name'] as String?,
      email: map['email'] as String?,
      photoUrl: map['photoUrl'] as String?,
      age: (map['age'] as num?)?.toInt(),
      lat: (map['lat'] as num?)?.toDouble(),
      lng: (map['lng'] as num?)?.toDouble(),
      city: map['city'] as String?,
      provider: map['provider'] as String?,
      gender: GenderX.from(map['gender']),
      showMe: GenderX.from(map['showMe']),
      isProfileComplete: (map['isProfileComplete'] as bool?) ?? false,
    );
  }

  DatingUser copyWith({
    String? name,
    String? email,
    String? photoUrl,
    int? age,
    String? city,
    String? provider,
    bool? isProfileComplete,
  }) {
    return DatingUser(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      city: city ?? this.city,
      provider: provider ?? this.provider,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
