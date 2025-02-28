import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_expense/screens/AddExpense.dart';
import 'package:group_expense/screens/DrawerMenu.dart';
import 'package:group_expense/screens/ExpenseList.dart';
import 'package:group_expense/screens/Info.dart';

class GroupPage extends StatefulWidget {
  final DocumentSnapshot group;

  const GroupPage({Key key, this.group}) : super(key: key);
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage>
    with SingleTickerProviderStateMixin {
  Future<QuerySnapshot> future;
  DocumentSnapshot group;

  getGroupExpenses() {
    future = Firestore.instance
        .collection("groups")
        .document(widget.group.documentID)
        .collection("expenses")
        .getDocuments();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    group = widget.group;
    getGroupExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
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
              group["name"],
              style: TextStyle(
                color: Colors.black,
                fontFamily: "WorkSansSemiBold",
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("groups")
            .document(widget.group.documentID)
            .collection("expenses")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              print("heheh update");
              double totalAmount = 0;
              List<DocumentSnapshot> expenses = [];
              snapshot.data.documents.forEach((element) {
                totalAmount += element.data["amount"];
                expenses.add(element);
              });
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Info(
                      group: group,
                      totalAmount: totalAmount,
                      expenses: expenses,
                    ),
                    flex: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: Expenses(
                      expenses: expenses,
                      group: group,
                    ),
                  ),
                ],
              );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Expense",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.liraSign,
          size: 19,
        ),
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return AddExpense(
                  group: group,
                );
              },
            ),
          );
          getGroupExpenses();
        },
      ),
    );
  }
}
