// File: widgets/Navigation/sidebar_menu.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart'; // For HexColor
import 'package:get/get.dart';
import 'package:taskez/Screens/Auth/login.dart';

// Model classes for menu structure
class MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final List<MenuItem>? children;
  final String? route;

  MenuItem({
    required this.title,
    required this.icon,
    required this.color,
    this.children,
    this.route,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json['title'] ?? 'Unknown',
      icon: _getIconFromString(json['icon'] ?? 'folder'),
      color: _getColorFromString(json['color'] ?? 'grey'),
      route: json['route'],
      children: json['children'] != null
          ? (json['children'] as List)
              .map((child) => MenuItem.fromJson(child))
              .toList()
          : null,
    );
  }

  static IconData _getIconFromString(String? iconName) {
    if (iconName == null) return Icons.folder;

    // Map string names to actual IconData
    const iconMap = {
      'shopping_cart': Icons.shopping_cart,
      'point_of_sale': Icons.point_of_sale,
      'input': Icons.input,
      'output': Icons.output,
      'receipt': Icons.receipt,
      'account_balance': Icons.account_balance,
      'credit_card': Icons.credit_card,
      'inventory': Icons.inventory,
      'analytics': Icons.analytics,
    };
    return iconMap[iconName] ?? Icons.folder;
  }

  static Color _getColorFromString(String? colorName) {
    if (colorName == null) return Colors.grey;

    const colorMap = {
      'blue': Colors.blue,
      'green': Colors.green,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'teal': Colors.teal,
      'indigo': Colors.indigo,
      'red': Colors.red,
      'amber': Colors.amber,
      'cyan': Colors.cyan,
    };
    return colorMap[colorName] ?? Colors.grey;
  }
}

class SidebarMenu extends StatefulWidget {
  // Callback to update the main app bar title
  final Function(String)? onMenuItemSelected;

  const SidebarMenu({Key? key, this.onMenuItemSelected}) : super(key: key);

  @override
  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu>
    with TickerProviderStateMixin {
  // Animation controllers for smooth transitions
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Sample JSON data - in real app, this would come from API/file
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _loadMenuItems();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  // Load menu items from JSON-like structure
  void _loadMenuItems() {
    final sampleMenuData = [
      {
        "title": "Achats",
        "icon": "shopping_cart",
        "color": "blue",
        "route": "/purchase"
      },
      {
        "title": "Ventes",
        "icon": "point_of_sale",
        "color": "green",
        "route": "/sale"
      },
      {
        "title": "Importations",
        "icon": "input",
        "color": "orange",
        "route": "/imports"
      },
      {
        "title": "Exportations",
        "icon": "output",
        "color": "teal",
        "route": "/exports"
      },
      {
        "title": "Reçus",
        "icon": "receipt",
        "color": "amber",
        "route": "/receipts"
      },
      {
        "title": "Banque",
        "icon": "account_balance",
        "color": "indigo",
        "route": "/bank"
      },
      {"title": "CMI", "icon": "credit_card", "color": "cyan", "route": "/cmi"},
    ];

    setState(() {
      menuItems =
          sampleMenuData.map((item) => MenuItem.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Drawer(
        // backgroundColor: HexColor.fromHex("#1a1d23"),
        backgroundColor: Colors.white,
        // backgroundColor: Color.fromARGB(255, 175, 230, 255),
        child: Column(
          children: [
            // Enhanced header with custom colors and close button
            _buildEnhancedDrawerHeader(),

            // Dynamic menu items with multilevel support
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return _buildMenuItemWidget(menuItems[index]);
                },
              ),
            ),

            // Footer section
            _buildDrawerFooter(context),
          ],
        ),
      ),
    );
  }

  // Footer with app version and close button
  Widget _buildEnhancedDrawerHeader() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HexColor.fromHex("#357ABD"),
            HexColor.fromHex("#181a1f"),
            HexColor.fromHex("#357ABD"),
            // HexColor.fromHex("#87CEEB"), // Light blue
            // HexColor.fromHex("#4A90E2"), // Slightly darker blue
            // HexColor.fromHex("#357ABD"), // Even darker blue
          ],
        ),
      ),
      child: Stack(
        children: [
          // Logo in center
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                // borderRadius: BorderRadius.circular(60),
                borderRadius: BorderRadius.circular(80),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(58),
                child: Image.asset(
                  'assets/logo_experio.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Close button in top-right corner
          Positioned(
            top: 40,
            right: 16,
            child: Container(
              width: 40, // ✅ Set width
              height: 40, // ✅ Set height
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                // color: Colors.black.withOpacity(0.5),
                // borderRadius: BorderRadius.circular(20),
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                splashRadius: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dynamic menu item widget - simplified for single items only
  Widget _buildMenuItemWidget(MenuItem item) {
    // Only single menu items - no expandable functionality needed
    return _buildSingleMenuItem(item);
  }

  Widget _buildSingleMenuItem(MenuItem item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          Icons.keyboard_arrow_right, // Right arrow for single items
          color: Colors.black,
          size: 20,
        ),
        title: Text(
          item.title,
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            item.icon,
            color: item.color,
            size: 22,
          ),
        ),
        onTap: () {
          // Update app bar title
          if (widget.onMenuItemSelected != null) {
            widget.onMenuItemSelected!(item.title);
          }
          Navigator.of(context).pop();
          _navigateToRoute(item.route);
        },
        hoverColor: item.color.withOpacity(0.1),
        splashColor: item.color.withOpacity(0.2),
      ),
    );
  }

  // Footer section
  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            // color: Colors.grey[700]!,
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            // leading: Icon(Icons.settings, color: Colors.grey[400]),
            leading: Icon(Icons.settings, color: Colors.black),
            title: Text(
              "Settings",
              style: GoogleFonts.lato(
                // color: Colors.grey[400],
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            onTap: () {
              if (widget.onMenuItemSelected != null) {
                widget.onMenuItemSelected!("Settings");
              }
              Navigator.of(context).pop();
              _navigateToRoute("/settings"); // Navigate to settings
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red[400]),
            title: Text(
              "Logout",
              style: GoogleFonts.lato(
                color: Colors.red[400],
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              _handleLogout();
            },
          ),
        ],
      ),
    );
  }

  // Navigation helper - UPDATED WITH PROPER NAVIGATION
  void _navigateToRoute(String? route) {
    if (route == null || route.isEmpty) {
      print("No route specified");
      return;
    }

    print("Navigating to: $route");

    // Use Navigator.pushNamed for navigation
    try {
      Navigator.pushNamed(context, route);
    } catch (e) {
      print("Navigation error: $e");
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation error: Unable to navigate to $route'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Logout helper
  void _handleLogout() {
    print("Logging out...");

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Logout',
            style: GoogleFonts.lato(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.lato(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog

                // Navigate to login screen using Get
                Get.offAll(() =>
                    Login(email: ""));

                // // Show logout success message
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text('Logged out successfully'),
                //     backgroundColor: Colors.green,
                //   ),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
