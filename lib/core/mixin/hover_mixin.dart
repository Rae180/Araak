// lib/core/mixins/hover_mixin.dart
import 'package:flutter/widgets.dart';
import '../constants/app_constants.dart';


mixin HoverMixin<T extends StatefulWidget> on State<T> {
  bool _isHovered = false;
  bool get isHovered => _isHovered;
  
  Widget buildHoverable({
    required Widget child,
    double scale = AppConstants.hoverScale,
    double translate = AppConstants.hoverTranslate,
    bool applyTransform = true,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppConstants.hoverDuration,
        curve: Curves.easeOut,
        transform: applyTransform
            ? (Matrix4.identity()
              ..translate(0.0, isHovered ? translate : 0.0)
              ..scale(isHovered ? scale : 1.0))
            : null,
        child: child,
      ),
    );
  }
}