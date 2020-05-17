import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: MainScreen()),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              backgroundColor: Colors.blue,
              expandedHeight: 200.0,
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Sidebar()),
                  );
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.person_add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Users(),
                      ),
                    );
                  },
                )
              ],
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    color: Colors.blue,
                    child: Center(
                        child: Text(
                      "₺ 1000",
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    )),
                  )),
            ),
          ];
        },
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 0.9],
                colors: [
                  Color.fromRGBO(62, 72, 108, 1),
                  Color.fromRGBO(62, 72, 108, 0.95),
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[],
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 15, 15, 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white.withAlpha(20)),
                        height: 80.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Antalya Tatili",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(),
                                Text("TRY, 1000",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white))
                              ],
                            ),
                            Container(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Onat Çakır",
                                  style: TextStyle(color: Colors.white54),
                                ),
                                Spacer(),
                                Text(
                                  "date",
                                  style: TextStyle(color: Colors.white54),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                    // return Text(repository['name']);
                  },
                )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context1) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                title: Text("Add Expense"),
                content: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: "Expense"),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Price",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: RaisedButton(
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.black,
                            onPressed: () {},
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        icon: Icon(Icons.add),
        label: Text("Expense"),
      ),
    );
  }
}

class Users extends StatelessWidget {
  final Group group;
  final TextEditingController userId = new TextEditingController();

  Users({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Users"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context1) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      title: Text("Invite User"),
                      content: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: userId,
                              decoration: InputDecoration(labelText: "User Id"),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: RaisedButton(
                                  elevation: 7,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.black,
                                  onPressed: () async {},
                                  child: Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return RaisedButton(
              child: Text("Onat"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen(),
                  ),
                );
              },
            );
          },
        ));
  }
}

class Sidebar extends StatelessWidget {
  final TextEditingController groupName = new TextEditingController();
  final TextEditingController groupDescription = new TextEditingController();
  final TextEditingController groupCurrency = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Groups"), actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context1) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      title: Text("New Group"),
                      content: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: groupName,
                              decoration: InputDecoration(labelText: "Name"),
                            ),
                            TextField(
                              controller: groupDescription,
                              decoration: InputDecoration(
                                labelText: "Description",
                              ),
                            ),
                            TextField(
                              controller: groupCurrency,
                              decoration: InputDecoration(
                                labelText: "Currency",
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: RaisedButton(
                                  elevation: 7,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.black,
                                  onPressed: () async {},
                                  child: Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          )
        ]),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return RaisedButton(
              child: Text("Antalya Tatili"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen(),
                  ),
                );
              },
            );
          },
        ));
  }
}
 class Group {
  final String id;
  final String name;

  Group({this.id, this.name});
}


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn = new GoogleSignIn();

//   Future<FirebaseUser> _signIn() async {
//     GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

//     GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//       accessToken: gSA.accessToken,
//       idToken: gSA.idToken,
//     );

//     FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

//     print("User Name: ${user.displayName}");
//     return user;
//   }

//   void _signOut() {
//     googleSignIn.signOut();
//     print("User Signed out");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Google-Sign-In"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(28.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             RaisedButton(
//               child: Text("Sign In"),
//               onPressed: () => _signIn()
//                   .then((FirebaseUser user) => print(user))
//                   .catchError((e) => print(e)),
//               color: Colors.green,
//             ),
//             RaisedButton(
//               child: Text("Sign Out"),
//               onPressed: () => _signOut(),
//               color: Colors.red,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
