import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/features/Favoritse/Bloc/FavBloc/fav_bloc.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final num rating;
  final String name;
  final String price;
  final int likecount;
  final int roomId;
  // You might also want to pass in isLiked as a parameter.
  final bool isLiked;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.roomId,
    required this.rating,
    required this.name,
    required this.price,
    required this.likecount,
    this.isLiked = false, // default unliked; change as needed
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

    return BlocProvider(
      create: (context) => FavBloc(client: NetworkApiServiceHttp()),
      child: Column(
        children: [
          Card(
            elevation: 6,
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
                            const Icon(Icons.star,
                                size: 18, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Times New Roman',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // (Optional) Add further card content here if needed.
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
                    fontFamily: 'Times New Roman',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Price & LikeButton row
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
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                    // LikeButton with like count and heart icon.
                    Builder(
                      builder: (context) {
                        return LikeButton(
                          size: 16,
                          isLiked: isLiked,
                          likeCount: likecount,
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: isLiked ? Colors.red : Colors.grey,
                              size: 16,
                            );
                          },
                          countBuilder: (int? count, bool isLiked, String text) {
                            final color = isLiked ? Colors.red : Colors.grey;
                            return Text(
                              text,
                              style: TextStyle(
                                color: color,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                          onTap: (bool isLiked) async {
                            BlocProvider.of<FavBloc>(context)
                                .add(LikeToggleEvent(roomId, null));
                            return !isLiked;
                          },
                        );
                      }
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
