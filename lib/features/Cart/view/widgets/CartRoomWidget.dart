import 'package:flutter/material.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/managers/theme_manager.dart';

class CartRoomWidget extends StatefulWidget {
  final String imageUrl;
  final String name;
  final num price;
  final int count;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onTap;

  const CartRoomWidget({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.count,
    required this.onIncrease,
    required this.onDecrease,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CartRoomWidget> createState() => _CartRoomWidgetState();
}

class _CartRoomWidgetState extends State<CartRoomWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.hoverDuration,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleQuantityChange(VoidCallback action) {
    _controller.reset();
    _controller.forward().then((_) => action());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: widget.onTap,
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
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
          border: isDarkMode
              ? Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with loading and animation
            Hero(
              tag: 'cart-room-${widget.name}',
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  color: colorScheme.surfaceVariant,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  child: Stack(
                    children: [
                      Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.broken_image,
                            color: colorScheme.onSurfaceVariant,
                            size: 32,
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted)
                                setState(() => _isImageLoaded = true);
                            });
                            return child;
                          }
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
                      if (_isImageLoaded)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Room",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Room details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 const SizedBox(
                  height: 14,
                 ),
                  Tooltip(
                    message: widget.name,
                    preferBelow: false,
                    verticalOffset: 40,
                    child: Text(
                      widget.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${widget.price.toStringAsFixed(2)}",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // Quantity selector
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 28),

                // Quantity controls
                Row(
                  children: [
                    // Decrease button
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        );
                      },
                      child: _QuantityButton(
                        icon: Icons.remove,
                        onPressed: () =>
                            _handleQuantityChange(widget.onDecrease),
                        colorScheme: colorScheme,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Count display
                    Container(
                      constraints: const BoxConstraints(minWidth: 30),
                      alignment: Alignment.center,
                      child: Text(
                        widget.count.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Increase button
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        );
                      },
                      child: _QuantityButton(
                        icon: Icons.add,
                        onPressed: () =>
                            _handleQuantityChange(widget.onIncrease),
                        colorScheme: colorScheme,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: colorScheme.primary.withOpacity(0.1),
      child: InkWell(
        onTap: onPressed,
        splashColor: colorScheme.primary.withOpacity(0.2),
        highlightColor: colorScheme.primary.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
