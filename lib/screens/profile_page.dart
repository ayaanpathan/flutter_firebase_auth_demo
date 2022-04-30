import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final String imgUrl;

  const ProfilePage({Key? key, required this.user, required this.imgUrl})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSigningOut = false;
  bool _isLoading = true;

  final storageRef = FirebaseStorage.instance.ref();
  late DocumentSnapshot documentSnapshot;
  UserModel user = UserModel(id: '', name: '', email: '', countryCode: '', mobileNumber: '', dob: '');

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  void _getUser() async {
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .get();
    documentSnapshot = data;
    user = UserModel.fromDoc(documentSnapshot);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Container(
              width: double.maxFinite,
              color: Colors.blue.withOpacity(0.35),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CachedNetworkImage(
                  imageUrl: widget.imgUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error, size: 50,),
                ),
              ),
            ),
            _buildTextContainer(title: 'Name', data: user.name),
            _buildTextContainer(title: 'Email', data: user.email),
            _buildTextContainer(title: 'Mobile Number', data: '${user.countryCode} ${user.mobileNumber}'),
            _buildTextContainer(title: 'Date of birth', data: user.dob),
            const Spacer(),
            _isSigningOut
                ? const CircularProgressIndicator()
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        await FirebaseAuth.instance.signOut();
                        setState(() {
                          _isSigningOut = false;
                        });
                        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          ModalRoute.withName('/'),
                        );
                      },
                      child: const Text('Log out'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        minimumSize: const Size(double.maxFinite, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContainer({required String title, required String data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),),
          const SizedBox(height: 2,),
          Container(
            width: double.maxFinite,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                border: Border.all(
                    color: Colors.black
                )
            ),
            child: Center(
              child: Text(
                data,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


