import 'package:flutter/material.dart';

class DiscountWidget extends StatelessWidget {
  final String imageUrl;
  final String discountPercentage; // E.g. "30" for 30% off.
  final String endDate; // E.g. "30/09/2025".
  final num originalPrice;
  final num discountedPrice;
  final VoidCallback onTap;

  const DiscountWidget({
    Key? key,
    required this.onTap,
    required this.imageUrl,
    required this.discountPercentage,
    required this.endDate,
    required this.originalPrice,
    required this.discountedPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 230, // Fixed width similar to your trending style.
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
              // Background Image
              SizedBox(
                height: 270,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
              // Blurred Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.55),
                        Colors.transparent,
                        Colors.black.withOpacity(0.25),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              // Discount Badge
              Positioned(
                top: 10,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "$discountPercentage% OFF",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
              // Price & End Date Overlay
              Positioned(
                bottom: 10,
                left: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price row: discounted price in bold with original price struck-through.
                    Row(
                      children: [
                        Text(
                          "\$${discountedPrice.toDouble().toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "\$${originalPrice.toDouble().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            decoration: TextDecoration.lineThrough,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // End Date text.
                    Text(
                      "Ends on $endDate",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
