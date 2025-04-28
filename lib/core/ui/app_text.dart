import 'package:flutter/material.dart';

enum TextType { medium, bold, regular }

enum FontFamily { tajawal, reboto }

class AppText extends StatefulWidget {
  final String text;
  final Color? color;
  final bool bold;
  final int maxLength;
  final bool italic;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool readMore;
  final TextType? type;
  final TextStyle? style;
  final bool allowExpand;
  final double? fontSize;
  final TextDecoration? decoration;
  final TextOverflow? textOverflow;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final FontFamily fontFamily;

  const AppText(this.text,
      {Key? key,
      this.color,
      this.bold = false,
      this.allowExpand = true,
      this.italic = false,
      this.textOverflow ,
      this.textAlign,
      this.maxLength = 60,
      this.decoration,
      this.maxLines,
      this.readMore = false,
      this.type = TextType.medium,
      this.fontWeight,
      this.fontSize,
      this.letterSpacing,
      this.style,
      this.fontFamily = FontFamily.tajawal})
      : super(key: key);

  @override
  _AppTextState createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  bool hidden = false;

  FontWeight? _getFontWeight() {
    if (widget.bold) {
      return FontWeight.bold;
    }
    switch (widget.type) {
      case TextType.medium:
        return FontWeight.w500;
      case TextType.bold:
        return FontWeight.w600;
      case TextType.regular:
        return FontWeight.w400;
      default:
        return FontWeight.w500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Text(
              !hidden
                  ? widget.text
                  : (widget.text.substring(
                      0,
                      widget.text.length > widget.maxLength
                          ? widget.maxLength
                          : widget.text.length)),
              textAlign: widget.textAlign,
              overflow: widget.maxLines != null
                  ? ((widget.maxLines! > 1)
                      ? TextOverflow.fade
                      : TextOverflow.ellipsis)
                  : null,
              maxLines: widget.maxLines,
              style: widget.style ??
                  TextStyle(
                    fontStyle: widget.italic ? FontStyle.italic : null,
                    overflow: widget.textOverflow,
                    color: widget.color ?? Colors.black,
                    fontSize: widget.fontSize ?? 16,
                    letterSpacing: widget.letterSpacing ?? 0.5,
                    fontWeight: widget.fontWeight ?? _getFontWeight(),
                  ),
            ),
            if (widget.readMore &&
                widget.text.length > widget.maxLength &&
                hidden)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[
                    Theme.of(context).backgroundColor,
                    Theme.of(context).backgroundColor.withOpacity(0),
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                  height: 30,
                ),
              )
          ],
        ),
        if (widget.allowExpand &&
            widget.readMore &&
            widget.text.length > widget.maxLength)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  hidden = !hidden;
                });
              },
              child: Text(
                hidden ? "Read More" : "Read less",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w800,
                  // fontFamily: "OpenSans",
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
    );
  }
}
