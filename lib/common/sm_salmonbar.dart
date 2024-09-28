import 'package:erailpass_mobile/widgets/train_schedules.dart';
import 'package:erailpass_mobile/widgets/user_profile.dart';
import 'package:erailpass_mobile/widgets/sm_userdash.dart';
import 'package:erailpass_mobile/widgets/erailpass_ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class SM_SalmonBar extends StatefulWidget {
  const SM_SalmonBar({super.key});

  @override
  SM_SalmonBarState createState() => SM_SalmonBarState();
}

class SM_SalmonBarState extends State<SM_SalmonBar> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const ERailPassTicketPage(),
      const Center(child: Text('Reservation & Seasonal Pass')),
      const TrainSchedules(),
      const UserProfilePage(),
    ];

    List<String> titles = [
      "eRailPass",
      "Reservation",
      "Train Schedule",
      "My profile",
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        leading: const Icon(Icons.train),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.add_card),
            title: const Text("eRailPass"),
            selectedColor: Color(0xFF921023),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.account_balance_wallet_sharp),
            title: const Text("Reservation"),
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
