import 'package:flutter/material.dart';
import 'package:gift_mart/Pages/SetDeliveryAddress.dart';
import 'package:provider/provider.dart';

import '../Providers/Auth_Provider.dart';
import 'OnBoardScreen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _isValidPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter myState) {
          return Container(
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
                        labelText:
                            'Enter your phone number (Eg. +2348030000000)',
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      controller: _phoneNumberController,
                      onChanged: (value) {
                        if (value.length == 10) {
                          myState(() {
                            _isValidPhoneNumber = true;
                          });
                        } else {
                          myState(() {
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
                            child: TextButton(
                              onPressed: () {
                                myState(() {
                                  auth.loading = true;
                                });
                                String number =
                                    '+234${_phoneNumberController.text}';
                                auth
                                    .verifyPhoneNumber(
                                  context: context,
                                  number: number,
                                )
                                    .then((value) {
                                  _phoneNumberController.clear();
                                  auth.loading = false;
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
          );
        }),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    // final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(children: [
          Positioned(
              right: 0.0,
              top: 10.0,
              child: TextButton(
                child: Text(
                  'Skip',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20),
                ),
                onPressed: () {},
              )),
          Column(children: [
            Expanded(child: OnBoardScreen()),
            const Text(
              'Start ordering from shops around you today',
            ),
            const SizedBox(height: 20),
            TextButton(
              child: const Text('Set Delivery Location',
                  style: TextStyle(color: Colors.white)),
              onPressed: () async {
                Navigator.pushNamed(context, SetDeliveryLocation.id);
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              child: RichText(
                text: TextSpan(
                    text: 'Already a customer? ',
                    style: const TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                          text: ' Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor))
                    ]),
              ),
              onPressed: () {
                setState(() {
                  auth.screen = 'Login';
                });
                showBottomSheet(context);
              },
            )
          ]),
        ]),
      ),
    );
  }
}
