// File: widgets/Navigation/sidebar_menu.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/Values/values.dart'; // For HexColor

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
  // Track which menu item is currently expanded (only ONE at a time)
  String? currentlyExpanded;

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
    // This simulates loading from a JSON file
    // In real app: final jsonString = await rootBundle.loadString('assets/menu.json');
    // final menuData = json.decode(jsonString);

    final sampleMenuData = [
    {
      "title": "Achats",
      "icon": "shopping_cart",
      "color": "blue",
      "children": [
        {"title": "Bons de commande", "route": "/purchase/orders"},
        {"title": "Facture d'achat", "route": "/purchase/invoice"},
        {"title": "Retours d'achat", "route": "/purchase/returns"},
        {"title": "Gestion des fournisseurs", "route": "/purchase/suppliers"},
      ]
    },
    {
      "title": "Ventes",
      "icon": "point_of_sale",
      "color": "green",
      "children": [
        {"title": "Bons de livraison", "route": "/sale/orders"},
        {"title": "Facture de vente", "route": "/sale/invoice"},
        {"title": "Retours de vente", "route": "/sale/returns"},
        {
          "title": "Gestion des clients",
          "route": "/sale/customers",
          "children": [
            {"title": "Ajouter un client", "route": "/sale/customers/add"},
            {"title": "Rapports clients", "route": "/sale/customers/reports"},
          ]
        },
      ]
    },
    {
      "title": "Analytique",
      "icon": "analytics",
      "color": "purple",
      "route": "/analytics"
    },
    {
      "title": "Importations",
      "icon": "input",
      "color": "orange",
      "children": [
        {"title": "Déclaration d'importation", "route": "/imports/declaration"},
        {"title": "Documents douaniers", "route": "/imports/customs"},
        {"title": "Détails d'expédition", "route": "/imports/shipping"},
      ]
    },
    {
      "title": "Exportations",
      "icon": "output",
      "color": "teal",
      "children": [
        {"title": "Déclaration d'exportation", "route": "/exports/declaration"},
        {"title": "Documents douaniers", "route": "/exports/customs"},
        {"title": "Détails d'expédition", "route": "/exports/shipping"},
      ]
    },
    {
      "title": "Reçus",
      "icon": "receipt",
      "color": "amber",
      "children": [
        {"title": "Gestion des reçus", "route": "/receipts/management"},
        {"title": "Rapports de reçus", "route": "/receipts/reports"},
        {"title": "Modèles de reçus", "route": "/receipts/templates"},
      ]
    },
    {
      "title": "Banque",
      "icon": "account_balance",
      "color": "indigo",
      "children": [
        {"title": "Comptes bancaires", "route": "/bank/accounts"},
        {"title": "Transactions", "route": "/bank/transactions"},
        {"title": "Relevés bancaires", "route": "/bank/statements"},
      ]
    },
    {
      "title": "CMI",
      "icon": "credit_card",
      "color": "cyan",
      "children": [
        {
          "title": "Gestion des stocks",
          "route": "/cmi/inventory",
          "children": [
            {"title": "Ajouter un stock", "route": "/cmi/inventory/add"},
            {"title": "Rapports de stock", "route": "/cmi/inventory/reports"},
          ]
        },
        {
          "title": "Analyse financière",
          "route": "/cmi/analytics",
          "children": [
            {"title": "Analyse des ventes", "route": "/cmi/analytics/sales"},
            {
              "title": "Analyse des achats",
              "route": "/cmi/analytics/purchase"
            },
          ]
        },
      ]
    },
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

  // Dynamic menu item widget that handles any level of nesting
  Widget _buildMenuItemWidget(MenuItem item) {
    if (item.children == null || item.children!.isEmpty) {
      // Single menu item without children
      return _buildSingleMenuItem(item);
    } else {
      // Expandable menu item with children
      return _buildExpandableMenuItem(item);
    }
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
          // color: Colors.grey[400],
          // color: const Color.fromARGB(255, 0, 0, 0),
          color: Colors.black,
          size: 20,
        ),
        title: Text(
          item.title,
          style: GoogleFonts.lato(
            // color: Colors.white,
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

  // Expandable menu item with children
  Widget _buildExpandableMenuItem(MenuItem item) {
    bool isExpanded = currentlyExpanded == item.title;

    return Column(
      children: [
        // Main menu item
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                isExpanded ? item.color.withOpacity(0.1) : Colors.transparent,
          ),
          child: ListTile(
            leading: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0.0,
              duration: Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                // color: Colors.grey[400],
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text(
              item.title,
              style: GoogleFonts.lato(
                // color: Colors.white,
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
              setState(() {
                if (isExpanded) {
                  currentlyExpanded = null;
                } else {
                  currentlyExpanded = item.title;
                }
              });
            },
            hoverColor: item.color.withOpacity(0.1),
            splashColor: item.color.withOpacity(0.2),
          ),
        ),

        // Children with smooth animation - Better approach with flexible height
        ClipRect(
          child: AnimatedAlign(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            heightFactor: isExpanded ? 1.0 : 0.0,
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: item.children!
                    .map((child) =>
                        _buildChildMenuItem(child, item.color, item.title))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Calculate height needed for children (handles nested children too)
  double _calculateChildrenHeight(List<MenuItem> children) {
    double height = 0;
    for (var child in children) {
      height += 56; // Increased base height for each child (ListTile height)
      if (child.children != null && child.children!.isNotEmpty) {
        height += 48 *
            child.children!.length; // More accurate height for nested children
      }
    }
    // Add some padding to prevent overflow
    return height + 20;
  }

  // Child menu item (can also have children for multilevel support)
  Widget _buildChildMenuItem(
      MenuItem child, Color parentColor, String parentTitle) {
    bool hasChildren = child.children != null && child.children!.isNotEmpty;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: Icon(
              hasChildren ? Icons.folder_open : Icons.arrow_forward_ios,
              // color: Colors.grey[500],
              color: Colors.black,
              size: hasChildren ? 16 : 12,
            ),
            title: Text(
              child.title,
              style: GoogleFonts.lato(
                // color: Colors.grey[300],
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Container(
              width: 3,
              height: 20,
              decoration: BoxDecoration(
                color: parentColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            onTap: () {
              // Update app bar title with parent-child format
              if (widget.onMenuItemSelected != null) {
                widget.onMenuItemSelected!("$parentTitle - ${child.title}");
              }
              Navigator.of(context).pop();
              _navigateToRoute(child.route);
            },
            hoverColor: parentColor.withOpacity(0.05),
            splashColor: parentColor.withOpacity(0.1),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),

          // Handle nested children (multilevel)
          if (hasChildren)
            ...child.children!
                .map((nestedChild) => Container(
                      margin: EdgeInsets.only(left: 20),
                      child: _buildNestedChildMenuItem(nestedChild, parentColor,
                          "$parentTitle - ${child.title}"),
                    ))
                .toList(),
        ],
      ),
    );
  }

  // Nested child menu item (third level)
  Widget _buildNestedChildMenuItem(
      MenuItem nestedChild, Color parentColor, String fullParentTitle) {
    return ListTile(
      dense: true,
      leading: Icon(
        Icons.subdirectory_arrow_right,
        // color: Colors.grey[600],
        color: Colors.black,
        size: 14,
      ),
      title: Text(
        nestedChild.title,
        style: GoogleFonts.lato(
          // color: Colors.grey[400],
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
      ),
      trailing: Container(
        width: 2,
        height: 15,
        decoration: BoxDecoration(
          color: parentColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
      onTap: () {
        // Update app bar title with full hierarchy
        if (widget.onMenuItemSelected != null) {
          widget.onMenuItemSelected!("$fullParentTitle - ${nestedChild.title}");
        }
        Navigator.of(context).pop();
        _navigateToRoute(nestedChild.route);
      },
      hoverColor: parentColor.withOpacity(0.03),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
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

  // Navigation helper
  void _navigateToRoute(String? route) {
    if (route == null || route.isEmpty) {
      print("No route specified");
      return;
    }
    print("Navigating to: $route");
    // Implement your navigation logic here
    // Navigator.pushNamed(context, route);
  }

  // Logout helper
  void _handleLogout() {
    print("Logging out...");
    // Implement your logout logic here
  }
}
