import 'dart:convert';
import 'dart:math';

import 'package:erailpass_mobile/common/date_util.dart';
import 'package:erailpass_mobile/context/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ticket.dart';

class MyTicket extends StatefulWidget {
  final int? ticketIndex;

  const MyTicket({super.key, this.ticketIndex});

  @override
  State<MyTicket> createState() => _MyTicketState();
}

class _MyTicketState extends State<MyTicket> {
  int _ticketIndex = 0;

  @override
  void initState() {
    super.initState();
    _ticketIndex = widget.ticketIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ticket'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Consumer<TicketModel>(builder: (context, ticketModel, child) {
            List<Ticket> tickets = ticketModel.getAll();
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _ticketIndex = max(0, _ticketIndex - 1);
                              }),
                              child: Icon(
                                Icons.arrow_left,
                                color: _ticketIndex == 0 ? Colors.black12 : Colors.blue,
                                size: 80.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blueGrey, width: 4),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              (_ticketIndex + 1).toString(),
                              style: const TextStyle(fontSize: 52, color: Colors.blueGrey),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _ticketIndex = min(tickets.length - 1, _ticketIndex + 1);
                              }),
                              child: Icon(
                                Icons.arrow_right,
                                color: _ticketIndex == tickets.length - 1 ? Colors.black12 : Colors.blue,
                                size: 80.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: tickets.isNotEmpty,
                    child: tickets.isNotEmpty ? TicketInfo(ticket: tickets[_ticketIndex]) : const SizedBox.shrink(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            border: Border.all(color: Colors.black, width: 4),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              color: Colors.grey,
                              child:
                              Visibility(
                                visible: tickets.isNotEmpty,
                                child: tickets.isNotEmpty ? QrCode(ticket: tickets[_ticketIndex]) : const SizedBox.shrink(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class TicketInfo extends StatelessWidget {
  final Ticket ticket;
  final textStyle = const TextStyle(color: Colors.blueGrey, fontSize: 18);

  const TicketInfo({super.key, required this.ticket});

  void refresh(BuildContext context) async {
    Provider.of<TicketModel>(context, listen:false).getAll(force: true);
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(60),
        1: FlexColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            Text("From", style: textStyle),
            Text(ticket.startStation.name, style: textStyle),
          ],
        ),
        TableRow(
          children: [
            Text("To", style: textStyle),
            Text(ticket.endStation.name, style: textStyle),
          ],
        ),
        TableRow(
          children: [
            Text("Date", style: textStyle),
            Text(dateToString(ticket.date), style: textStyle),
          ],
        ),
        TableRow(
          children: [
            Text("Class", style: textStyle),
            Text(ticket.getTClass(), style: textStyle),
          ],
        ),
        TableRow(
          children: [
            Text("Paid", style: textStyle),
            Row(
              children: [
                Text(
                  ticket.isPaid ? "YES" : "NO",
                  style: TextStyle(
                    fontSize: 18,
                    color: ticket.isPaid ? Colors.green : Colors.redAccent,
                  ),
                ),
                Visibility(
                  visible: !ticket.isPaid,
                  child: IconButton(onPressed: () => refresh(context), icon: const Icon(Icons.refresh)),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}

class QrCode extends StatelessWidget {

  final Ticket ticket;

  const QrCode({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    if(ticket.qrCode!= null) {
      return Image.memory(base64Decode(ticket.qrCode!.split(',').last));
    } else {
      return const SizedBox.shrink();
    }
  }
}
