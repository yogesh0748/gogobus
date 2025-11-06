// lib/widgets/realistic_cube.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

class RealisticCube extends StatefulWidget {
  const RealisticCube({super.key});

  @override
  State<RealisticCube> createState() => _RealisticCubeState();
}

class _RealisticCubeState extends State<RealisticCube> with TickerProviderStateMixin {
  // Controllers for the different animation types
  late AnimationController _rotationController;
  late AnimationController _translationControllerX;
  late AnimationController _translationControllerY;

  // Animations for continuous rotation
  late Animation<double> _rotateY;
  late Animation<double> _rotateX;

  // Animations for jitter (small X/Y movement)
  late Animation<double> _translateX;
  late Animation<double> _translateY;

  double _size = 100.0; // Initial max size

  @override
  void initState() {
    super.initState();

    // 1. Continuous Rotation Controller (Framer Motion rotateY/rotateX)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 30), 
      vsync: this,
    )..repeat();

    _rotateY = Tween<double>(begin: 0, end: 2 * math.pi * (30 / 12)).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear));
      
    _rotateX = Tween<double>(begin: 0, end: 2 * math.pi * (30 / 15)).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear));

    // 2. Jitter/Translation Controller X (Framer Motion x: 4s)
    _translationControllerX = AnimationController(
      duration: const Duration(seconds: 4), 
      vsync: this,
    )..repeat(reverse: true);

    _translateX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 8), weight: 1), 
      TweenSequenceItem(tween: Tween<double>(begin: 8, end: -8), weight: 2), 
      TweenSequenceItem(tween: Tween<double>(begin: -8, end: 0), weight: 1), 
    ]).animate(CurvedAnimation(parent: _translationControllerX, curve: Curves.easeInOut));


    // 3. Jitter/Translation Controller Y (Framer Motion y: 5s)
    _translationControllerY = AnimationController(
      duration: const Duration(seconds: 5), 
      vsync: this,
    )..repeat(reverse: true);

    _translateY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -8), weight: 1), 
      TweenSequenceItem(tween: Tween<double>(begin: -8, end: 8), weight: 2), 
      TweenSequenceItem(tween: Tween<double>(begin: 8, end: 0), weight: 1), 
    ]).animate(CurvedAnimation(parent: _translationControllerY, curve: Curves.easeInOut));
  }

  // Responsive logic based on the user's JS code
  void _handleResize(double width) {
    double newSize;
    if (width < 420) {
      newSize = math.min(160, (width * 0.62).floorToDouble());
    } else if (width < 768) {
      newSize = math.min(220, (width * 0.5).floorToDouble());
    } else if (width < 1200) {
      newSize = math.min(260, (width * 0.35).floorToDouble());
    } else {
      newSize = 300;
    }

    if (newSize != _size) {
      // Use setState to trigger rebuild only if size changes
      setState(() {
        _size = newSize;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update size when screen dimensions change
    _handleResize(MediaQuery.of(context).size.width);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _translationControllerX.dispose();
    _translationControllerY.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double halfSize = _size / 2;
    
    // Define the asset paths and 3D rotation matrix for each face
    final List<Map<String, dynamic>> facesData = [
      // 🐛 FIX APPLIED: Use the cascading operator (..) to chain modifications on Matrix4
      {'asset': 'assets/face1.png', 'transform': Matrix4.identity()..translate(0.0, 0.0, halfSize)}, // Front
      {'asset': 'assets/face2.jpeg', 'transform': Matrix4.rotationY(math.pi / 2)..translate(0.0, 0.0, halfSize)}, // Right
      {'asset': 'assets/face3.jpeg', 'transform': Matrix4.rotationY(math.pi)..translate(0.0, 0.0, halfSize)}, // Back
      {'asset': 'assets/face4.jpeg', 'transform': Matrix4.rotationY(-math.pi / 2)..translate(0.0, 0.0, halfSize)}, // Left
      {'asset': 'assets/face5.png', 'transform': Matrix4.rotationX(math.pi / 2)..translate(0.0, 0.0, halfSize)}, // Top
      {'asset': 'assets/face6.png', 'transform': Matrix4.rotationX(-math.pi / 2)..translate(0.0, 0.0, halfSize)}, // Bottom
    ];

    // Animates both the continuous rotation and the jitter translation
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationController,
        _translationControllerX,
        _translationControllerY
      ]),
      builder: (context, child) {
        // Combined 3D Rotation and Perspective Matrix
        final Matrix4 rotationMatrix = Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateY(_rotateY.value) 
          ..rotateX(_rotateX.value)
          ..translate(_translateX.value, _translateY.value); // Jitter

        return Transform(
          alignment: Alignment.center,
          transform: rotationMatrix,
          child: SizedBox(
            width: _size,
            height: _size,
            // Stack is the container for the 6 faces
            child: Stack(
              children: facesData.map((data) {
                return Positioned.fill(
                  child: Transform(
                    alignment: Alignment.center,
                    // Apply the specific face rotation and translation
                    transform: data['transform'] as Matrix4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        // Flutter equivalent of box-shadow
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          data['asset'].toString(),
                          width: _size,
                          height: _size,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}