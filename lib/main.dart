import 'package:erailpass_mobile/context/station_model.dart';
import 'package:erailpass_mobile/context/ticket_model.dart';
import 'package:erailpass_mobile/context/user_model.dart';
import 'package:erailpass_mobile/env.dart';
import 'package:erailpass_mobile/widgets/login_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() {

  Stripe.publishableKey = env['stripePublishableKey'];

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StationModel()),
        ChangeNotifierProvider(create: (context) => TicketModel()),
        ChangeNotifierProvider(create: (context) => UserModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    Provider.of<StationModel>(context, listen: false).getAll();

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginNavigation(),
    );
  }
}
