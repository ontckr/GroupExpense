import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

class _TotalExpenseInfoState extends State<TotalExpenseInfo>
    with SingleTickerProviderStateMixin {
  DocumentSnapshot group;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    group = widget.group;
    _tabController = new TabController(length: 2, vsync: this);
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
              "Total Spend",
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
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                "${widget.totalAmount} ₺",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 32,
                  fontFamily: "WorkSansSemiBold",
                ),
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Container(
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "Balance",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Settle",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 12,
                    ),
                    child: Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "SHOULD PAY",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 18,
                            fontFamily: "WorkSansBold",
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Card(
                          elevation: 6,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                "Agent Smith",
                                style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            trailing: Text(
                              "+ 200 ₺",
                              style: TextStyle(
                                color: Colors.green[600],
                                fontSize: 18,
                                fontFamily: "WorkSansSemiBold",
                              ),
                            ),
                          ),
                        ),
                         Card(
                          elevation: 6,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                "Onat Çakır",
                                style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            trailing: Text(
                              "+ 60 ₺",
                              style: TextStyle(
                                color: Colors.green[600],
                                fontSize: 18,
                                fontFamily: "WorkSansSemiBold",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          "SHOULD BE PAID",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 18,
                            fontFamily: "WorkSansBold",
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Card(
                          elevation: 6,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                "Morpheus",
                                style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            trailing: Text(
                              "- 260 ₺",
                              style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 18,
                                fontFamily: "WorkSansBold",
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 12,
                      ),
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 6,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: ListTile(
                              title: RichText(
                                text: TextSpan(
                                  text: "Morpheus",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 17,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' owes ',
                                      style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        color: Colors.red[400],
                                        fontSize: 18,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Agent Smith',
                                      style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Text(
                                "200 ₺",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 19,
                                  fontFamily: "WorkSansSemiBold",
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 6,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: ListTile(
                              title: RichText(
                                text: TextSpan(
                                  text: "Morpheus",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 17,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' owes ',
                                      style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        color: Colors.red[400],
                                        fontSize: 18,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Onat Çakır',
                                      style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Text(
                                "60 ₺",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 19,
                                  fontFamily: "WorkSansSemiBold",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
