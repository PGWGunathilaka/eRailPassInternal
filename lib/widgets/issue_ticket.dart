import 'package:erailpass_mobile/common/datepicker.dart';
import 'package:erailpass_mobile/common/stations_dropdown.dart';
import 'package:erailpass_mobile/common/stations_multiselect.dart';
import 'package:erailpass_mobile/models/station.dart';
import 'package:erailpass_mobile/models/ticket.dart';
import 'package:erailpass_mobile/widgets/ticket_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../common/textbox.dart';

class IssueTicket extends StatefulWidget {
  final Station? fromStation;
  final Station? toStation;
  final DateTime? date;

  const IssueTicket({super.key, this.fromStation, this.toStation, this.date});

  @override
  State<IssueTicket> createState() => _IssueTicketState();
}

class _IssueTicketState extends State<IssueTicket> {
  Station? _fromStation;
  Station? _toStation;
  DateTime? _date;
  int? _tClass;

  @override
  void initState() {
    super.initState();
    _fromStation = widget.fromStation;
    _toStation = widget.toStation;
    _date = widget.date ?? DateTime.now();
  }


  void createTicket(BuildContext context) {
    // Ticket ticket = Ticket(
    //     null, 0, _fromStation!, _toStation!, _date!, false, _tClass!, null);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => TicketPayment(ticket: ticket)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('issuing Tickets'),
      ),
      body: Container(
        padding:
            const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: const Text('Date'),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: DatePicker(
                      initialDate: _date,
                      onChange: (DateTime date) {
                        setState(() {
                          _date = date;
                        });
                      },
                    ),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      padding: const EdgeInsets.only(right: 18),
                      child: const Text('From'),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: StationDropDown(onChanged: (value) {
                      setState(() {
                        _fromStation = value;
                      });
                    }),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: const Text('Class'),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: DropdownMenu<int>(
                      onSelected: (value) {
                        setState(() {
                          _tClass = value;
                        });
                      },
                      dropdownMenuEntries: tClasses.entries.map((e) {
                        return DropdownMenuEntry(value: e.key, label: e.value);
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: const Text('To'),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: MultiSelectStations(onChanged: (value) {
                      setState(() {
                        _toStation = value;
                      });
                    }),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              const Row(
                children: [
                  Expanded(child: Text('Enter the number of tickets for each selected station')),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff16c2dc),
                  ),
                  onPressed:  () => createTicket(context) ,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
