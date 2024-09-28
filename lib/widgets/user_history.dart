import 'package:erailpass_mobile/common/date_util.dart';
import 'package:erailpass_mobile/context/ticket_model.dart';
import 'package:erailpass_mobile/context/user_model.dart';
import 'package:erailpass_mobile/models/ticket.dart';
import 'package:erailpass_mobile/models/user.dart';
import 'package:erailpass_mobile/widgets/my_ticket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';


class UserHistoryPage extends StatelessWidget {
  const UserHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer<UserModel>(builder: (context, userModel, child) {
              User? user = userModel.getUser();
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '${user?.firstName}\'s previous travels',
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }),
            const SizedBox(height: 20),
            Consumer<TicketModel>(builder: (context, ticketModel, child) {
              List<Ticket> tickets = ticketModel.getAll();
              return Column(
                children: tickets.mapIndexed((i, e) => UserTicketEntry(ticket: e, index: i)).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class UserTicketEntry extends StatelessWidget {
  final Ticket ticket;
  final int index;

  const UserTicketEntry({super.key, required this.ticket, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6, right: 6, bottom: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyTicket(ticketIndex: index)),
          );
        },
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dateToString(ticket.date) ?? "", style: const TextStyle(color: Colors.blueGrey)),
                      ],
                    ),
                    const Expanded(child: Padding(padding: EdgeInsets.only(top: 10))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          ticket.isPaid ? "PAID" : "NOT PAID",
                          style: TextStyle(color: ticket.isPaid ? Colors.green : Colors.redAccent),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ticket.startStation.name ?? "", style: const TextStyle(color: Colors.blueGrey)),
                      ],
                    ),
                    const Expanded(child: Padding(padding: EdgeInsets.only(top: 10))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(ticket.endStation.name ?? "", style: const TextStyle(color: Colors.blueGrey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
