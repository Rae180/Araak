import 'package:flutter/material.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/managers/theme_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavRoomWidget extends StatefulWidget {
  final String imageUrl;
  final String name;
  final num price;
  final VoidCallback onTap;
  final VoidCallback onTap2;
  final VoidCallback details;
  final int likecount;
  final num averagRating;

  const FavRoomWidget({
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

  @override
  State<FavRoomWidget> createState() => _FavRoomWidgetState();
}

class _FavRoomWidgetState extends State<FavRoomWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkAnimation;
  bool _isBookmarkAnimating = false;

  @override
  void initState() {
    super.initState();
    _bookmarkController = AnimationController(
      duration: AppConstants.hoverDuration,
      vsync: this,
    );
    _bookmarkAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(_bookmarkController);
  }

  @override
  void dispose() {
    _bookmarkController.dispose();
    super.dispose();
  }

  void _handleBookmarkTap() {
    if (!_isBookmarkAnimating) {
      _isBookmarkAnimating = true;
      _bookmarkController.forward().then((_) {
        widget.onTap();
        _isBookmarkAnimating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: widget.details,
      borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      child: Container(
        margin: const EdgeInsets.symmetric(
            vertical: AppConstants.elementSpacing / 2),
        padding: const EdgeInsets.all(AppConstants.elementSpacing),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
          border: isDarkMode
              ? Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Hero animation
            Hero(
              tag: 'room-image-${widget.name}',
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  color: colorScheme.surfaceVariant,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.broken_image,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Content area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title and price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "\$${widget.price.toStringAsFixed(2)}",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Rating and likes
                  Row(
                    children: [
                      _buildRatingStars(widget.averagRating, colorScheme),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.red.shade300,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.likecount.toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bookmark with animation
                AnimatedBuilder(
                  animation: _bookmarkAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _bookmarkAnimation.value,
                      child: child,
                    );
                  },
                  child: IconButton(
                    onPressed: _handleBookmarkTap,
                    icon: const Icon(Icons.bookmark, size: 24),
                    color: colorScheme.primary,
                    tooltip: l10n.removebookmark,
                  ),
                ),

                const SizedBox(height: 16),

                // Add to cart button
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withOpacity(0.1),
                  ),
                  child: IconButton(
                    onPressed: widget.onTap2,
                    icon: Icon(Icons.shopping_cart_outlined, size: 22),
                    color: colorScheme.primary,
                    tooltip: 'Add to cart',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(num rating, ColorScheme colorScheme) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }
}
