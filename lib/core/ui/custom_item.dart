
import 'package:flutter/material.dart';

/// Custom Item widget
/// [startIcon] icon at the start of the widget
/// [startIconSize] icon size of start icon
/// [startIconColor] icon color of start icon
/// [endIcon] icon at the end of the widget
/// [endIconSize] icon size of end icon
/// [endIconColor] icon color of end icon
/// [disabled] disabled on tap function
/// [onTap] opTap function
/// [padding] padding of the widget
/// [child] child of the widget
/// [decoration] decoration of the widget
class CustomItem extends StatelessWidget {
  final IconData? startIcon;
  final double startIconSize;
  final Color? startIconColor;
  final bool disabled;
  final Function? onTap;
  final EdgeInsets? padding;
  final Widget? child;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const CustomItem(
      {Key? key,
        this.startIcon,
        this.disabled= false,
        this.onTap,
        this.startIconColor,
        this.padding,
        this.child,
        this.startIconSize = 19,
        this.crossAxisAlignment = CrossAxisAlignment.center,
        this.mainAxisAlignment = MainAxisAlignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: InkWell(
        onTap: () {
          if (onTap != null) onTap!();
        },
        child: Padding(
          padding: padding != null
              ? padding!
              : const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            crossAxisAlignment: crossAxisAlignment,
            children: <Widget>[
              if (startIcon != null)
                 Expanded(
                    flex: 1,
                    child: Icon(
                      startIcon,
                      color: startIconColor ?? Theme.of(context).primaryColor,
                      size: startIconSize,
                    ),

                ),
              if (startIcon != null) const SizedBox(width: 18.0),
              Expanded(
                flex: 10,
                child: child!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
