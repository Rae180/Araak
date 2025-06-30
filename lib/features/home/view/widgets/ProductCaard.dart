import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/mixin/hover_mixin.dart';
import 'package:start/features/Favoritse/Bloc/FavBloc/fav_bloc.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final num rating;
  final String name;
  final String price;
  final int likecount;
  final int roomId;
  final VoidCallback onTap;
  final bool isLiked;

  const ProductCard({
    super.key,
    required this.onTap,
    required this.imageUrl,
    required this.roomId,
    required this.rating,
    required this.name,
    required this.price,
    required this.likecount,
    this.isLiked = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with HoverMixin {
  String getValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.contains('localhost')) {
      return url.replaceAll('localhost', ApiConstants.STORAGE_URL);
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.secondary;
    final validUrl = getValidImageUrl(widget.imageUrl);

    return BlocProvider(
      create: (context) => FavBloc(client: NetworkApiServiceHttp()),
      child: buildHoverable(
        scale: 1.03,
        translate: -6.0,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.all(AppConstants.elementSpacing),
            child: Card(
              elevation: isHovered ? 6 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with rating badge
                  Stack(
                    children: [
                      // Product image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppConstants.cardRadius)),
                        child: CachedNetworkImage(
                          imageUrl: validUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 200,
                            color: Colors.grey.shade200,
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            color: Colors.grey.shade200,
                            child: const Center(child: Icon(Icons.error)),
                          ),
                        ),
                      ),
          
                      // Rating badge
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  size: 16, color: Colors.amber),
                              const SizedBox(width: 6),
                              Text(
                                widget.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: AppConstants.primaryFont,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          
                  // Product details
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppConstants.primaryFont,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
          
                        // Price and like button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price
                            Text(
                              widget.price,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange.shade400,
                                fontFamily: AppConstants.primaryFont,
                              ),
                            ),
          
                            // Like button
                            Builder(builder: (context) {
                              return LikeButton(
                                size: 20,
                                isLiked: widget.isLiked,
                                likeCount: widget.likecount,
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.grey,
                                    size: 20,
                                  );
                                },
                                countBuilder:
                                    (int? count, bool isLiked, String text) {
                                  return Text(
                                    text,
                                    style: TextStyle(
                                      color: isLiked ? Colors.red : Colors.grey,
                                      fontSize: 14,
                                    ),
                                  );
                                },
                                onTap: (bool isLiked) async {
                                  BlocProvider.of<FavBloc>(context)
                                      .add(LikeToggleEvent(widget.roomId, null));
                                  return !isLiked;
                                },
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
