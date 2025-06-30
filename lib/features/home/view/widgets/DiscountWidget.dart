import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/mixin/hover_mixin.dart';

class DiscountWidget extends StatefulWidget {
  final String imageUrl;
  final String discountPercentage;
  final String endDate;
  final num originalPrice;
  final num discountedPrice;
  final VoidCallback onTap;

  const DiscountWidget({
    super.key,
    required this.onTap,
    required this.imageUrl,
    required this.discountPercentage,
    required this.endDate,
    required this.originalPrice,
    required this.discountedPrice,
  });

  @override
  State<DiscountWidget> createState() => _DiscountWidgetState();
}

class _DiscountWidgetState extends State<DiscountWidget> with HoverMixin {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final accentColor = theme.colorScheme.secondary;
    final discountColor = isDarkMode 
        ? Colors.redAccent.shade200 
        : Colors.redAccent.shade700;
    
    return Semantics(
      button: true,
      label: 'Discount item ${widget.discountPercentage}% off',
      child: buildHoverable(
        scale: 1.05,
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
                  color: isDarkMode
                      ? accentColor.withOpacity(isHovered ? 0.4 : 0.2)
                      : Colors.black.withOpacity(isHovered ? 0.2 : 0.1),
                  blurRadius: isHovered ? 16 : 12,
                  spreadRadius: isHovered ? 3 : 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              child: Stack(
                children: [
                  // Image with shimmer effect
                  CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    height: 270,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade300,
                      child: Center(child: CircularProgressIndicator(
                        color: accentColor,
                      )),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.error, size: 40)),
                    ),
                  ),
                  
                  // Gradient Overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  
                  // Discount Badge
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: discountColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "${widget.discountPercentage}% OFF",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: AppConstants.primaryFont,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  
                  // Price Information
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price row
                        Row(
                          children: [
                            Text(
                              "\$${widget.discountedPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent.shade200,
                                fontFamily: AppConstants.primaryFont,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "\$${widget.originalPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                decoration: TextDecoration.lineThrough,
                                fontFamily: AppConstants.primaryFont,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        
                        // End Date
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Ends ${widget.endDate}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                fontFamily: AppConstants.primaryFont,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Hover Overlay
                  if (isHovered)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.zoom_in,
                            size: 48,
                            color: Colors.white70,
                          ),
                        ),
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