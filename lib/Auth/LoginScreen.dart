import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/Auth_Provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isValidPhoneNumber = false;
  var _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    // final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: auth.error == 'Invalid OTP' ? true : false,
                    child: Container(
                        child: Column(
                      children: [
                        Text('${auth.error} - Please try again',
                            style: const TextStyle(color: Colors.red)),
                      ],
                    )),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const Text('Enter your phone number to proceed',
                      style: TextStyle(fontSize: 14)),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      prefixText: '+234',
                      labelText: 'Enter your phone number (Eg. +2348030000000)',
                    ),
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    controller: _phoneNumberController,
                    onChanged: (value) {
                      if (value.length == 10) {
                        setState(() {
                          _isValidPhoneNumber = true;
                        });
                      } else {
                        setState(() {
                          _isValidPhoneNumber = false;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: _isValidPhoneNumber ? false : true,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                auth.loading = true;
                                // auth.screen = 'MapScreen';
                                // auth.latitude = locationData.latitude;
                                // auth.longitude = locationData.longitude;
                                // auth.address =
                                //     locationData.selectedAddress.addressLine;
                              });
                              String number =
                                  '+234${_phoneNumberController.text}';
                              auth
                                  .verifyPhoneNumber(
                                      context: context, number: number)
                                  .then((value) {
                                _phoneNumberController.clear();
                                setState(() {
                                  auth.loading = false;
                                });
                                // Navigator.pushReplacementNamed(
                                //     context, HomeScreen.id);
                              });
                            },
                            child: auth.loading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    _isValidPhoneNumber
                                        ? 'Continue'
                                        : 'Enter Phone Number',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
