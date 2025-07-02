// File: widgets/Navigation/sidebar_menu.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarMenu extends StatefulWidget {
  @override
  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  // Track which menu item is currently expanded (only ONE at a time)
  String? currentlyExpanded;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Dark background to match your app theme
      backgroundColor: Color(0xFF1a1d23),
      child: Column(
        children: [
          // HEADER SECTION
          _buildDrawerHeader(),
          
          // NAVIGATION MENU ITEMS with MULTILEVEL support
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Purchase section with children
                _buildExpandableMenuSection(
                  title: "Purchase",
                  icon: Icons.shopping_cart,
                  color: Colors.blue,
                  children: [
                    "Purchase Orders",
                    "Purchase Invoice",
                    "Purchase Returns",
                    "Supplier Management",
                  ],
                ),
                
                // Sale section with children
                _buildExpandableMenuSection(
                  title: "Sale",
                  icon: Icons.point_of_sale,
                  color: Colors.green,
                  children: [
                    "Sales Orders",
                    "Sales Invoice",
                    "Sales Returns",
                    "Customer Management",
                  ],
                ),
                
                // Imports section with children
                _buildExpandableMenuSection(
                  title: "Imports",
                  icon: Icons.input,
                  color: Colors.orange,
                  children: [
                    "Import Declaration",
                    "Customs Documents",
                    "Shipping Details",
                  ],
                ),
                
                // Exports section with children
                _buildExpandableMenuSection(
                  title: "Exports",
                  icon: Icons.output,
                  color: Colors.purple,
                  children: [
                    "Export Declaration",
                    "Export Invoice",
                    "Shipping Manifest",
                  ],
                ),
                
                // Receipts section with children
                _buildExpandableMenuSection(
                  title: "Receipts",
                  icon: Icons.receipt,
                  color: Colors.teal,
                  children: [
                    "Payment Receipts",
                    "Cash Receipts",
                    "Digital Receipts",
                  ],
                ),
                
                // Bank section with children
                _buildExpandableMenuSection(
                  title: "Bank",
                  icon: Icons.account_balance,
                  color: Colors.indigo,
                  children: [
                    "Bank Accounts",
                    "Transactions",
                    "Bank Statements",
                    "Wire Transfers",
                  ],
                ),
                
                // CMI section with children
                _buildExpandableMenuSection(
                  title: "CMI",
                  icon: Icons.credit_card,
                  color: Colors.red,
                  children: [
                    "Card Payments",
                    "Online Payments",
                    "Payment Gateway",
                  ],
                ),
              ],
            ),
          ),
          
          // FOOTER SECTION
          _buildDrawerFooter(context),
        ],
      ),
    );
  }

  // HEADER: App logo and title
  Widget _buildDrawerHeader() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2d3142),
            Color(0xFF1a1d23),
          ],
        ),
      ),
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: 150, // You can adjust size here
            height: 150,
            child: Image.asset(
              'assets/logo_experio.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }


  // EXPANDABLE MENU SECTION: Main menu with expandable children
  Widget _buildExpandableMenuSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> children,
  }) {
    bool isExpanded = currentlyExpanded == title;
    
    return Column(
      children: [
        // MAIN MENU ITEM with RTL layout
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // Highlight if expanded
            color: isExpanded ? color.withOpacity(0.1) : Colors.transparent,
          ),
          child: ListTile(
            // ARROW ON LEFT - rotates based on expanded state
            leading: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0.0, // 0.5 = 180 degrees (arrow up)
              duration: Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down, // Arrow down by default
                color: Colors.grey[400],
                size: 20,
              ),
            ),
            
            // TITLE IN CENTER
            title: Center(
              child: Text(
                title,
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            // ICON ON RIGHT with custom color
            trailing: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            
            // Handle tap - SINGLE EXPANSION LOGIC
            onTap: () {
              setState(() {
                if (isExpanded) {
                  // If this item is already expanded, close it
                  currentlyExpanded = null;
                } else {
                  // Close any other expanded item and open this one
                  currentlyExpanded = title;
                }
              });
            },
            
            // Visual feedback
            hoverColor: color.withOpacity(0.1),
            splashColor: color.withOpacity(0.2),
          ),
        ),
        
        // ANIMATED CHILDREN - slide down/up with animation
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isExpanded ? (children.length * 50.0) : 0,
          child: Container(
            margin: EdgeInsets.only(right: 24), // RIGHT margin for RTL design
            child: Column(
              children: children.map((childTitle) => _buildChildMenuItem(
                title: childTitle,
                color: color,
                parentTitle: title,
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // CHILD MENU ITEM: Sub-items under main categories (RTL layout)
  Widget _buildChildMenuItem({
    required String title,
    required Color color,
    required String parentTitle,
  }) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: ListTile(
        // Small arrow for child items on LEFT
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.grey[500],
          size: 12,
        ),
        
        // Child item title in CENTER
        title: Center(
          child: Text(
            title,
            style: GoogleFonts.lato(
              color: Colors.grey[300],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        
        // Small indicator line on RIGHT
        trailing: Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: color.withOpacity(0.6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        
        // Handle child item tap
        onTap: () {
          // Close the drawer first
          Navigator.of(context).pop();
          
          // Navigate to the specific child page
          _navigateToChildSection(parentTitle, title);
        },
        
        // Visual feedback
        hoverColor: color.withOpacity(0.05),
        splashColor: color.withOpacity(0.1),
        
        // Reduce padding for child items
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  // FOOTER: Settings and logout options
  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[700]!,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // Settings option
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey[400]),
            title: Text(
              "Settings",
              style: GoogleFonts.lato(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              // Navigate to settings
            },
          ),
          
          // Logout option
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
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  // NAVIGATION LOGIC: Route to different main sections
  void _navigateToSection(BuildContext context, String section) {
    switch (section) {
      case "Purchase":
        print("Navigate to Purchase main page");
        break;
      case "Sale":
        print("Navigate to Sale main page");
        break;
      case "Imports":
        print("Navigate to Imports main page");
        break;
      case "Exports":
        print("Navigate to Exports main page");
        break;
      case "Receipts":
        print("Navigate to Receipts main page");
        break;
      case "Bank":
        print("Navigate to Bank main page");
        break;
      case "CMI":
        print("Navigate to CMI main page");
        break;
      default:
        print("Unknown section: $section");
    }
  }

  // NAVIGATION LOGIC: Route to specific child sections
  void _navigateToChildSection(String parent, String child) {
    print("Navigate to: $parent -> $child");
    
    // Example routing logic:
    switch ("$parent-$child") {
      case "Purchase-Purchase Orders":
        // Navigator.pushNamed(context, '/purchase/orders');
        break;
      case "Purchase-Purchase Invoice":
        // Navigator.pushNamed(context, '/purchase/invoice');
        break;
      case "Sale-Sales Orders":
        // Navigator.pushNamed(context, '/sale/orders');
        break;
      case "Bank-Bank Accounts":
        // Navigator.pushNamed(context, '/bank/accounts');
        break;
      // Add more cases as needed...
      default:
        print("Navigate to: $parent -> $child");
    }
  }
}