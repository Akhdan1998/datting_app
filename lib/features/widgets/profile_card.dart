part of '../../pages.dart';

class ProfileCard extends StatelessWidget {
  final DatingUser user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final name =
        (user.name ?? 'Unknown').trim().isEmpty ? 'Unknown' : user.name!.trim();
    final ageText = user.age == null ? '-' : user.age.toString();
    final photo = (user.photoUrl ?? '').trim();

    return Container(
      decoration: BoxDecoration(
        color: whiteBlue,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: photo.isNotEmpty
                ? Image.network(
                    photo,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Image.asset('assets/images/p1.jpg', fit: BoxFit.cover),
                  )
                : Image.asset('assets/images/p1.jpg', fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  transparentColor,
                  transparentColor,
                  electric.withOpacity(0.85),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              '$name\n$ageText Tahun',
              style: inconsolataStyle(
                fontSize: 22,
                color: lemonade,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
