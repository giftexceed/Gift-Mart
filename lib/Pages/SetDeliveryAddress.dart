import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../Providers/Auth_Provider.dart';

class SetDeliveryLocation extends StatefulWidget {
  static const String id = 'set-delivery-location';
  @override
  _SetDeliveryLocationState createState() => _SetDeliveryLocationState();
}

class _SetDeliveryLocationState extends State<SetDeliveryLocation> {
  final _formKey = GlobalKey<FormState>();
  var _addressTextController = TextEditingController();
  var _cityTextController = TextEditingController();
  var _stateTextController = TextEditingController();
  String? _address;
  String? _city;
  String? _state;
  bool _loading = false;
  bool _loggedIn = false;
  User? user;

  @override
  void initState() {
    //check user authentication before opening map
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if (user != null) {
      setState(() {
        _loggedIn = true;
        // user = FirebaseAuth.instance.currentUser;
      });
    }
    // else{
    //   _loggedIn = false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        // mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ahia',
                              style: TextStyle(
                                  fontFamily: 'Signatra',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                  color: Theme.of(context).primaryColor)),
                          const SizedBox(height: 20),
                          const Icon(Icons.wallet_giftcard,
                              size: 350, color: Colors.red),
                          const Text('Set your delivery location',
                              style:
                                  TextStyle(fontFamily: 'Anton', fontSize: 20)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text:
                                'Set location where you would like your order delivered',
                            style: TextStyle(color: Colors.black87)),
                      ])),
                      const SizedBox(height: 20),
                      TextFormField(
                          controller: _addressTextController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your delivery address';
                            }

                            setState(() {
                              _addressTextController.text = value;
                            });
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Delivery Address',
                            prefixIcon: const Icon(Icons.location_city),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            focusColor: Theme.of(context).primaryColor,
                          )),
                      TextFormField(
                          controller: _cityTextController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your delivery city';
                            }

                            setState(() {
                              _cityTextController.text = value;
                            });
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Delivery City',
                            prefixIcon: const Icon(Icons.location_city),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            focusColor: Theme.of(context).primaryColor,
                          )),
                      TextFormField(
                          controller: _stateTextController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your delivery state';
                            }

                            setState(() {
                              _stateTextController.text = value;
                            });
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Delivery State',
                            prefixIcon: const Icon(Icons.location_city),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            focusColor: Theme.of(context).primaryColor,
                          )),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  EasyLoading.show(
                                      status: 'Updating Delivery Address...');
                                  _authData.updateDeliveryLocation(
                                    id: user!.uid,
                                    number: user!.phoneNumber!,
                                    address: _addressTextController.text,
                                    city: _cityTextController.text,
                                    state: _stateTextController.text,
                                  );
                                  EasyLoading.dismiss();
                                  // pushNewScreenWithRouteSettings(
                                  //   context,
                                  //   settings:
                                  //       RouteSettings(name: MainScreen.id),
                                  //   screen: MainScreen(),
                                  //   withNavBar: true,
                                  //   pageTransitionAnimation:
                                  //       PageTransitionAnimation.cupertino,
                                  // );
                                  // Navigator.pop(context);
                                }
                              },
                              child: _loading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : const Text('Set delivery location',
                                      style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
