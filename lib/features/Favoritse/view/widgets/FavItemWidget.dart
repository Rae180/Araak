import 'package:flutter/material.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/managers/theme_manager.dart';

class FavItemWidget extends StatefulWidget {
  final String imageUrl;
  final String name;
  final num price;
  final VoidCallback onTap;
  final VoidCallback onTap2;
  final VoidCallback details;
  final int likecount;
  final num averagRating;
  final VoidCallback onDismissed;

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
    required this.onDismissed,
  }) : super(key: key);

  @override
  State<FavItemWidget> createState() => _FavItemWidgetState();
}

class _FavItemWidgetState extends State<FavItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkAnimation;
  bool _isBookmarkAnimating = false;
  
  @override
  void initState() {
    super.initState();
    
    // Bookmark animation controller
    _bookmarkController = AnimationController(
      duration: AppConstants.hoverDuration,
      vsync: this,
    );
    
    _bookmarkAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 40),
        TweenSequenceItem(tween: Tween(begin: 1.5, end: 0.8), weight: 30),
        TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 30),
      ],
    ).animate(_bookmarkController);
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

    // Swipe to dismiss container
    return Dismissible(
      key: Key('fav-item-${widget.name}'),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Remove Favorite"),
            content: const Text("Are you sure you want to remove this item from favorites?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Remove", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        widget.onDismissed();
      },
      child: InkWell(
        onTap: widget.details,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppConstants.elementSpacing / 2),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image with error handling
              Hero(
                tag: 'fav-item-${widget.name}',
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                    color: colorScheme.surfaceVariant,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: colorScheme.onSurfaceVariant,
                            size: 32,
                          ),
                        );
                      },
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
              
              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      widget.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Price
                    Text(
                      "\$${widget.price.toStringAsFixed(2)}",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Rating and likes
                    Row(
                      children: [
                        // Star rating
                        _buildRatingStars(widget.averagRating, colorScheme),
                        const SizedBox(width: 12),
                        
                        // Likes
                        Row(
                          children: [
                            Icon(Icons.favorite, 
                                color: Colors.red.shade300, 
                                size: 16),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Favorite button with animation
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
                      tooltip: 'Remove from favorites',
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Add to cart button with animation
                  _AddToCartButton(
                    onPressed: widget.onTap2,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced star rating widget
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

class _AddToCartButton extends StatefulWidget {
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  const _AddToCartButton({
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0).then((_) {
      _controller.reset();
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_animation.value * 0.3),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.colorScheme.primary.withOpacity(0.1),
        ),
        child: IconButton(
          onPressed: _handleTap,
          icon: Icon(Icons.shopping_cart_outlined, size: 22),
          color: widget.colorScheme.primary,
          tooltip: 'Add to cart',
        ),
      ),
    );
  }
}