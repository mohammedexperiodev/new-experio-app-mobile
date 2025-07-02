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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor.fromHex("#181a1f"),

        // GLOBAL SIDE DRAWER - Defined once here, slides from RIGHT side
        endDrawer: SidebarMenu(),
        
        // GLOBAL APP BAR - Defined once here, appears on all screens
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Transparent background
          elevation: 0, // No shadow
          // Custom burger menu button on the RIGHT side
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu, // Hamburger menu icon
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  // Opens the drawer from the RIGHT side
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
          // Dynamic page title based on current screen
          title: ValueListenableBuilder(
            valueListenable: bottomNavigatorTrigger,
            builder: (context, value, child) {
              return Text(
                pageTitles[value as int], // Changes title based on selected tab
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
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
                ])));
  }
}
