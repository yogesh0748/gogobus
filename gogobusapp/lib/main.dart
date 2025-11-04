import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Auth
import 'package:gogobusapp/firebase_options.dart';

// Import local widgets and screens
import 'package:gogobusapp/widgets/navbar.dart';
import 'package:gogobusapp/screens/signup_screen.dart';
import 'package:gogobusapp/widgets/realistic_cube.dart'; 
import 'package:gogobusapp/widgets/app_footer.dart'; // Footer

void main() async {
  // 1. ENSURE FLUTTER BINDINGS ARE READY
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. INITIALIZE FIREBASE
  // Ensure your DefaultFirebaseOptions is available
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 3. RUN YOUR APP
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoGoBus App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,

      // 👇 Use StreamBuilder to listen for user changes and determine the home screen
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show a loading indicator while checking the initial state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          // Pass the user object (null if signed out) to MyHomePage
          return MyHomePage(
            title: 'GoGoBus Home',
            user: snapshot.data,
          );
        },
      ),
      
      // ✅ Routes (used for navigation from other screens)
      routes: {
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final User? user; // Accept the User object

  const MyHomePage({super.key, required this.title, this.user});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    // Use the same breakpoint as your Navbar
    final bool isDesktop = screenWidth > 992; 

    return Scaffold(
      // Pass the user object to the Navbar for Sign up/Username display
      appBar: Navbar(user: widget.user), 
      
      // WRAP EVERYTHING IN A SINGLE SCROLLABLE COLUMN
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO SECTION CONTENT
            Center(
              // Hero Section Container
              child: Container(
                width: isDesktop ? 1200 : screenWidth,
                // Add padding based on screen size
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 20, vertical: 40),
                child: isDesktop
                    ? Row( // Desktop: Two-column layout
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildHeroContent(context, isDesktop),
                          ),
                          const SizedBox(width: 50),
                          // Cube on the right
                          const RealisticCube(), 
                        ],
                      )
                    : Column( // Mobile: Stacked layout
                        children: [
                          _buildHeroContent(context, isDesktop),
                          const SizedBox(height: 50),
                          // Cube on the bottom
                          const RealisticCube(),
                        ],
                      ),
              ),
            ),
            
            // 2. SPACER to push the footer down
            SizedBox(height: isDesktop ? 80 : 50), 

            // 3. FOOTER INTEGRATION
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // Helper function for Hero text content and buttons
  Widget _buildHeroContent(BuildContext context, bool isDesktop) {
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
        Row(
          // Align buttons to the start on desktop, center on mobile
          mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO: Implement navigation to Search/Booking page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C4B4), // Your theme color
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Book Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('Sign Up', style: TextStyle(fontSize: 16, color: Color(0xFF00C4B4))),
            ),
          ],
        ),
      ],
    );
  }
}