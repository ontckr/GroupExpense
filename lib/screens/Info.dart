import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_expense/screens/GroupUser.dart';
import 'package:group_expense/screens/TotalExpense.dart';

class Info extends StatefulWidget {
  final DocumentSnapshot group;
  final double totalAmount;
  final List<DocumentSnapshot> expenses;

  const Info({Key key, this.group, this.totalAmount, this.expenses})
      : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  DocumentSnapshot group;

  @override
  void initState() {
    group = widget.group;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
          child: GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return TotalExpenseInfo(
                      group: group,
                      totalAmount: widget.totalAmount,
                      expenses: widget.expenses,
                    );
                  },
                ),
              );
            },
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${widget.totalAmount}₺",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "WorkSansSemiBold",
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Total Spend",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "WorkSansMedium",
                        color: Colors.white.withOpacity(0.9)),
                  )
                ],
              ),
              width: 140,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  bottomLeft: const Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
          child: GestureDetector(
            onTap: () async {
              var updatedGroup = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return GroupUsers(
                      group: group,
                    );
                  },
                ),
              );
              if (updatedGroup != null) {
                setState(() {
                  group = updatedGroup;
                });
              }
            },
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${group.data['users'].length}",
                    style: TextStyle(
                      fontSize: 37,
                      fontFamily: "WorkSansBold",
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Participants",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "WorkSansMedium",
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(20.0),
                  bottomRight: const Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 1.4,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
