import 'package:flutter/material.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/blog/blog_screen.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/explorer/explorer_screen.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/map_tab.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/saved_places.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/safety_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialTabIndex;

  const HomeScreen({super.key, this.initialTabIndex = 2});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late int selectedIndex;
  String? mapCoordinates;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialTabIndex;
  }

  void backToMap({String? coordinates}) {
    setState(() {
      selectedIndex = 3;
      mapCoordinates = coordinates;
    });
  }

    void backToSatefyTips() {
    setState(() {
      selectedIndex = 4;
    });
  }

 List<Widget> get _pages => [
        SavedPlaces(onShowInMap: backToMap),
        const BlogScreen(),
        ExplorerScreen(onShowInMap: backToMap, backToSafetyTips: backToSatefyTips,),
        MapPage(initialCoordinates: mapCoordinates),
        const SafetyScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/onboard.png', fit: BoxFit.cover),
          ),
          _pages[selectedIndex],
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2E1D),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabItem(0, Icons.bookmark),
                  _buildTabItem(1, Icons.menu_book),
                  _buildTabItem(2, Icons.explore),
                  _buildTabItem(3, Icons.map),
                  _buildTabItem(4, Icons.shield),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selectedIndex == index ? Colors.white : const Color(0xFF101E0F),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          size: 30,
          color:
              selectedIndex == index ? const Color(0xFF101E0F) : Colors.white,
        ),
      ),
    );
  }
}
