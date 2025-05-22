import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FavItemWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final num price;
  final VoidCallback onTap;
  final VoidCallback onTap2;
  final VoidCallback details;
  final int likecount;
  final num averagRating;

  const FavItemWidget({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.onTap,
    required this.onTap2,
    required this.details,
    required this.likecount,
    required this.averagRating,
  }) : super(key: key);

  // Helper method returns a Row with five star icons, each partially or fully filled.
  Widget _buildRatingStars(num rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      num fill = 0.0;
      if (rating >= i + 1) {
        fill = 1.0;
      } else if (rating > i && rating < i + 1) {
        fill = rating - i;
      } else {
        fill = 0.0;
      }
      stars.add(_StarIcon(ratingFraction: fill));
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: details,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // Subtle drop shadow for a modern, elevated look.
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image thumbnail with rounded corners.
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Item details: name, price, rating, and like count.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name text.
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Price text.
                  Text(
                    "\$${price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row containing dynamic star rating and likes count.
                  Row(
                    children: [
                      _buildRatingStars(averagRating),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(Icons.favorite,
                              color: Colors.red, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            likecount.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Two icon buttons on the right: filled bookmark and unfilled cart.
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onTap,
                  icon: const Icon(Icons.bookmark),
                  color: Colors.deepOrangeAccent,
                  iconSize: 28,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onTap2,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  color: Colors.grey.shade600,
                  iconSize: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// A helper widget that draws a single star icon filled according to the fraction.
class _StarIcon extends StatelessWidget {
  final num ratingFraction; // A value between 0.0 (empty) and 1.0 (full).
  const _StarIcon({Key? key, required this.ratingFraction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(
          Icons.star_border,
          color: Colors.amber,
          size: 20,
        ),
        ClipRect(
          clipper: _StarClipper(rating: ratingFraction),
          child: const Icon(
            Icons.star,
            color: Colors.amber,
            size: 20,
          ),
        ),
      ],
    );
  }
}

// Custom clipper to clip the star based on the rating fraction.
class _StarClipper extends CustomClipper<Rect> {
  final num rating; // 0.0 to 1.0
  _StarClipper({required this.rating});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * rating, size.height);
  }

  @override
  bool shouldReclip(covariant _StarClipper oldClipper) {
    return oldClipper.rating != rating;
  }
}
