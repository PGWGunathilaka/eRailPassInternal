import 'package:erailpass_mobile/models/ticket.dart';
import 'package:erailpass_mobile/services/ticket_service.dart';
import 'package:flutter/material.dart';

class TicketModel extends ChangeNotifier {
  List<Ticket> _tickets = [];

  List<Ticket> getAll({bool force=false}) {
    if(_tickets.isNotEmpty && !force) {
      return _tickets;
    }
    _getTicketsFromApi().then((data) => {
      debugPrint("tickets received")
    });
    return [];
  }

  Future<List<Ticket>> _getTicketsFromApi() async {
    List<Ticket> tickets = await TicketService.getAll();
    _tickets = tickets;
    notifyListeners();
    return tickets;
  }

  Future<void> addTicket(Ticket ticket) async {
    await TicketService.createTicket(ticket);
    await _getTicketsFromApi();
  }
}
