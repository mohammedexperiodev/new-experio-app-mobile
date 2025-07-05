import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Simplified data model for dossier cards
class DossierCard {
  final String id;
  final String name;
  final double price;
  final DateTime date;

  DossierCard({
    required this.id,
    required this.name,
    required this.price,
    required this.date,
  });
}

// Enhanced Generic screen widget with Grid View
class GenericScreen extends StatefulWidget {
  final String title;
  final String route;
  final IconData icon;
  final Color color;

  const GenericScreen({
    Key? key,
    required this.title,
    required this.route,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  _GenericScreenState createState() => _GenericScreenState();
}

class _GenericScreenState extends State<GenericScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  String _sortOrder = 'A-Z';
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Enhanced sample data with more dossiers
  List<DossierCard> getSampleDossiers() {
    return [
      DossierCard(
        id: "DSR001",
        name: "Project Alpha",
        price: 2500.00,
        date: DateTime(2024, 1, 15),
      ),
      DossierCard(
        id: "DSR002",
        name: "Marketing Campaign",
        price: 1800.50,
        date: DateTime(2024, 2, 3),
      ),
      DossierCard(
        id: "DSR003",
        name: "System Integration",
        price: 4200.75,
        date: DateTime(2024, 1, 28),
      ),
      DossierCard(
        id: "DSR004",
        name: "Mobile App Development",
        price: 3600.00,
        date: DateTime(2024, 3, 10),
      ),
      DossierCard(
        id: "DSR005",
        name: "Data Analytics",
        price: 2900.25,
        date: DateTime(2024, 2, 18),
      ),
      DossierCard(
        id: "DSR006",
        name: "Cloud Infrastructure",
        price: 5200.00,
        date: DateTime(2024, 3, 22),
      ),
      DossierCard(
        id: "DSR007",
        name: "Security Audit",
        price: 1950.75,
        date: DateTime(2024, 1, 8),
      ),
      DossierCard(
        id: "DSR008",
        name: "User Experience Design",
        price: 3400.50,
        date: DateTime(2024, 2, 28),
      ),
      DossierCard(
        id: "DSR009",
        name: "Database Optimization",
        price: 2750.00,
        date: DateTime(2024, 3, 5),
      ),
      DossierCard(
        id: "DSR010",
        name: "API Development",
        price: 3100.25,
        date: DateTime(2024, 1, 20),
      ),
    ];
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  List<DossierCard> getFilteredAndSortedDossiers() {
    List<DossierCard> dossiers = getSampleDossiers();
    
    // Filter by search
    if (_searchController.text.isNotEmpty) {
      dossiers = dossiers.where((dossier) => 
        dossier.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        dossier.id.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }
    
    // Sort by name
    if (_sortOrder == 'A-Z') {
      dossiers.sort((a, b) => a.name.compareTo(b.name));
    } else {
      dossiers.sort((a, b) => b.name.compareTo(a.name));
    }
    
    return dossiers;
  }

  void navigateToDetail(BuildContext context, DossierCard dossier) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening details for ${dossier.name}'),
        backgroundColor: widget.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DossierCard> filteredDossiers = getFilteredAndSortedDossiers();

    return Scaffold(
      // backgroundColor: Colors.grey[50],
      backgroundColor: Color.fromARGB(255, 241, 244, 251),
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: widget.color,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: Colors.white),
            onSelected: (String value) {
              setState(() {
                _sortOrder = value;
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'A-Z',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha, color: widget.color),
                    SizedBox(width: 8),
                    Text('A-Z'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Z-A',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha, color: widget.color),
                    SizedBox(width: 8),
                    Text('Z-A'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Enhanced Header with Statistics
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.color,
                    widget.color.withOpacity(0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Statistics Card
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_copy, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Total Dossiers: ${filteredDossiers.length}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            
            // Content Area
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text(
                        //   'Dossiers Grid',
                        //   style: GoogleFonts.poppins(
                        //     fontSize: 22,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.black87,
                        //   ),
                        // ),
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        //   decoration: BoxDecoration(
                        //     color: widget.color.withOpacity(0.1),
                        //     borderRadius: BorderRadius.circular(20),
                        //     border: Border.all(color: widget.color.withOpacity(0.3)),
                        //   ),
                        //   child: Text(
                        //     _sortOrder,
                        //     style: GoogleFonts.poppins(
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.w600,
                        //       color: widget.color,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Dossier Grid
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: _buildGridView(filteredDossiers),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search dossiers...',
        hintStyle: GoogleFonts.poppins(color: Colors.white70),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  Widget _buildGridView(List<DossierCard> dossiers) {
    if (dossiers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No dossiers found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: dossiers.length,
      itemBuilder: (context, index) {
        final dossier = dossiers[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + (index * 100)),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: _buildDossierCard(dossier),
            );
          },
        );
      },
    );
  }

  Widget _buildDossierCard(DossierCard dossier) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => navigateToDetail(context, dossier),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Badge
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dossier.id,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: widget.color,
                        ),
                      ),
                    ),
                    // Badge Icon
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.color.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.folder,
                        color: widget.color,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dossier.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: 12),
                      
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                          SizedBox(width: 6),
                          Text(
                            formatDate(dossier.date),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Footer with Price
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.05),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${dossier.price.toStringAsFixed(2)} DH',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: widget.color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}