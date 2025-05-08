import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/features/home/Models/RecommendModel.dart';

class RecommendedRoomsWidget extends StatelessWidget {
  final RecommendedRooms item;
  const RecommendedRoomsWidget({super.key, required this.item});

  String getValidImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    // Replace 'localhost' with your computer's LAN IP and port.
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
        // TODO: Implement navigation to item details, etc.
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // A subtle shadow creates depth.
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
              // The background image.
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.network(
                  validUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error, size: 40)),
                ),
              ),
              // Gradient overlay for readability.
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // "Suggested For You" badge.
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Suggested For You",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
              // Title and subtitle.
              Positioned(
                bottom: 70,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Times New Roman',
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black45,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // const SizedBox(height: 4),
                    // Text(
                    //   item.subtitle ?? '',
                    //   style: const TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.white70,
                    //   ),
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                  ],
                ),
              ),
              // Price and rating info.
              Positioned(
                bottom: 12,
                left: 16,
                child: Row(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 12, vertical: 6),
                    //   decoration: BoxDecoration(
                    //     gradient: const LinearGradient(
                    //       colors: [Colors.deepOrange, Colors.redAccent],
                    //     ),
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: Text(
                    //     NumberFormat.currency(locale: "en_US", symbol: "\$")
                    //         .format(item.price ?? 0),
                    //     style: const TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.amber),
                        const SizedBox(width: 4),
                        // Text(
                        //   "${item.rating?.toStringAsFixed(1) ?? "0.0"}",
                        //   style: const TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 16,
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ),
              ),
              // Favorite icon button.
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 24,
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
