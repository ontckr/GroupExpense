import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_expense/screens/Auth.dart';
import 'package:group_expense/screens/CreateGroup.dart';
import 'package:group_expense/screens/GroupPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkCurrentUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      var result = await Firestore.instance
          .collection("groups")
          .where("userIds", arrayContains: user.uid)
          .getDocuments();

      if (result.documents.isEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return CreateGroup();
          }),
        );
      } else {
        var group = result.documents[0];
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return GroupPage(
              group: group,
            );
          }),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) {
          return Login();
        }),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
