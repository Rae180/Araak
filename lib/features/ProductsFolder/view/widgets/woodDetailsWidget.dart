import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WoodDetailsWidget extends StatelessWidget {
  final num? woodLength;
  final num? woodWidth;
  final num? woodHeight;
  final String? woodType;
  final String? woodColor;

  const WoodDetailsWidget({
    Key? key,
    required this.woodLength,
    required this.woodWidth,
    required this.woodHeight,
    required this.woodType,
    required this.woodColor,
  }) : super(key: key);

  // Maps common color names to a Flutter Color.
  Color _getColorFromName(String? colorName) {
    if (colorName == null) return Colors.grey;
    final Map<String, Color> colorMap = {
      'red': Colors.red,
      'green': Colors.green,
      'blue': Colors.blue,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'brown': Colors.brown,
      'grey': Colors.grey,
      'gray': Colors.grey,
      'black': Colors.black,
      'white': Colors.white,
      'olive': Colors.green, // Adjust mapping as needed.
      // Add additional mappings as required.
    };
    return colorMap[colorName.toLowerCase()] ?? Colors.grey;
  }

  /// Widget builder for detail rows
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.brown),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color displayWoodColor = _getColorFromName(woodColor);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              AppLocalizations.of(context)!.wooddet,
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.straighten,
              label: AppLocalizations.of(context)!.length,
              value: woodLength != null ? "$woodLength cm" : "N/A",
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.straighten,
              label: AppLocalizations.of(context)!.width,
              value: woodWidth != null ? "$woodWidth cm" : "N/A",
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.linear_scale,
              label: AppLocalizations.of(context)!.hieght,
              value: woodHeight != null ? "$woodHeight cm" : "N/A",
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.category,
              label: AppLocalizations.of(context)!.type,
              value: woodType ?? "N/A",
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.color_lens, color: Colors.brown, size: 20),
                const SizedBox(width: 8),
                 Text(
                  "${AppLocalizations.of(context)!.color}: ",
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: displayWoodColor.withOpacity(0.9),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  woodColor != null ? woodColor!.toUpperCase() : "N/A",
                  style: const TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
