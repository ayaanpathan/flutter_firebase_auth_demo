import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/fire_auth.dart';
import '../utils/validator.dart';
import 'bottom_nav_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _countryCodeTextController = TextEditingController();
  final _mobileNumberTextController = TextEditingController();
  final _dobTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusMobileNumber = FocusNode();
  final _focusDOB = FocusNode();

  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    _countryCodeTextController.text = '91';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
        _focusMobileNumber.unfocus();
        _focusDOB.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                image == null
                    ? Material(
                        color: Colors.blue,
                        child: InkWell(
                          onTap: () async {
                            image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {});
                          },
                          child: const SizedBox(
                            height: 100,
                            width: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {});
                        },
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.file(File(image!.path),
                              fit: BoxFit.fill, height: 100, width: 100),
                        ),
                      ),
                const SizedBox(
                  height: 25,
                ),
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameTextController,
                        focusNode: _focusName,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Name",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Email",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        obscureText: true,
                        validator: (value) => Validator.validatePassword(
                          password: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Password",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 60,
                            child: TextButton(
                              onPressed: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: true,
                                  showWorldWide: false,
                                  onSelect: (Country country) {
                                    _countryCodeTextController.text =
                                        country.phoneCode;
                                    setState(() {});
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                              ),
                              child: Text(
                                '+${_countryCodeTextController.text}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _mobileNumberTextController,
                              focusNode: _focusMobileNumber,
                              validator: (value) =>
                                  Validator.validateMobileNumber(
                                mobileNumber: value,
                              ),
                              decoration: InputDecoration(
                                hintText: "Mobile Number",
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _dobTextController,
                        focusNode: _focusDOB,
                        readOnly: true,
                        onTap: () async {
                          final currentDate = DateTime.now();
                          final endDate = DateTime(
                              currentDate.year - 18,
                              currentDate.month,
                              currentDate.day,
                              currentDate.hour,
                              currentDate.minute);
                          final date = await showDatePicker(context: context, initialDate: currentDate, firstDate: endDate, lastDate: DateTime.now());
                          if(date != null) {
                            setState(() {
                              _dobTextController.text = '${date.day}/${date.month}/${date.year}';
                            });
                          }
                        },
                        validator: (value) =>
                            Validator.validateDate(
                              date: value,
                            ),
                        decoration: InputDecoration(
                          hintText: "Date of birth",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      _isProcessing
                          ? const CircularProgressIndicator()
                          : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_registerFormKey.currentState!
                                          .validate()) {
                                        if (image == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Please select an Image'),
                                          ));
                                          return;
                                        }
                                        setState(() {
                                          _isProcessing = true;
                                        });
                                        _register();
                                      }
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    User? user = await FireAuth
        .registerUsingEmailPassword(
      name: _nameTextController.text,
      email: _emailTextController.text,
      password: _passwordTextController.text,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .set({
      'name': _nameTextController.text,
      'uid': user?.uid,
      'email': _emailTextController.text,
      'dob': _dobTextController.text,
      'country_code': '+${_countryCodeTextController.text}',
      'mobile_number': _mobileNumberTextController.text
    });

    final storageRef =
    FirebaseStorage.instance.ref();
    String filePath = image!.path;
    File file = File(filePath);
    final mountainsRef =
    storageRef.child(user!.uid);
    try {
      await mountainsRef.putFile(file);
    } on FirebaseException catch (e) {
      // ...
    }

    final imageUrl = await storageRef
        .child(user.uid)
        .getDownloadURL();

    setState(() {
      _isProcessing = false;
    });

    if (user != null) {
      Navigator.of(context, rootNavigator: true)
          .pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => BottomNavBar(
            user: user,
            imgUrl: imageUrl,
          ),
        ),
        ModalRoute.withName('/'),
      );
    }
  }
}
