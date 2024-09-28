import 'package:erailpass_mobile/widgets/train_schedules.dart';
import 'package:erailpass_mobile/widgets/signin.dart';
import 'package:erailpass_mobile/widgets/signup.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        0.5
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
          Container(
            padding: const EdgeInsets.only(top: 25.0),
            child: const AspectRatio(
              aspectRatio: 4.0,
              child: Image(
                  image: AssetImage(
                'images/logo.png',
              )),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                ),
                padding: EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()));
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
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF921023), // Set the text color here
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Do not have account?',
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()),
                              );
                            },
                            child: const Text(
                              'Sign up',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
