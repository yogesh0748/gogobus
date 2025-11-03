import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isSignup = true;
  bool loading = false;
  String error = "";

  final TextEditingController fname = TextEditingController();
  final TextEditingController lname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  void handleSubmit() async {
    setState(() {
      loading = true;
      error = "";
    });

    await Future.delayed(const Duration(seconds: 2)); // simulate API

    if (email.text.isEmpty || password.text.isEmpty) {
      setState(() {
        error = "Please fill all fields";
        loading = false;
      });
      return;
    }

    setState(() {
      loading = false;
    });

    Navigator.pop(context);
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
                    Image.asset(
                      'assets/logo.png', // make sure you have this asset
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

                if (isSignup)
                  Row(
                    children: [
                      Expanded(child: buildInput("First Name", fname)),
                      const SizedBox(width: 10),
                      Expanded(child: buildInput("Last Name", lname)),
                    ],
                  ),
                if (isSignup) const SizedBox(height: 10),

                buildInput("Email", email),
                const SizedBox(height: 10),
                buildInput("Password", password, isPassword: true),

                const SizedBox(height: 20),

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
        onPressed: () => setState(() => isSignup = signup),
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
