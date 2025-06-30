import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/mixin/hover_mixin.dart';
import 'package:start/features/home/Models/Trending.dart';

class TrendingRoomWidget extends StatefulWidget {
  final TrendingRooms item;
  final VoidCallback onTap;
  const TrendingRoomWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<TrendingRoomWidget> createState() => _TrendingRoomWidgetState();
}

class _TrendingRoomWidgetState extends State<TrendingRoomWidget> with HoverMixin {
  String getValidImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.contains("localhost")) {
      return imageUrl.replaceAll("localhost", ApiConstants.STORAGE_URL);
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.secondary;
    final validUrl = getValidImageUrl(widget.item.imageUrl);
    
    return buildHoverable(
      scale: 1.04,
      translate: -8.0,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 230,
          margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.elementSpacing,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isHovered ? 0.25 : 0.15),
                blurRadius: 12,
                spreadRadius: 3,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            child: Stack(
              children: [
                // Room image
                CachedNetworkImage(
                  imageUrl: validUrl,
                  height: 270,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade300,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.error_outline)),
                  ),
                ),
                
                // Bottom gradient overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                
                // "Trending" badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Trending",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: AppConstants.primaryFont,
                      ),
                    ),
                  ),
                ),
                
                // Room information
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Room name
                      Text(
                        widget.item.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: AppConstants.primaryFont,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      
                      // Price and likes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange.shade400,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "\$${widget.item.price?.toStringAsFixed(2) ?? '0.00'}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: AppConstants.primaryFont,
                              ),
                            ),
                          ),
                          
                          // Likes
                          Row(
                            children: [
                              const Icon(Icons.favorite, size: 20, color: Colors.red),
                              const SizedBox(width: 4),
                              Text(
                                "${widget.item.likesCount ?? 0}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}