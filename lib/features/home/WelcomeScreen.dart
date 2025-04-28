import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Custom clipper that draws an eye (almond) shape.
class EyeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    // Draw the top curve: from left center to right center with control at top center,
    // then the bottom curve back to the left center with control at bottom center.
    path.moveTo(0, h / 2);
    path.quadraticBezierTo(w / 2, 0, w, h / 2);
    path.quadraticBezierTo(w / 2, h, 0, h / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Custom painter that draws a thick, smooth border along the inside of the eye shape.
class EyeEdgePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  EyeEdgePainter({this.color = Colors.white, this.strokeWidth = 8.0});

  @override
  void paint(Canvas canvas, Size size) {
    final clipper = EyeClipper();
    final path = clipper.getClip(size);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      // The stroke is centered; by clipping the canvas to the path, we ensure the outside part is hidden.
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round; // Makes curve transitions smoother.

    canvas.save();
    // Clip the canvas to the eye path so the stroke is rendered inside.
    canvas.clipPath(path);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WelcomeScreen extends HookWidget {
  static const String routeName = '/welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Animation controller for simulating the camera movement (forward motion)
    final cameraController =
        useAnimationController(duration: Duration(seconds: 5));
    // Animation controller for the fading "Tap on Screen" text.
    final textController =
        useAnimationController(duration: Duration(seconds: 1));

    // Scale animation for the background (simulates the camera moving forward).
    final scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: cameraController, curve: Curves.easeInOut),
    );

    // Animation for the eye (hole) size: gradually grows from small to larger.
    final holeSizeAnimation = Tween<double>(begin: 50, end: 150).animate(
      CurvedAnimation(parent: cameraController, curve: Curves.easeInOut),
    );

    // Start the camera animation; once it completes, fade in the text.
    useEffect(() {
      cameraController.forward().whenComplete(() {
        textController.forward();
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        // Navigate to the next screen once the text fade-in is complete.
        onTap: () {
          if (textController.isCompleted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NextScreen()),
            );
          }
        },
        child: Stack(
          children: [
            // Full-screen background with a red gradient and scaling animation.
            AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: scaleAnimation.value,
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade700, Colors.red.shade300],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                );
              },
            ),
            // The animated eye-shaped hole.
            AnimatedBuilder(
              animation: holeSizeAnimation,
              builder: (context, child) {
                return Center(
                  child: Transform.rotate(
                    // Tilt the eye to the left by 37°.
                    angle: -37 * pi / 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow effect behind the eye.
                        Container(
                          width: holeSizeAnimation.value,
                          height: holeSizeAnimation.value,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.7),
                                Colors.white.withOpacity(0.0)
                              ],
                              radius: 0.8,
                            ),
                          ),
                          child: ClipPath(
                            clipper: EyeClipper(),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                        // The filled eye shape.
                        ClipPath(
                          clipper: EyeClipper(),
                          child: Container(
                            width: holeSizeAnimation.value,
                            height: holeSizeAnimation.value,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        // The thick inner border (edge) with a smooth, inward curve.
                        CustomPaint(
                          size: Size(
                            holeSizeAnimation.value,
                            holeSizeAnimation.value,
                          ),
                          painter: EyeEdgePainter(
                            color: Colors.white,
                            strokeWidth: 8, // Adjust this value for thicker or thinner edges.
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // "Tap on Screen" text that fades in after the animations complete.
            FadeTransition(
              opacity: textController,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: Text(
                    "Tap on Screen",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// A placeholder for the next scene.
class NextScreen extends StatelessWidget {
  const NextScreen({Key? key}) : super(key: key);
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Next Scene")),
      body: const Center(
        child: Text("Welcome to the next scene!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
