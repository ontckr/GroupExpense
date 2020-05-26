import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_expense/screens/GroupPage.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  var formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  createGroup() async {
    try {
      if (formKey.currentState.validate()) {
        var user = await FirebaseAuth.instance.currentUser();
        var ref = Firestore.instance.collection("groups").document();

        await ref.setData({
          "createdBy": user.uid,
          "name": name.text,
          "users": FieldValue.arrayUnion([
            {
              "displayName": user.displayName,
              "uid": user.uid,
              "photoURL": user.photoUrl
            }
          ]),
          "userIds": FieldValue.arrayUnion([user.uid])
        });

        var group = await ref.get();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return GroupPage(
              group: group,
            );
          }),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white10,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "New Group",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "WorkSansSemiBold",
                fontSize: 24,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.angleLeft,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                style: TextStyle(fontSize: 20, fontFamily: "WorkSansMedium"),
                cursorWidth: 3,
                controller: name,
                validator: (value) =>
                    (value.isEmpty) ? "Please enter a group name" : null,
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 110),
                child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "WorkSansBold",
                      ),
                    ),
                  ),
                  onPressed: () {
                    createGroup();
                  },
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
