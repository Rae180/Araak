import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:start/core/constants/app_constants.dart';

class FabricDetailsWidget extends StatelessWidget {
  final num? fabricLength;
  final String? fabricType;
  final String? fabricColor;

  const FabricDetailsWidget({
    Key? key,
    required this.fabricLength,
    required this.fabricType,
    required this.fabricColor,
  }) : super(key: key);

  Color _getColorFromName(String? colorName) {
    if (colorName == null) return Colors.grey;
    const colorMap = {
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
      'beige': Color(0xFFF5F5DC),
      'olive': Color(0xFF808000),
    };
    return colorMap[colorName.toLowerCase()] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayFabricColor = _getColorFromName(fabricColor);

    return Container(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.fabricdet,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppConstants.elementSpacing),
          _buildDetailRow(
            context,
            icon: Icons.straighten,
            label: AppLocalizations.of(context)!.length,
            value: fabricLength != null ? "$fabricLength cm" : "N/A",
          ),
          const SizedBox(height: AppConstants.elementSpacing / 2),
          _buildDetailRow(
            context,
            icon: Icons.category,
            label: AppLocalizations.of(context)!.type,
            value: fabricType ?? "N/A",
          ),
          const SizedBox(height: AppConstants.elementSpacing / 2),
          _buildColorRow(context, displayFabricColor),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildColorRow(BuildContext context, Color displayColor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Icon(Icons.color_lens, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          "${l10n.color}: ",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: displayColor,
            border: Border.all(
              color: colorScheme.onSurface.withOpacity(0.2),
            ),
          ),
        ),
        Text(
          fabricColor != null ? fabricColor!.toUpperCase() : "N/A",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}