import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_expense/screens/CreateGroup.dart';
import 'package:group_expense/screens/GroupPage.dart';
import 'package:group_expense/screens/SplashScreen.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key key}) : super(key: key);
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  Future<QuerySnapshot> getGroups() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) {
      return null;
    }
    return Firestore.instance
        .collection("groups")
        .where("userIds", arrayContains: firebaseUser.uid)
        .getDocuments();
  }

  FirebaseUser firebaseUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: getGroups(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Error'));
              } else {
                return SafeArea(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.users),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "New Group",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "WorkSansMedium",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return CreateGroup();
                                    }),
                                  );
                                },
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              var group = snapshot.data.documents[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 3),
                                child: Card(
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  elevation: 3,
                                  shadowColor: Colors.black,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: ListTile(
                                      title: Text(
                                        group.data["name"],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "WorkSansMedium",
                                        ),
                                      ),
                                      trailing: group.data["createdBy"] ==
                                              firebaseUser.uid
                                          ? IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.trashAlt,
                                                color: Colors.red[200],
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(15),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        "Do you want to delete?",
                                                        style: TextStyle(
                                                          fontSize: 19,
                                                          fontFamily:
                                                              "WorkSansSemiBold",
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .blueAccent,
                                                              fontSize: 19,
                                                              fontFamily:
                                                                  "WorkSansSemiBold",
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 19,
                                                              fontFamily:
                                                                  "WorkSansSemiBold",
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            await group
                                                                .reference
                                                                .delete();
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                                    MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return SplashScreen();
                                                              },
                                                            ));
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          : null,
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return GroupPage(group: group);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8,
                                        right: 18,
                                        left: 50,
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(firebaseUser.photoUrl),
                                        radius: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 5,
                                      ),
                                      child: Text(
                                        firebaseUser.displayName,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "WorkSansMedium",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 80,
                                    right: 95,
                                    bottom: 6,
                                  ),
                                  child: RaisedButton(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.signOutAlt,
                                          size: 17,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Sign out",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "WorkSansMedium",
                                            ),
                                          ),
                                        ),
                                      ],
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
                                              "Sign Out",
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontFamily: "WorkSansSemiBold",
                                              ),
                                            ),
                                            content: Text(
                                              "Are you sure want to sign out?",
                                              style: TextStyle(
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
                                                    fontFamily:
                                                        "WorkSansSemiBold",
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                color: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(15),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19,
                                                    fontFamily:
                                                        "WorkSansSemiBold",
                                                  ),
                                                ),
                                                onPressed: () {
                                                  FirebaseAuth.instance
                                                      .signOut();
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                      return SplashScreen();
                                                    }),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.0),
                                      side: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
