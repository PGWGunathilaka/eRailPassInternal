import 'package:erailpass_mobile/models/user.dart';
import 'package:erailpass_mobile/widgets/check_ticket.dart';
import 'package:erailpass_mobile/widgets/train_schedules.dart';
import 'package:erailpass_mobile/widgets/user_profile.dart';
import 'package:erailpass_mobile/widgets/sm_userdash.dart';
import 'package:erailpass_mobile/widgets/erailpass_ticket.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class CH_SalmonBar extends StatefulWidget {
  const CH_SalmonBar({super.key});

  @override
  CH_SalmonBarState createState() => CH_SalmonBarState();
}

class CH_SalmonBarState extends State<CH_SalmonBar> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const CheckTicket(role: Role.CHECKER),
      const TrainSchedules(),
      const UserProfilePage(),
    ];

    List<String> titles = [
      "Train Schedule",
      "My profile",
    ];
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.fact_check_outlined),
            title: const Text("Check eRailPass"),
            selectedColor: Color(0xFF921023),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.train),
            title: const Text("Train Schedule"),
            selectedColor: Color(0xFF921023),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Home"),
            selectedColor: Color(0xFF921023),
          ),
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
