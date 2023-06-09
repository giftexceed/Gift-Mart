import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gift_mart/Services/UserServices.dart';

class UpdateProfile extends StatefulWidget {
  static const String id = 'update-profile';
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  User user = FirebaseAuth.instance.currentUser!;
  UserServices _userServices = UserServices();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var phoneNumber = TextEditingController();
  var email = TextEditingController();

  updateProfile() {
    return FirebaseFirestore.instance
        .collection('Ahia Users')
        .doc(user.uid)
        .update({
      'firstName': firstName.text,
      'lastName': lastName.text,
      // 'phoneNumber' : phoneNumber.text,
      'email': email.text,
    });
  }

  @override
  void initState() {
    _userServices.getUserById(user.uid).then((value) {
      if (mounted) {
        setState(() {
          firstName.text = value['firstName'];
          lastName.text = value['lastName'];
          email.text = value['email'];
          phoneNumber.text = user.phoneNumber!;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Update Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomSheet: InkWell(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            EasyLoading.show(status: 'Updating profile...');
            updateProfile().then((value) {
              EasyLoading.showSuccess('Profile Updated Successfully');
              Navigator.pop(context);
            });
          }
        },
        child: Container(
          width: double.infinity,
          height: 56,
          color: Colors.blueGrey[900],
          child: const Center(
              child: Text('Update',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18))),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: firstName,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter First Name ';
                    }
                    return null;
                  },
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: TextFormField(
                  controller: lastName,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Last Name ';
                    }
                    return null;
                  },
                )),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            TextFormField(
              controller: phoneNumber,
              enabled: false,
              decoration: const InputDecoration(
                prefixText: '+234',
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.zero,
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Phone Number';
                }
                return null;
              },
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: TextFormField(
              controller: email,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.zero,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Email Address ';
                }
                return null;
              },
            )),
          ]),
        ),
      ),
    );
  }
}
