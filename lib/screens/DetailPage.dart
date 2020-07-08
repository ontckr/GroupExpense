import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_expense/screens/GroupPage.dart';

class ExpenseDetail extends StatefulWidget {
  final DocumentSnapshot group;
  final DocumentSnapshot expense;

  const ExpenseDetail({Key key, this.expense, this.group}) : super(key: key);
  @override
  _ExpenseDetailState createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {
  DocumentSnapshot expense;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expense = widget.expense;
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
              "Expense Detail",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "WorkSansSemiBold",
                fontSize: 24,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.trashAlt,
                    color: Colors.red[400],
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
                                await widget.expense.reference.delete();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return GroupPage(group: widget.group);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      color: Colors.blueAccent,
                      elevation: 6,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                                widget.expense["paidBy"]["photoURL"]),
                          ),
                          title: Text(
                            "${widget.expense["paidBy"]["displayName"]}",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: "WorkSansSemiBold",
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            "Paid By",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                          trailing: Text(
                            "${widget.expense["amount"]} ₺",
                            style: TextStyle(
                              fontSize: 26,
                              fontFamily: "WorkSansSemiBold",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 28,
                      top: 12,
                    ),
                    child: Text(
                      "${widget.expense["name"]}",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      top: 2,
                    ),
                    child: Text(
                      "Description",
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 28,
                      top: 12,
                    ),
                    child: Text(
                      "May 30, 2020",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      top: 2,
                    ),
                    child: Text(
                      "Date",
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 8,
                  right: 8,
                ),
                child: ListView.builder(
                  itemCount: expense.data["paidFor"].length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = expense.data["paidFor"];
                    var user = data[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Card(
                        elevation: 6,
                        color: user["paid"] ? Colors.green : Colors.white,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: ListTile(
                          onTap: () async {
                            String paidBy = expense.data["paidBy"]["uid"];

                            if (paidBy == user["uid"]) {
                              return;
                            }

                            if (user["paid"] == false) {
                              user["paid"] = true;
                              await expense.reference
                                  .updateData({"paidFor": data});
                            } else {
                              user["paid"] = false;

                              await expense.reference
                                  .updateData({"paidFor": data});
                            }
                            expense = await expense.reference.get();
                            setState(() {});
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user["photoURL"]),
                          ),
                          title: Text(
                            user["displayName"],
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "WorkSansSemiBold",
                            ),
                          ),
                          trailing: Text(
                            "${widget.expense["amount"] / widget.expense.data["paidFor"].length} ₺",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: "WorkSansSemiBold",
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
