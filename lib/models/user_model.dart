

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String countryCode;
  final String mobileNumber;
  final String dob;

  UserModel(
      {required this.id,
        required this.name,
        required this.email,
        required this.countryCode,
        required this.mobileNumber,
        required this.dob});

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      name: doc['name'],
      mobileNumber: doc['mobile_number'],
      countryCode: doc['country_code'],
      dob: doc['dob'],
      email: doc['email'],
      id: doc['uid'],
    );
  }
}