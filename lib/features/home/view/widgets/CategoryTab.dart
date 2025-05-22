import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Map of category names to their respective icons.
final Map<String, IconData> categoryIconMap = {
  'all':FontAwesomeIcons.list,
  'living room': FontAwesomeIcons.couch,
  'kids room': FontAwesomeIcons.child,
  'bedroom': FontAwesomeIcons.bed,
  'guest room': FontAwesomeIcons.hotel,
  'dining room': FontAwesomeIcons.utensils,
  // Add new category mappings as needed.
};

/// Helper function that dynamically assigns an icon based on category name.
IconData getIconForCategory(String? categoryName) {
  print(categoryName);
  return categoryIconMap[categoryName?.trim().toLowerCase()] ?? FontAwesomeIcons.box;
}

void defaultCategoryTap() {
  print("The default category was tapped");
}

class CategoryTab extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            Chip(
              backgroundColor:
                  isSelected ? Colors.black : const Color(0xFFF4F0EB),
              label: Center(
                child: Icon(
                  getIconForCategory(title), // Dynamically get the icon!
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title!,
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 12,
                color: Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
