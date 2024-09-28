import 'package:erailpass_mobile/common/ch_salmonbar.dart';
import 'package:erailpass_mobile/common/sm_salmonbar.dart';
import 'package:erailpass_mobile/context/user_model.dart';
import 'package:erailpass_mobile/homepage.dart';
import 'package:erailpass_mobile/models/user.dart';
import 'package:erailpass_mobile/services/token_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginNavigation extends StatefulWidget {
  const LoginNavigation({super.key});

  @override
  LoginNavigationState createState() => LoginNavigationState();
}

class LoginNavigationState extends State<LoginNavigation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return FutureBuilder(
      future: _loadUser(context),
      builder: (context, snapshot) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<String> _loadUser(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2)).then((value) async {
      TokenHolder tokenHolder = TokenHolder();
      await tokenHolder.init();
      String? token = tokenHolder.getToken();
      if (!context.mounted) return;
      if (token != null) {
        navigateToHome(context);
      } else {
        navigateToLogin(context);
      }
    });
    return "Login Success";
  }

  void navigateToHome(BuildContext context) async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    User? user = await userModel.getUserFromApi();

    if(!context.mounted) return;
    if(user?.role == Role.STATION_MASTER) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const SM_SalmonBar()),
            (Route<dynamic> route) => false,
      );
    } else if(user?.role == Role.CHECKER) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const CH_SalmonBar()),
            (Route<dynamic> route) => false,
      );
    }
  }

  void navigateToLogin(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }
}
