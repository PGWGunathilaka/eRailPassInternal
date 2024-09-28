import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:erailpass_mobile/common/ch_salmonbar.dart';
import 'package:erailpass_mobile/common/date_util.dart';
import 'package:erailpass_mobile/common/stations_dropdown.dart';
import 'package:erailpass_mobile/common/textbox.dart';
import 'package:erailpass_mobile/context/ticket_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../models/ticket.dart';

class ChargeFine extends StatefulWidget {
  final Ticket? ticket;

  const ChargeFine({super.key, this.ticket});

  @override
  State<ChargeFine> createState() => _TicketState();
}

class _TicketState extends State<ChargeFine> {
  String? _comment = "";
  int _fine = 0;

  String? _selectedAction;
  int ticketIndex = 0;

  bool get _canSubmit => _fine != null;

  @override
  void initState() {
    super.initState();
    _fine = ((widget.ticket?.price ?? 0) * 2) + 5000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charge fine'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [],
      ),
      body: Container(
        padding:
            const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: TextBoxWidget(
                  label: 'Add a comment',
                  labelText: 'Type your comment here',
                  onChanged: (String val) {
                    setState(() {
                      _comment = val;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10), // Add some spacing
              //Text('Comment: $_comment'), // Display the comment

              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: const Text('Action'),
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedAction,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAction = newValue;
                      });
                    },
                    items: <String>[
                      'Charged fine full amount',
                      'Dropped from the train',
                    ].map((String e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextBoxWidget(
                  label: 'Amount',
                  labelText: 'Type fine amount here',
                  onChanged: (String val) {
                    setState(() {
                      _fine = int.parse(val);
                    });
                  },
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CH_SalmonBar()));
                },
                style: OutlinedButton.styleFrom(
                  // primary: Colors.white,
                  side: BorderSide(color: Color(0xFF921023), width: 2.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF921023), // Set the text color here
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
