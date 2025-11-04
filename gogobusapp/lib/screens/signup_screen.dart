import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. Import Firebase Auth

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Get an instance of the Firebase Authentication service
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isSignup = true;
  bool loading = false;
  String error = "";

  final TextEditingController fname = TextEditingController();
  final TextEditingController lname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  void handleSubmit() async {
    // 1. Initial State Check and Loading
    if (email.text.isEmpty || password.text.isEmpty) {
      setState(() {
        error = "Please enter both email and password.";
      });
      return;
    }

    setState(() {
      loading = true;
      error = "";
    });

    try {
      if (isSignup) {
        // 2. FIREBASE SIGN UP LOGIC
        await _auth.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
        
        // Optionally update display name after sign-up
        await _auth.currentUser?.updateDisplayName("${fname.text} ${lname.text}");
        
      } else {
        // 3. FIREBASE SIGN IN LOGIC
        await _auth.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
      }

      // 4. Success: Navigate away and reset loading
      setState(() {
        loading = false;
      });
      
      // If successful, navigate back (or to the main screen)
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      // 5. Error Handling
      String errorMessage = "An unknown error occurred.";
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        // Fallback for other errors like network issues
        errorMessage = e.message ?? errorMessage;
      }
      
      setState(() {
        error = errorMessage;
        loading = false;
      });
      
    } catch (e) {
      // General error (e.g., network)
      setState(() {
        error = "Network or connectivity error. Please try again.";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // LOGO + Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // NOTE: Ensure you have 'assets/logo.png' configured in pubspec.yaml
                    Image.asset(
                      'assets/logo.png', 
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "GOGOBUS",
                      style: TextStyle(
                        color: Color(0xFF00C4B4),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Toggle Buttons
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildToggleButton("Sign up", true),
                      buildToggleButton("Sign in", false),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                Text(
                  isSignup ? "Create an Account" : "Welcome Back",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),

                // Error Message Display
                if (error.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 15),

                // First/Last Name Fields (Signup only)
                if (isSignup)
                  Row(
                    children: [
                      Expanded(child: buildInput("First Name", fname)),
                      const SizedBox(width: 10),
                      Expanded(child: buildInput("Last Name", lname)),
                    ],
                  ),
                if (isSignup) const SizedBox(height: 10),

                // Email and Password Fields
                buildInput("Email", email),
                const SizedBox(height: 10),
                buildInput("Password", password, isPassword: true),

                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: loading ? null : handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C4B4),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isSignup ? "Create Account" : "Sign In"),
                ),

                const SizedBox(height: 25),
                const Text(
                  "OR SIGN IN WITH",
                  style: TextStyle(color: Colors.black45),
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialButton(Icons.g_mobiledata),
                    const SizedBox(width: 15),
                    socialButton(Icons.apple),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI Helpers ---
  Widget buildInput(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: hint.toLowerCase().contains("email") ? TextInputType.emailAddress : TextInputType.text, // Better UX
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildToggleButton(String text, bool signup) {
    final bool selected = isSignup == signup;
    return Expanded(
      child: TextButton(
        onPressed: () => setState(() {
          isSignup = signup;
          error = ""; // Clear error when toggling mode
        }),
        style: TextButton.styleFrom(
          backgroundColor:
              selected ? const Color(0xFF00C4B4) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget socialButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(icon, color: const Color(0xFF00C4B4), size: 28),
    );
  }
}