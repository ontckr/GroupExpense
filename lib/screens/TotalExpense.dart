import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TotalExpenseInfo extends StatefulWidget {
  final DocumentSnapshot group;
  final double totalAmount;

  const TotalExpenseInfo({Key key, this.group, this.totalAmount})
      : super(key: key);

  @override
  _TotalExpenseInfoState createState() => _TotalExpenseInfoState();
}

class _TotalExpenseInfoState extends State<TotalExpenseInfo> {
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
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0,
            backgroundColor: Colors.white10,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "Total Expense",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "WorkSansSemiBold",
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("${widget.totalAmount}"),
          ],
        ),
      ),
    );
  }
}
