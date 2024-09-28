import 'package:erailpass_mobile/common/ch_salmonbar.dart';
import 'package:erailpass_mobile/common/sm_salmonbar.dart';
import 'package:erailpass_mobile/common/textbox.dart';
import 'package:erailpass_mobile/common/toast.dart';
import 'package:erailpass_mobile/context/user_model.dart';
import 'package:erailpass_mobile/widgets/login_navigation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  static const String _title = 'Log-in';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? _mobileNumber;
  String? _password;
  // final bool _showError = false; // Initialize _showError to false

  void handleLoginButtonPressed(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validate credentials
    if (email.isNotEmpty && password.isNotEmpty) {
      UserModel userModel = Provider.of<UserModel>(context, listen: false);
      bool success = await userModel.login(email, _password!);
      if (success) {
        if (!context.mounted) return;
        navigateToHome(context);
      } else {
        showInvalidCredentialsDialog();
      }
    } else {
      showToast("Please fill in all fields");
    }
  }

  void navigateToHome(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const LoginNavigation()),
          (Route<dynamic> route) => false,
    );
  }

  void showInvalidCredentialsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text.rich(
            TextSpan(
                text:  "Invalid Credentials",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.red)),
           ),
        content: const Text.rich(
            TextSpan(
                text: "Please check your email and password.",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.red)),
            ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: SignIn._title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(SignIn._title),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Stack(
          children: [
            ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(1.0),
                          Colors.black.withOpacity(0.0)
                        ],
                        stops: const [
                          0.1,
                          0.4
                        ]).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      'images/Background.jpg',
                      fit: BoxFit.cover,
                      // width: double.infinity,
                    ),
                  ),
                )),
            const AspectRatio(
                          aspectRatio: 5.0,
                          child: Image(
              image: AssetImage(
            'images/logo.png',
                          )),
                        ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  padding:
                      const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
                  child: Column(
                    children: [
                      TextBoxWidget(
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        onChanged: (String val) {
                          setState(() {
                            _mobileNumber = val;
                          });
                        },
                      ),
                      TextBoxWidget(
                        label: 'Password',
                        hiddenText: true,
                        controller: passwordController,
                        onChanged: (String val) {
                          setState(() {
                            _password = val;
                          });
                        },
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff16c2dc),
                          ),
                            onPressed: () => handleLoginButtonPressed(context),
                          child: const Text('Submit'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Forgot password?',
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Reset password',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
