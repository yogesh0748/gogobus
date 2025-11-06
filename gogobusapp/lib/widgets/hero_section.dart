import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase User
// Assuming RealisticCube is defined in this path
import 'package:gogobusapp/widgets/realistic_cube.dart'; 

class HeroSection extends StatelessWidget {
  // 1. Add the User property to receive login state
  final User? user; 

  const HeroSection({super.key, this.user}); // 2. Update the constructor

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    // Use the standard large screen breakpoint
    final bool isDesktop = screenWidth > 992; 

    return Center(
      // Hero Section Container, constraining the width on desktop
      child: Container(
        width: isDesktop ? 1200 : screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 40 : 20, 
          vertical: isDesktop ? 80 : 60,
        ),
        child: isDesktop
            ? Row( // Desktop: Two-column layout
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    // Pass the login state to the content builder
                    child: _buildHeroContent(context, isDesktop, user != null),
                  ),
                  const SizedBox(width: 50),
                  // Cube on the right
                  const RealisticCube(), 
                ],
              )
            : Column( // Mobile: Stacked layout
                children: [
                  // Pass the login state to the content builder
                  _buildHeroContent(context, isDesktop, user != null),
                  const SizedBox(height: 50),
                  // Cube on the bottom
                  const RealisticCube(),
                ],
              ),
      ),
    );
  }

  // Helper function for Hero text content and buttons
  Widget _buildHeroContent(
    BuildContext context, 
    bool isDesktop, 
    bool isUserLoggedIn // 3. Accept the login status
  ) {
    return Column(
      // Align text to the start on desktop, center on mobile
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Your Next Journey, Simplified.",
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? 48 : 36,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Book bus tickets instantly, track your route in real-time, and join a community of satisfied travelers. Your adventure starts here.",
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? 18 : 16,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 30),
                    
        // 4. Conditional Button Logic
        Row(
          // Align buttons to the start on desktop, center on mobile
          mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            // Display "Book Now" if logged in
            if (isUserLoggedIn) ...[
              ElevatedButton(
                onPressed: () {
                  // Navigate to the main booking/search page
                  Navigator.pushNamed(context, '/booking'); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C4B4), // Your theme color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Book Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ] 
            // Display "Sign Up" if not logged in
            else ...[
              ElevatedButton(
                onPressed: () {
                  // Navigate to the sign up screen
                  Navigator.pushNamed(context, '/signup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C4B4), // Your theme color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],

            // Always display the secondary "Learn More" button next to the primary one
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {
                // Navigate to an info/about page
                Navigator.pushNamed(context, '/about');
              },
              child: const Text('Learn More', style: TextStyle(fontSize: 16, color: Colors.black54)),
            ),
          ],
        ),
      ],
    );
  }
}

