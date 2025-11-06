 

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gogobusapp/firebase_options.dart';

// Import local widgets and screens
import 'package:gogobusapp/widgets/navbar.dart';
import 'package:gogobusapp/screens/signup_screen.dart';
// ⚠️ NEW IMPORT
import 'package:gogobusapp/widgets/hero_section.dart'; 
import 'package:gogobusapp/widgets/app_footer.dart';

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

      // Use StreamBuilder to listen for user changes and determine the home screen
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
        // NOTE: Add a placeholder route for booking/search page
        '/booking': (context) => const Placeholder(child: Center(child: Text("Booking Screen"))), 
        '/about': (context) => const Placeholder(child: Center(child: Text("About Screen"))),
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
    final bool isDesktop = MediaQuery.of(context).size.width > 992; 

    return Scaffold(
      // Pass the user object to the Navbar for Sign up/Username display
      appBar: Navbar(user: widget.user), 
      
      // WRAP EVERYTHING IN A SINGLE SCROLLABLE COLUMN
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO SECTION 
            // 🔑 IMPORTANT: Pass the User object to HeroSection
            HeroSection(user: widget.user), 
            
            // 2. SPACER to push the footer down
            SizedBox(height: isDesktop ? 80 : 50), 

            // 3. FOOTER INTEGRATION
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}




