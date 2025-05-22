import 'package:flutter/material.dart';

class SearchResultItemWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final num price; // Supports both int and double values.
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Take up the full available width.
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // A subtle gradient and drop shadow for an elegant card look.
          gradient: const LinearGradient(
            colors: [Color(0xFFEFEFEF), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product image with soft rounded corners.
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Expanded details: product name and price.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "\$${price.toDouble().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Icon button for adding to cart.
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: onAddToCart,
                icon: const Icon(Icons.shopping_cart_outlined),
                color: Colors.deepOrangeAccent,
                iconSize: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
