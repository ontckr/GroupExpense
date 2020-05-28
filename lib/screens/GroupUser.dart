import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_expense/screens/AddUser.dart';
import 'package:group_expense/screens/GroupPage.dart';

class GroupUsers extends StatefulWidget {
  final DocumentSnapshot group;

  const GroupUsers({Key key, this.group}) : super(key: key);

  @override
  _GroupUsersState createState() => _GroupUsersState();
}

class _GroupUsersState extends State<GroupUsers> {
  DocumentSnapshot group;

  @override
  void initState() {
    super.initState();
    group = widget.group;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBar(
            leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.angleLeft,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return GroupPage(group: group);
                    },
                  ),
                );
              },
            ),
            elevation: 0,
            backgroundColor: Colors.white10,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "Group Users",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "WorkSansSemiBold",
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          FontAwesomeIcons.userPlus,
          size: 22,
        ),
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          var updatedGroup = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddUser(group: group);
            },
          );
          if (updatedGroup != null) {
            setState(() {
              group = updatedGroup;
            });
          }
        },
      ),
      body: ListView.builder(
        itemCount: group.data["users"].length,
        itemBuilder: (BuildContext context, int index) {
          var user = group.data["users"][index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(user["photoURL"]),
                ),
                title: Text(
                  user["displayName"],
                  style: TextStyle(
                    fontSize: 19,
                    fontFamily: "WorkSansSemiBold",
                  ),
                ),
                trailing: group.data["createdBy"] != user["uid"]
                    ? IconButton(
                        icon: Icon(
                          FontAwesomeIcons.trashAlt,
                          color: Colors.red[200],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                title: Text(
                                  "Do you want to delete?",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontFamily: "WorkSansSemiBold",
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 19,
                                        fontFamily: "WorkSansSemiBold",
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 19,
                                        fontFamily: "WorkSansSemiBold",
                                      ),
                                    ),
                                    onPressed: () async {
                                      await group.reference.updateData({
                                        "users": FieldValue.arrayRemove([
                                          {
                                            "displayName": user["displayName"],
                                            "uid": user["uid"],
                                            "photoURL": user["photoURL"]
                                          }
                                        ]),
                                        "userIds": FieldValue.arrayRemove(
                                            [user["uid"]])
                                      });
                                      group = await group.reference.get();
                                      Navigator.of(context).pop();

                                      setState(() {});
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
