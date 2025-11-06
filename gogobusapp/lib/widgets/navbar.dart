import 'package:flutter/material.dart';
import 'package:gogobusapp/widgets/animated_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  final User? user; // <--- ADD THIS PROPERTY

  const Navbar({super.key, this.user}); // <--- UPDATE CONSTRUCTOR

  @override
  State<Navbar> createState() => _NavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _logoAnimation;
  late Animation<Offset> _textAnimation;

  bool _isOpen = false;
  bool _journeyMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.5, 0.0), // Slide logo to the left
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _textAnimation =
        Tween<Offset>(
          begin: const Offset(-1.0, 0.0), // Start text behind the logo
          end: Offset.zero, // Slide text to its original position
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Placeholder for navigation
  void _navigateTo(String route) {
    // Note: This implementation assumes the route exists in the main MaterialApp routes
    if (route == '/') {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (route != '/logout') {
      Navigator.pushNamed(context, route);
    }

    setState(() {
      _isOpen = false;
    });
  }

  void _handleLogout() async {
    // <--- MAKE ASYNC
    print('Logging out...');
    try {
      await FirebaseAuth.instance.signOut(); // <--- FIREBASE LOGOUT
      // Navigation is now handled by the StreamBuilder in main.dart
    } catch (e) {
      print('Logout Error: $e');
      // Optionally show a snackbar error
    }
  }

  void _goToJourneys(String filter) {
    print('Going to journeys with filter: $filter');
    setState(() {
      _journeyMenuOpen = false;
      _isOpen = false;
    });
    // This route is not defined in main.dart, it would likely lead to an error or another screen.
    _navigateTo('/journeys?filter=$filter');
  }

  final List<Map<String, String>> _navItems = [
    {'label': 'Home', 'to': '/'},
    {'label': 'Feature', 'to': '/feature'},
    {'label': 'Blog', 'to': '/blog'},
    {'label': 'About', 'to': '/about'},
    {'label': 'Contact', 'to': '/contact'},
  ];

  @override
  Widget build(BuildContext context) {
    // 👇 Derived status from the user object passed from main.dart
    final bool isUserLoggedIn = widget.user != null;
    final String firstName =
        widget.user?.displayName?.split(' ').first ?? 'User';

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4,
      toolbarHeight: widget.preferredSize.height,
      titleSpacing: 0,
      title: Builder(
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo and Text with animation
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _navigateTo('/'),
                      child: Container(
                        child: Row(
                          children: [
                            SlideTransition(
                              position: _logoAnimation,
                              child: const AnimatedLogo(),
                            ),
                            // 👇 Removed SizedBox to eliminate gap
                            SlideTransition(
                              position: _textAnimation,
                              child: const Text(
                                'GOGOBUS',
                                style: TextStyle(
                                  color: Color(0xFF00C4B4),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Desktop / Mobile menu toggle (for mobile)
                if (MediaQuery.of(context).size.width <
                    992) // Equivalent to max-lg
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _isOpen = !_isOpen;
                      });
                    },
                  ),

                // Desktop menu items and Right actions
                if (MediaQuery.of(context).size.width >=
                    992) // Equivalent to lg
                  Row(
                    children: [
                      // Journeys Dropdown
                      _buildJourneysDropdown(),
                      ..._navItems.map((item) => _buildNavItem(item)).toList(),

                      // 👇 START AUTHENTICATION LOGIC
                      if (isUserLoggedIn) ...[
                        Text(
                          'Hello, $firstName', // <--- DISPLAY USERNAME
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                print('Notifications pressed');
                              },
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: const Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _handleLogout, // <--- LOGOUT BUTTON
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Text('Logout'),
                        ),
                      ] else ...[
                        ElevatedButton(
                          onPressed: () =>
                              _navigateTo('/signup'), // <--- SIGNUP BUTTON
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Text('Sign up'),
                        ),
                      ],
                      // 👆 END AUTHENTICATION LOGIC
                    ],
                  ),
              ],
            ),
          );
        },
      ),
      bottom: _isOpen
          ? PreferredSize(
              preferredSize: Size.fromHeight(
                MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
                padding: const EdgeInsets.all(16.0),
                // 👇 Wrap with SingleChildScrollView to prevent overflow
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 👇 Logo + Close Button Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _navigateTo('/');
                              setState(() {
                                _isOpen = false;
                              });
                            },
                            child: const Row(
                              children: [
                                AnimatedLogo(),
                                SizedBox(width: 8),
                                Text(
                                  'GOGOBUS',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                _isOpen = false;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _buildJourneysDropdown(isMobile: true),
                      ..._navItems
                          .map((item) => _buildMobileNavItem(item))
                          .toList(),

                      // 👇 MOBILE AUTHENTICATION LOGIC
                      if (isUserLoggedIn) ...[
                        const Divider(),
                        _buildMobileNavItem({
                          'label':
                              'Logout (Hello, $firstName)', // <--- Mobile Display
                          'to': '/logout',
                        }, onPressed: _handleLogout),
                      ] else ...[
                        const Divider(),
                        _buildMobileNavItem({
                          'label': 'Sign up',
                          'to': '/signup',
                        }),
                      ],
                      // 👆 END MOBILE AUTHENTICATION LOGIC
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildJourneysDropdown({bool isMobile = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _journeyMenuOpen = !_journeyMenuOpen;
        });
      },
      child: Row(
        children: [
          const Icon(Icons.flight_takeoff, color: Colors.black54),
          const SizedBox(width: 8),
          Text(
            'Journeys',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontSize: isMobile ? 16 : 14,
            ),
          ),
          if (_journeyMenuOpen)
            const Icon(Icons.arrow_drop_up, color: Colors.black54)
          else
            const Icon(Icons.arrow_drop_down, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildNavItem(Map<String, String> item) {
    return TextButton(
      onPressed: () => _navigateTo(item['to']!),
      child: Text(
        item['label']!,
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(
    Map<String, String> item, {
    VoidCallback? onPressed,
  }) {
    return TextButton(
      onPressed: onPressed ?? () => _navigateTo(item['to']!),
      child: Text(
        item['label']!,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
