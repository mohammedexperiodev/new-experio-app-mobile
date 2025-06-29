import 'package:flutter/material.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/widgets/Dashboard/overview_task_container.dart';
import 'package:taskez/widgets/Dashboard/task_progress_card.dart';
import 'package:tcard/tcard.dart';

// import 'package:taskez/Screens/Projects/project.dart'; // Import your ProjectScreen
import 'package:taskez/Screens/Dashboard/projects.dart'; // Import your ProjectScreen
import 'package:get/get.dart'; // Added Get import for navigation
import 'package:taskez/Screens/Dashboard/search_screen.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dynamic data = AppData.progressIndicatorList;

    List<Widget> cards = List.generate(
        5,
        (index) => TaskProgressCard(
              cardTitle: data[index]['cardTitle'],
              rating: data[index]['rating'],
              progressFigure: data[index]['progress'],
              percentageGap: int.parse(data[index]['progressBar']),
            ));

    return Column(
      children: [
        Container(
          height: 150,
          child: TCard(
            cards: cards,
          ),
        ),
        AppSpaces.verticalSpace10,
        Column(
          children: [
            OverviewTaskContainer(
                cardTitle: "All orders",
                numberOfItems: "40",
                imageUrl: "assets/all_order_icon.png",
                // backgroundColor: HexColor.fromHex("EFA17D,"),
                backgroundColor: HexColor.fromHex("90CAF9"),
                onTap: () { // Added navigation callback
                   Get.to(() => SearchScreen());
                }
                ),
            OverviewTaskContainer(
                cardTitle: "Completed",
                numberOfItems: "32",
                imageUrl: "assets/completed_icon.png",
                // backgroundColor: HexColor.fromHex("2196F3")
                backgroundColor: HexColor.fromHex("90CAF9")
                ),
            OverviewTaskContainer(
                cardTitle: "categories",
                numberOfItems: "8",
                imageUrl: "assets/category_icon.png",
                // backgroundColor: HexColor.fromHex("EDA7FA"),
                // backgroundColor: HexColor.fromHex("FFC107"),
                backgroundColor: HexColor.fromHex("90CAF9"),
                onTap: () { // Added navigation callback
                  Get.to(() => ProjectScreen());
                }
                ),
          ],
        ),
      ],
    );
  }
}
