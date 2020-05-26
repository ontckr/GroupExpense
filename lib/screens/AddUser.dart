import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  final DocumentSnapshot group;

  const AddUser({Key key, this.group}) : super(key: key);
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController email = TextEditingController();
  final formKey = GlobalKey<FormState>();

  addUser() async {
    try {
      var result = await Firestore.instance
          .collection("users")
          .where("email", isEqualTo: email.text)
          .getDocuments();
      if (result.documents.isEmpty) {
        //TODO:user bulunamadi ekran tasarimi 
        print("User not found");
      } else {
        var user = result.documents[0];
        var groupRef = widget.group.reference;

        await groupRef.updateData({
          "users": FieldValue.arrayUnion([
            {
              "displayName": user["displayName"],
              "uid": user.documentID,
              "photoURL": user["photoURL"]
            }
          ]),
          "userIds": FieldValue.arrayUnion([user.documentID])
        });
        var updatedGroup = await groupRef.get();
        Navigator.of(context).pop(updatedGroup);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Add User",
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter an email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Spacer(),
                    RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blueAccent,
                      child: Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "WorkSansMedium",
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () {
                        addUser();
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
