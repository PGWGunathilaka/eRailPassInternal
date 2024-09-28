import 'package:erailpass_mobile/common/toast.dart';
import 'package:erailpass_mobile/models/app_response.dart';
import 'package:erailpass_mobile/models/ticket.dart';
import 'package:erailpass_mobile/services/payment_service.dart';
import 'package:erailpass_mobile/widgets/my_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class TicketPayment extends StatefulWidget {
  final Ticket ticket;

  const TicketPayment({super.key, required this.ticket});

  @override
  State<TicketPayment> createState() => _TicketPaymentState();
}

class _TicketPaymentState extends State<TicketPayment> {
  late Ticket _ticket;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
  }


  void checkout() {
    debugPrint("Going to Checkout");
    debugPrint(Stripe.instance.toString());
    Stripe.instance.presentPaymentSheet().then((value) {
      showToast('Payment Successful');
      Navigator.of(context)..pop()..pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyTicket()),
      );
    }).catchError((e) {
      debugPrint('Error1: $e');
      showToast('Error1: $e');
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Payment'),
      ),
      body: Container(
        color: Colors.greenAccent,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => checkout(),
              child: const Center(child: Text("Checkout")),
            )
          ],
        ),
      ),
    );
  }
}
