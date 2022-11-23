// import 'dart:ui';

import 'package:drivers_app/constants/constan_color.dart';
import 'package:drivers_app/tabPages/earning_tab.dart';
import 'package:drivers_app/tabPages/home_tab.dart';
import 'package:drivers_app/tabPages/profile_tab.dart';
import 'package:drivers_app/tabPages/ratings_tab.dart';
import 'package:flutter/material.dart';

class MainSCreen extends StatefulWidget {
  MainSCreen({Key? key}) : super(key: key);

  @override
  State<MainSCreen> createState() => _MainSCreenState();
}

class _MainSCreenState extends State<MainSCreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectIndex = index;
      tabController!.index = selectIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningsTabPage(),
          RatingsTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Earning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Rating',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        unselectedItemColor: Colors.amber,
        selectedItemColor: Colors.white,
        backgroundColor: blueColor,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 17),
        showUnselectedLabels: true,
        currentIndex: selectIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
