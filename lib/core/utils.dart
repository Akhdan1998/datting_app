part of '../../pages.dart';

String _todayKey() {
  final now = DateTime.now().toUtc();
  return '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}';
}

double _deg2rad(double deg) => deg * (pi / 180);

double distanceKm({
  required double lat1,
  required double lon1,
  required double lat2,
  required double lon2,
}) {
  const R = 6371; // km
  final dLat = _deg2rad(lat2 - lat1);
  final dLon = _deg2rad(lon2 - lon1);

  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(lat1)) *
          cos(_deg2rad(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  return R * 2 * atan2(sqrt(a), sqrt(1 - a));
}

enum Gender {
  male,
  female,
}

extension GenderX on Gender {
  String get value => this == Gender.male ? 'male' : 'female';

  static Gender? from(String? v) {
    switch (v) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return null;
    }
  }

  Gender get opposite =>
      this == Gender.male ? Gender.female : Gender.male;
}