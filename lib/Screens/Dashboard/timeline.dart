import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:taskez/BottomSheets/bottom_sheets.dart';
import 'package:taskez/Constants/constants.dart';
import 'package:taskez/Screens/Dashboard/dashboard.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Dashboard/bottomNavigationItem.dart';
import 'package:taskez/widgets/Dashboard/dashboard_add_icon.dart';
import 'package:taskez/widgets/Dashboard/dashboard_add_sheet.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:taskez/widgets/Navigation/sidebar_menu.dart';

class Timeline extends StatefulWidget {
  Timeline({Key? key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  ValueNotifier<int> bottomNavigatorTrigger = ValueNotifier(0);

  StatelessWidget currentScreen = Dashboard();

  final PageStorageBucket bucket = PageStorageBucket();

  // Define page titles for each screen
  List<String> pageTitles = [
    "Dashboard", // Index 0
    "Tasks", // Index 1
    "Notifications", // Index 2
    "Search" // Index 3
  ];

  // Current sidebar menu title (starts with default)
  String currentSidebarTitle = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor.fromHex("#181a1f"),

        // Enhanced sidebar with callback for title updates
        endDrawer: SidebarMenu(
          onMenuItemSelected: (String menuTitle) {
            setState(() {
              currentSidebarTitle = menuTitle;
            });
          },
        ),

        // Enhanced app bar with dynamic title switching
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          backgroundColor: Colors.blue,
          elevation: 0,
          actions: [
            Builder(
              builder: (context) => Container(
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  // color: HexColor.fromHex("#357ABD").withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    // color: HexColor.fromHex("#357ABD").withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  splashRadius: 20,
                ),
              ),
            ),
          ],

          // Smart title switching between bottom nav and sidebar
          title: ValueListenableBuilder(
            valueListenable: bottomNavigatorTrigger,
            builder: (context, value, child) {
              // Show sidebar title if it's not the default, otherwise show bottom nav title
              String displayTitle = (currentSidebarTitle != "Dashboard" &&
                      currentSidebarTitle.isNotEmpty)
                  ? currentSidebarTitle
                  : pageTitles[value as int];

              return AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: Offset(0.0, -0.5),
                        end: Offset.zero,
                      ),
                    ),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Row(
                  key: ValueKey(displayTitle),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon indicator for sidebar vs bottom nav
                    if (currentSidebarTitle != "Dashboard")
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: HexColor.fromHex("#357ABD").withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),

                    // Title text
                    Flexible(
                      child: Text(
                        displayTitle,
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                    // Breadcrumb indicator for nested items
                    if (displayTitle.contains(' - '))
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          centerTitle: true,
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(children: [
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "topLeft",
          ),
          ValueListenableBuilder(
              valueListenable: bottomNavigatorTrigger,
              builder: (BuildContext context, _, __) {
                return PageStorage(
                    child: dashBoardScreens[bottomNavigatorTrigger.value],
                    bucket: bucket);
              })
        ]),
        bottomNavigationBar: Container(
            width: double.infinity,
            height: 90,
            padding: EdgeInsets.only(top: 10, right: 30, left: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: HexColor.fromHex("#181a1f").withOpacity(0.8)),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BottomNavigationItem(
                      itemIndex: 0,
                      notifier: bottomNavigatorTrigger,
                      icon: Icons.widgets),
                  Spacer(),
                  BottomNavigationItem(
                      itemIndex: 1,
                      notifier: bottomNavigatorTrigger,
                      icon: FeatherIcons.clipboard),
                  Spacer(),
                  DashboardAddButton(
                    iconTapped: (() {
                      showAppBottomSheet(Container(
                          height: Utils.screenHeight * 0.8,
                          child: DashboardAddBottomSheet()));
                    }),
                  ),
                  Spacer(),
                  BottomNavigationItem(
                      itemIndex: 2,
                      notifier: bottomNavigatorTrigger,
                      icon: FeatherIcons.bell),
                  Spacer(),
                  BottomNavigationItem(
                      itemIndex: 3,
                      notifier: bottomNavigatorTrigger,
                      icon: FeatherIcons.search)
                ]))
                );
  }
}
