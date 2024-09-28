import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';


class SalmonBar extends StatefulWidget {
  const SalmonBar({super.key});

  @override
  SalmonBarState createState() => SalmonBarState();
}
class SalmonBarState extends State<SalmonBar> {
  var _currentIndex = 0;
  Color _colour = Colors.cyan;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      // const UserDashHomePage(),
      // const UserHistoryPage(),
      // const AvailableTrains(),
      // const UserProfilePage(),
    ];

    List<String> titles = [
      "Welcome!",
      "Ticket History",
      "Train Search",
      "My Profile",
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colour,
        title: Text(titles[_currentIndex]),
        leading: const Icon(Icons.train),
      ),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
            _colour = _getSelectedItemColor(i)!;
          });
        },
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.cyan,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.access_time_sharp),
            title: const Text("History"),
            selectedColor: Colors.amberAccent[700],
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text("Search"),
            selectedColor: const Color(0xff72b54a),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.deepOrangeAccent,
          ),

          /// Profile
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: AspectRatio(
              aspectRatio: 6.0,
              child: getLogoImage(_currentIndex),
            ),
          ),
          Container(child: pages[_currentIndex]),
        ],
      ),
    );
  }
}

getLogoImage(int currentIndex) {
  switch (currentIndex) {
    case 0:
      return Image.asset('images/logo.png');
    case 1:
      return Image.asset('images/logo11.png');
    case 2:
      return Image.asset('images/logo111.png');
    default:
      return Image.asset('images/logo.png');
  }
}

Color? _getSelectedItemColor(int index) {
  switch (index) {
    case 0:
      return Colors.cyan;
    case 1:
      return Colors.amberAccent[700];
    case 2:
      return const Color(0xff72b54a);
    case 3:
      return Colors.deepOrangeAccent;
    default:
      return Colors.cyan;
  }
}
