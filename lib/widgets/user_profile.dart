import 'package:erailpass_mobile/context/user_model.dart';
import 'package:erailpass_mobile/homepage.dart';
import 'package:erailpass_mobile/models/user.dart';
import 'package:erailpass_mobile/services/token_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  void navigateToLogin(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 4),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Consumer<UserModel>(builder: (context, userModel, child) {
              User? user = userModel.getUser();
              return Column(
                children: [
                  ProfileAttribute("First Name", user?.firstName ?? ""),
                  ProfileAttribute("Last Name", user?.lastName ?? ""),
                  ProfileAttribute("Email", user?.email ?? ""),
                  Visibility(
                    visible: user?.getRole() != "PASSENGER",
                    child: ProfileAttribute("Approval Status", user?.getApprovalStatus() ?? ""),
                  ),
                ],
              );
            }),
          ),
          Column(
            children: [
              const Divider(color: Colors.black12, thickness: 4),
              SizedBox(
                height: 100,
                child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () {
                      TokenHolder().clearToken();
                      // Add logic to perform user logout
                      navigateToLogin(context);
                    },
                    child: const Text('Logout'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProfileAttribute extends StatelessWidget {
  final String attributeKey;
  final String value;

  const ProfileAttribute(this.attributeKey, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(attributeKey),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
