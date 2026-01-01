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

  /// Private: simpan yang sensitif (email/provider)
  Map<String, dynamic> toPrivateMap() => {
        'uid': uid,
        'email': email ?? '',
        'provider': provider ?? '',
        // createdAt biar aman, nanti kalau sudah ada tidak diubah (rules kamu cek createdAt tidak berubah)
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  /// Public: buat discover (tidak ada email)
  Map<String, dynamic> toPublicMap() => {
        'uid': uid,
        'name': name,
        'photoUrl': photoUrl,
        'age': age,
        'city': city,
        'isProfileComplete': isProfileComplete,
        // updatedAt wajib ada (rules kamu)
        'updatedAt': FieldValue.serverTimestamp(),
        // createdAt akan kita set hanya saat doc pertama kali dibuat via transaksi
      };

  factory DatingUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    return DatingUser(
      uid: (map['uid'] ?? doc.id) as String,
      name: map['name'] as String?,
      email: map['email'] as String?,
      // biasanya tidak ada di publicProfiles
      photoUrl: map['photoUrl'] as String?,
      age: (map['age'] as num?)?.toInt(),
      city: map['city'] as String?,
      provider: map['provider'] as String?,
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
