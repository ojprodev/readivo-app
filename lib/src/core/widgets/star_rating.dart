import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int maxStars;

  const StarRating({super.key, required this.rating, this.maxStars = 5});

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    double remaining = rating - fullStars;

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star_rate_rounded, color: Colors.amber));
    }

    if (remaining >= 0.75) {
      stars.add(const Icon(Icons.star_rate_rounded, color: Colors.amber));
    } else if (remaining >= 0.5) {
      stars.add(const Icon(Icons.star_half_rounded, color: Colors.amber));
    } else if (remaining >= 0.25) {
      stars.add(
        Stack(
          children: [
            const Icon(Icons.star_border_rounded, color: Colors.amber),
            ClipRect(
              clipper: _HalfStarClipper(fraction: 0.25),
              child: const Icon(Icons.star_rate_rounded, color: Colors.amber),
            ),
          ],
        ),
      );
    }

    while (stars.length < maxStars) {
      stars.add(const Icon(Icons.star_border_rounded, color: Colors.amber));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }
}

class _HalfStarClipper extends CustomClipper<Rect> {
  final double fraction;

  _HalfStarClipper({required this.fraction});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * fraction, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
