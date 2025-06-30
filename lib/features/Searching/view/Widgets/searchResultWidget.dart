import 'package:flutter/material.dart';
import 'package:start/core/constants/app_constants.dart';

class SearchResultItemWidget extends StatefulWidget {
  final String imageUrl;
  final String name;
  final num price;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const SearchResultItemWidget({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.onTap,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  State<SearchResultItemWidget> createState() => _SearchResultItemWidgetState();
}

class _SearchResultItemWidgetState extends State<SearchResultItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppConstants.hoverDuration,
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(AppConstants.elementSpacing),
          decoration: BoxDecoration(
            color: isDarkMode
                ? colorScheme.surface.withOpacity(0.7)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            gradient: isDarkMode
                ? LinearGradient(
                    colors: [
                      colorScheme.surface.withOpacity(0.8),
                      colorScheme.surface.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFFEFEFEF), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.deepPurple.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ],
          ),
          transform: Matrix4.identity()
            ..scale(_isHovered ? AppConstants.hoverScale : 1.0),
          child: Row(
            children: [
              // Product image with error handling
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                child: Image.network(
                  widget.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: colorScheme.surfaceVariant,
                      child: Icon(Icons.image_not_supported,
                          color: colorScheme.onSurfaceVariant),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "\$${widget.price.toDouble().toStringAsFixed(2)}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Add to cart button with hover effect
              AnimatedContainer(
                duration: AppConstants.hoverDuration,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: widget.onAddToCart,
                  icon: Icon(Icons.shopping_cart_outlined,
                      color: colorScheme.primary),
                  iconSize: 28,
                  tooltip: 'Add to cart',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}