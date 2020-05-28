import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_expense/screens/DetailPage.dart';

class Expenses extends StatefulWidget {
  final QuerySnapshot expenses;
  final DocumentSnapshot group;

  const Expenses({Key key, this.expenses, this.group}) : super(key: key);
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  QuerySnapshot expenses;

  @override
  void initState() {
    super.initState();
    expenses = widget.expenses;
  }

  @override
  Widget build(BuildContext context) {
    if (expenses == null || expenses.documents.isEmpty) {
      return Text(
        "No expense found!",
        style: TextStyle(
          fontSize: 18,
          fontFamily: "WorkSansSemiBold",
        ),
      );
    } else {
      return ListView.builder(
        itemCount: expenses.documents.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot expense = expenses.documents[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Card(
              elevation: 6,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpenseDetail(
                        expense: expense,
                        group: widget.group,
                      ),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(expense["paidBy"]["photoURL"]),
                ),
                title: Text(
                  expense["name"],
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "WorkSansSemiBold",
                  ),
                ),
                subtitle: Text(
                  expense["paidBy"]["displayName"],
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "WorkSansMedium",
                  ),
                ),
                trailing: Text(
                  expense["amount"].toString() + " ₺",
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: "WorkSansSemiBold",
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
