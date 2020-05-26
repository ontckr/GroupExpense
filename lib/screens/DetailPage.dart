import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpenseDetail extends StatefulWidget {
  final DocumentSnapshot expense;

  const ExpenseDetail({Key key, this.expense}) : super(key: key);
  @override
  _ExpenseDetailState createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {
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
                  itemCount: widget.expense.data["paidFor"].length,
                  itemBuilder: (BuildContext context, int index) {
                    var user = widget.expense.data["paidFor"][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Card(
                        elevation: 6,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: ListTile(
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