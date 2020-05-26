import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddExpense extends StatefulWidget {
  final DocumentSnapshot group;

  const AddExpense({Key key, this.group}) : super(key: key);
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  var formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController amount = TextEditingController();

  List paidFor = [];

  addExpense() async {
    if (formKey.currentState.validate()) {
      try {
        var user = await FirebaseAuth.instance.currentUser();

        await widget.group.reference.collection("expenses").add(
          {
            "name": name.text,
            "amount": int.parse(amount.text),
            "paidBy": {
              "uid": user.uid,
              "displayName": user.displayName,
              "photoURL": user.photoUrl
            },
            "paidFor": paidFor
          },
        );

        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
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
            leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.angleLeft,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0,
            backgroundColor: Colors.white10,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "Add Expense",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "WorkSansSemiBold",
                fontSize: 24,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.check,
                  color: Colors.black,
                  size: 26,
                ),
                onPressed: () {addExpense();},
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                style: TextStyle(fontSize: 18, fontFamily: "WorkSansMedium"),
                cursorWidth: 3,
                controller: name,
                validator: (value) =>
                    (value.isEmpty) ? "Please enter an expense name" : null,
                decoration: InputDecoration(
                  labelText: 'Explanation',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                style: TextStyle(fontSize: 18, fontFamily: "WorkSansMedium"),
                cursorWidth: 3,
                controller: amount,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value.isEmpty) ? "Please enter an amount" : null,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Paid For",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "WorkSansSemiBold",
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.group.data["users"].length,
                  itemBuilder: (BuildContext context, int index) {
                    var user = widget.group.data["users"][index];

                    var listUser = paidFor.firstWhere(
                      (element) => element["uid"] == user["uid"],
                      orElse: () {
                        return null;
                      },
                    );

                    bool contains = false;

                    if (listUser != null) {
                      contains = true;
                    }

                    return Card(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      color: contains ? Colors.blueAccent : Colors.white,
                      elevation: 3,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user["photoURL"]),
                          ),
                          title: Text(
                            user["displayName"],
                            style: TextStyle(
                              color: contains ? Colors.white : Colors.black,
                              fontSize: 20,
                              fontFamily: "WorkSansSemiBold",
                            ),
                          ),
                          selected: contains,
                          onTap: () {
                            if (contains) {
                              paidFor.remove(listUser);
                            } else {
                              paidFor.add({
                                "uid": user["uid"],
                                "displayName": user["displayName"],
                                "photoURL": user["photoURL"]
                              });
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton.extended(
      //   icon: Icon(
      //     FontAwesomeIcons.plus,
      //     size: 19,
      //   ),
      //   backgroundColor: Colors.blueAccent,
      //   label: Text(
      //     "Add",
      //     style: TextStyle(
      //       fontSize: 18,
      //     ),
      //   ),
      //   onPressed: () {
      //     addExpense();
      //   },
      // ),
    );
  }
}
