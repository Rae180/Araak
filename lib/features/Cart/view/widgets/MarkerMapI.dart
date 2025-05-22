import 'package:flutter/material.dart';

class RealisticMarker extends StatelessWidget {
  const RealisticMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // Use a Stack to layer the circle and the pointer.
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Outer red circle with shadow.
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          // Inner white circle with the red location icon.
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 20,
            ),
          ),
          // Positioned triangle pointer below the circle.
          Positioned(
            bottom: -10,
            child: CustomPaint(
              size: const Size(20, 10),
              painter: TrianglePainter(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    // Draw a simple triangle
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
