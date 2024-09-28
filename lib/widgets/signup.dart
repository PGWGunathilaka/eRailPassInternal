import 'package:erailpass_mobile/common/ch_salmonbar.dart';
import 'package:erailpass_mobile/common/sm_salmonbar.dart';
import 'package:erailpass_mobile/common/stations_dropdown.dart';
import 'package:erailpass_mobile/common/textbox.dart';
import 'package:erailpass_mobile/context/user_model.dart';
import 'package:erailpass_mobile/models/station.dart';
import 'package:erailpass_mobile/models/user.dart';
import 'package:erailpass_mobile/widgets/login_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
 
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign-up'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: const SingleChildScrollView(child: MyStatefulWidget()),
    );
  }
}


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  // final List<String> _genderList = ['Rev', 'Mr', 'Mrs', 'Miss'];
  String? _title;
  String _firstName = "";
  String? _lastName;
  String? _mobileNumber;
  String? _email;
  String? _password;
  String? _role;
  String? _reEnterPassword;

  set _Station(Station? _Station) {}

  bool _allFieldsFilled() {
    return _firstName.isNotEmpty &&
        _mobileNumber != null &&
        _title != null &&
        _password != null &&
        _email != null &&
        _role != null &&
        passwordController.text == reEnterPasswordController.text;
  }

  Future<void> registerUser(BuildContext context) async {
    int role = User.getRoleNumberFromString(_role!);
    int approvalStatus = User.getApprovalStatusNumberFromString("PENDING");

    User user = User(
      title: _title,
      firstName: _firstName,
      lastName: _lastName,
      email: _email!,
      role: role,
      approvalStatus: approvalStatus,
    );
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    bool success = await userModel.register(user, _password!);
    if (success) {
      if (!context.mounted) return;
      navigateToHome(context);
    }
  }

  void navigateToHome(BuildContext context) async {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const LoginNavigation()),
            (Route<dynamic> route) => false,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:0, right: 10, left: 10, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const AspectRatio(
            aspectRatio: 5.0,
            child: Image(
                image: AssetImage(
                  'images/logo.png',
                )),
          ),
          Row(
            children: <Widget>[
              Container(
                  width: 80,
                  padding: const EdgeInsets.only(right: 10.0),
                  child: const Text('Title')),
              DropdownButton<String>(
                value: _title,
                icon: const Icon(Icons.arrow_drop_down),
                hint: const Text('Select'),
                items: const [
                  DropdownMenuItem(value: 'Rev', child: Text('Rev')),
                  DropdownMenuItem(value: 'Mr', child: Text('Mr')),
                  DropdownMenuItem(value: 'Mrs', child: Text('Mrs')),
                  DropdownMenuItem(value: 'Miss', child: Text('Miss')),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _title = newValue;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          TextBoxWidget(
            label: 'First Name',
            labelText: 'Type your first name here',
            onChanged: (String val) {
              setState(() {
                _firstName = val;
              });
            },
          ),
          TextBoxWidget(
            label: 'Last Name',
            labelText: 'Type your last name here',
            onChanged: (String val) {
              setState(() {
                _lastName = val;
              });
            },
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  padding: const EdgeInsets.only(right: 18),
                  child: const Text('Station'),
                ),
              ),
              Flexible(
                flex: 4,
                child: StationDropDown(onChanged: (value) {
                  setState(() {
                    _Station = value;
                  });
                }),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextBoxWidget(
            label: 'E-Mail',
            labelText: 'Type the correct email address here',
            keyboardType: TextInputType.emailAddress,
            onChanged: (String val) {
              setState(() {
                _email = val;
              });
            },
          ),
          TextBoxWidget(
            label: 'Mobile No.',
            labelText: 'Type the correct 10-digit mobile number',
            keyboardType: TextInputType.phone,
            onChanged: (String val) {
              setState(() {
                _mobileNumber = val;
              });
            },
            validator: (val) {
              if (val?.length == 10) {
                return null;
              } else {
                return "Enter the correct 10-digit phone number.";
              }
            },
          ),
          Row(
            children: <Widget>[
              Container(
                  width: 80,
                  padding: const EdgeInsets.only(right: 10.0),
                  child: const Text('Role')),
              DropdownButton<String>(
                value: _role,
                icon: const Icon(Icons.verified_user_outlined),
                hint: const Text('Select'),
                items: const [
                  DropdownMenuItem(value: 'STATION MASTER', child: Text('STATION MASTER')),
                  DropdownMenuItem(value: 'CHECKER', child: Text('CHECKER')),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _role = newValue;
                    });
                  }
                },
              ),
            ],
          ),
          TextBoxWidget(
            label: 'Password',
            hiddenText: true,
            labelText: 'Create a strong password',
            controller: passwordController,
            onChanged: (String val) {
              setState(() {
                _password = val;
              });
            },
          ),
          TextBoxWidget(
            label: 'Re-Enter Password',
            hiddenText: true,
            labelText: 'Re-enter the password correctly',
            controller: reEnterPasswordController,
            onChanged: (String val) {
              setState(() {
                _reEnterPassword =val;
              });
            },
            validator: (val){
              if(_password!=null &&_password==val){
                return null;
              }
              return "Passwords do not match";
            },
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent[700],
              ),
              onPressed: _allFieldsFilled()
                  ? () {
                      if (passwordController.text ==
                          reEnterPasswordController.text) {
                        debugPrint(nameController.text);
                        debugPrint(passwordController.text);
                        registerUser(context);
                      } else {
                        debugPrint("Password does not matched");
                      }
                      // perform login validation and authentication
                    }
                  : null,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }


}
