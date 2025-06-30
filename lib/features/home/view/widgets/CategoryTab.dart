import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/mixin/hover_mixin.dart';

final Map<String, IconData> categoryIconMap = {
  'all': FontAwesomeIcons.list,
  'living room': FontAwesomeIcons.couch,
  'kids room': FontAwesomeIcons.child,
  'bedroom': FontAwesomeIcons.bed,
  'guest room': FontAwesomeIcons.hotel,
  'dining room': FontAwesomeIcons.utensils,
};

IconData getIconForCategory(String? categoryName) {
  return categoryIconMap[categoryName?.trim().toLowerCase()] ??
      FontAwesomeIcons.box;
}

class CategoryTab extends StatefulWidget {
  final String? title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTab({
    super.key,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> with HoverMixin {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final accentColor = theme.colorScheme.secondary;
    final unselectedColor = isDarkMode 
        ? Colors.grey.shade300.withOpacity(0.7) 
        : Colors.grey.shade700;
    
    return Semantics(
      button: true,
      label: '${widget.title} category',
      selected: widget.isSelected,
      child: Tooltip(
        message: widget.title!,
        preferBelow: false,
        verticalOffset: 40,
        child: buildHoverable(
          applyTransform: false,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              splashColor: accentColor.withOpacity(0.2),
              highlightColor: accentColor.withOpacity(0.1),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 60),
                margin: const EdgeInsets.only(right: AppConstants.elementSpacing),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon with animated selection effect
                    AnimatedContainer(
                      duration: AppConstants.hoverDuration,
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? accentColor
                            : (isHovered 
                                ? accentColor.withOpacity(0.1)
                                : theme.cardColor),
                        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                        boxShadow: widget.isSelected
                            ? [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : isHovered
                                ? [
                                    BoxShadow(
                                      color: accentColor.withOpacity(0.2),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                : null,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        getIconForCategory(widget.title),
                        size: 24,
                        color: widget.isSelected
                            ? Colors.white
                            : (isHovered ? accentColor : unselectedColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Category name with truncation
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 80),
                      child: Text(
                        widget.title!,
                        style: TextStyle(
                          fontFamily: AppConstants.primaryFont,
                          fontSize: 12,
                          fontWeight: widget.isSelected 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                          color: widget.isSelected
                              ? accentColor
                              : (isHovered ? accentColor : unselectedColor),
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}