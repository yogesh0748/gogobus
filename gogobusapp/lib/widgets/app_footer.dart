// lib/widgets/app_footer.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Requires dependency

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine screen width for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 992;
    
    // Define the primary and accent colors from your theme
    const Color primaryColor = Colors.deepPurple;
    const Color accentColor = Color(0xFF00C4B4); // Your GOGOBUS teal color

    // Define Footer Link Sections
    final List<Map<String, dynamic>> sections = [
      {
        'title': 'GOGOBUS',
        'links': [
          {'label': 'About Us', 'route': '/about'},
          {'label': 'Careers', 'route': '/careers'},
          {'label': 'Blog', 'route': '/blog'},
          {'label': 'Our Buses', 'route': '/fleet'},
        ],
      },
      {
        'title': 'Support',
        'links': [
          {'label': 'Contact Us', 'route': '/contact'},
          {'label': 'FAQs', 'route': '/faq'},
          {'label': 'Help Center', 'route': '/help'},
          {'label': 'Privacy Policy', 'route': '/privacy'},
        ],
      },
      {
        'title': 'Destinations',
        'links': [
          {'label': 'North Route', 'route': '/north'},
          {'label': 'South Route', 'route': '/south'},
          {'label': 'West Route', 'route': '/west'},
          {'label': 'East Route', 'route': '/east'},
        ],
      },
    ];

    return Container(
      color: primaryColor, // Use the primary theme color for the footer background
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 40,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. MAIN CONTENT (Links and Branding)
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Logo/Name
                    _buildBranding(accentColor),
                    
                    // Link Sections
                    ...sections.map((section) => _buildLinkSection(
                          section['title'] as String,
                          section['links'] as List<Map<String, String>>,
                          isDesktop: isDesktop,
                        )),
                    
                    // Social Media/CTA (Optional separate column)
                    _buildSocialAndAppStore(accentColor),
                  ],
                )
              : Column( // Mobile Layout
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBranding(accentColor),
                    const SizedBox(height: 30),
                    // Stack sections vertically on mobile
                    ...sections.map((section) => _buildLinkSection(
                          section['title'] as String,
                          section['links'] as List<Map<String, String>>,
                          isDesktop: isDesktop,
                        )),
                    const SizedBox(height: 30),
                    _buildSocialAndAppStore(accentColor),
                  ],
                ),
          
          // Divider Line
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Divider(color: Colors.white54, height: 1),
          ),
          
          // 2. COPYRIGHT BAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© ${DateTime.now().year} GoGoBus. All rights reserved.',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              if (isDesktop) 
                _buildSocialIcons(accentColor), // Show social icons on desktop only (as they are above on mobile)
            ],
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildBranding(Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Placeholder for the GOGOBUS logo text
        Text(
          'GOGOBUS',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 10),
        const SizedBox(
          width: 200,
          child: Text(
            'The fastest way to travel and see the world.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkSection(String title, List<Map<String, String>> links, {required bool isDesktop}) {
    // Wrap the link section in a SizedBox for desktop to control width
    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 15),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () {
                  // TODO: Implement navigation to link['route']!
                },
                child: Text(
                  link['label']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            )),
      ],
    );
    
    return isDesktop
        ? SizedBox(width: 150, child: content) // Fixed width for desktop columns
        : Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: content,
          );
  }

  Widget _buildSocialAndAppStore(Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Get the App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 15),
        // Placeholder for App Store/Play Store Buttons
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download_for_offline, color: Colors.white),
          label: const Text('Download Now', style: TextStyle(color: Colors.white)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white54),
          ),
        ),
        const SizedBox(height: 25),
        
        // Social Icons for Mobile (and positioned above Copyright bar on Desktop)
        _buildSocialIcons(accentColor),
      ],
    );
  }

  Widget _buildSocialIcons(Color accentColor) {
    return Row(
      children: [
        _buildSocialIcon(FontAwesomeIcons.facebook, accentColor),
        _buildSocialIcon(FontAwesomeIcons.twitter, accentColor),
        _buildSocialIcon(FontAwesomeIcons.instagram, accentColor),
        _buildSocialIcon(FontAwesomeIcons.linkedin, accentColor),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: IconButton(
        icon: FaIcon(icon, size: 20, color: Colors.white70),
        onPressed: () {
          // TODO: Implement link opening
        },
      ),
    );
  }
}