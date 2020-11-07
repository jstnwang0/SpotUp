import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spot_up/widgets/gmap.dart';
import '../main.dart';
import 'package:spot_up/widgets/main_image_widget.dart';
import 'package:spot_up/widgets/tab_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final panelController = PanelController();
  final double tabBarHeight = 40;
  final brandcolor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: brandcolor,
        ),
        body: SlidingUpPanel(
          minHeight: 150,
          controller: panelController,
          maxHeight: MediaQuery.of(context).size.height - tabBarHeight,
          panelBuilder: (scrollController) => buildSlidingPanel(
            scrollController: scrollController,
            panelController: panelController,
          ),
          body: MapSample(),
        ),
      );

  Widget buildSlidingPanel({
    @required PanelController panelController,
    @required ScrollController scrollController,
  }) =>
      DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: buildTabBar(
            onClicked: panelController.open,
          ),
          body: TabBarView(
            children: [
              TabWidget(scrollController: scrollController),
              TabWidget(scrollController: scrollController),
            ],
          ),
        ),
      );

  Widget buildTabBar({
    @required VoidCallback onClicked,
  }) =>
      PreferredSize(
        preferredSize: Size.fromHeight(tabBarHeight - 8),
        child: GestureDetector(
          onTap: onClicked,
          child: AppBar(
            title: buildDragIcon(), // Icon(Icons.drag_handle),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(child: Text('Secluded')),
                Tab(child: Text('Fitness')),
              ],
            ),
          ),
        ),
      );

  Widget buildDragIcon() => Container(
        decoration: BoxDecoration(
          color: brandcolor,
          borderRadius: BorderRadius.circular(8),
        ),
        width: 60,
        height: 8,
      );
}
