import 'package:flutter/material.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/features/home/Models/Trending.dart';
import 'package:intl/intl.dart';

class TrendingItemWidget extends StatelessWidget {
  final TrendingItems item;
  const TrendingItemWidget({Key? key, required this.item}) : super(key: key);

  String getValidImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.contains("localhost")) {
      return imageUrl.replaceAll("localhost", ApiConstants.STORAGE_URL);
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final String validUrl = getValidImageUrl(item.imageUrl);

    return GestureDetector(
      onTap: () {
        // TODO: Implement navigation or animation effect.
      },
      child: Container(
        width: 230, // Slightly larger for more emphasis.
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              SizedBox(
                height: 270, // Full-height trending look.
                width: double.infinity,
                child: Image.network(
                  validUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
              // Blurred Overlay Effect
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.55),
                        Colors.transparent,
                        Colors.black.withOpacity(0.25),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              // "Trending Now" Badge
              Positioned(
                top: 10,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "🔥 Trending Now",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
              // Product name overlay
              Positioned(
                bottom: 70,
                left: 15,
                right: 15,
                child: Text(
                  item.name ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Times New Roman'),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              // Price badge
              Positioned(
                bottom: 10,
                left: 15,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepOrange, Colors.redAccent],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    NumberFormat.currency(locale: "en_US", symbol: "\$")
                        .format(item.price ?? 0),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
              // Like button with animation
              Positioned(
                bottom: 10,
                right: 15,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement like functionality.
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, size: 22, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        "${item.likesCount ?? 0}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
