import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:group_expense/screens/CreateGroup.dart';
import 'package:group_expense/screens/GroupPage.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: SweepGradient(
              colors: [
                Colors.blue,
                Colors.white,
                Colors.blue,
                Colors.white,
                Colors.blue
              ],
              stops: [0.0, 0.25, 0.5, 0.75, 1],
            ),
          ),
          // decoration: BoxDecoration(
          //   gradient: SweepGradient(
          //     colors: [
          //       Colors.white,
          //       Colors.blueAccent,
          //       Colors.white,
          //       Colors.blueAccent,
          //       Colors.white
          //     ],
          //     stops: [0.0, 0.25, 0.5, 0.75, 1],
          //   ),
          // ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 120),
                child: GoogleSignInButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        loading = true;
                      });
                      var user = await signIn();
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
                    } catch (e) {
                      setState(() {
                        loading = false;
                      });
                      print(e);
                    }
                  },
                  darkMode: true,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.headSideMask,
                        size: 32,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "#EvdeKal",
                        style: TextStyle(
                            fontSize: 28, fontFamily: "WorkSansSemiBold"),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  right: 15,
                ),
                child: Icon(FontAwesomeIcons.hooli, size: 45),
              )
            ],
          ),
        ),
      ]),
    );
  }

  Future<FirebaseUser> signIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}
