import 'package:flutter/material.dart';
import 'package:start/core/constants/api_constants.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final double rating;
  final String name;
  final String price;
  final int likecount;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.rating,
    required this.name,
    required this.price,
    required this.likecount,
  }) : super(key: key);

  /// Ensures a valid image URL by replacing “localhost” if needed.
  String getValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.contains('localhost')) {
      return url.replaceAll('localhost', ApiConstants.STORAGE_URL);
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final String validUrl = getValidImageUrl(imageUrl);

    return Column(
      children: [
        Card(
          elevation: 6,
        //  margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section with an overlaid rating badge.
              Stack(
                children: [
                  Image.network(
                    validUrl,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 240,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 40),
                      ),
                    ),
                  ),
                  // Rating badge positioned at the top-left.
                  Positioned(
                    top: 7,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 18, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Times New Roman'
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Information panel: Room name, then price and likes.
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Times New Roman'
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Price & Likes row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                      fontFamily: 'Times New Roman'
                    ),
                  ),
                  // Likes Count with a heart icon.
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$likecount',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
