import 'package:erailpass_mobile/models/user.dart';
import 'package:erailpass_mobile/widgets/check_ticket.dart';
import 'package:erailpass_mobile/widgets/issue_ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ERailPassTicketPage extends StatelessWidget {

  const ERailPassTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity, // Set width to fill available space
            height: 200, // Set desired height
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CheckTicket(role: Role.STATION_MASTER),
                    ),
                  );
                },

                style: OutlinedButton.styleFrom(
                  // primary: Colors.white,
                  side: BorderSide(color: Color(0xFFbc3f59), width: 2.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Activate',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF921023), // Set the text color here
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity, // Set width to fill available space
            height: 200, // Set desired height
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const IssueTicket(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  // primary: Colors.white,
                  side: BorderSide(color: Color(0xFFbc3f59), width: 2.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Issue',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF921023), // Set the text color here
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
