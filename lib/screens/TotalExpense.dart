import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_expense/Payment.dart';

class TotalExpenseInfo extends StatefulWidget {
  final DocumentSnapshot group;
  final List<DocumentSnapshot> expenses;
  final double totalAmount;

  const TotalExpenseInfo({Key key, this.group, this.totalAmount, this.expenses})
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
    calculateBalance();
  }

  List<Payment> settlements = [];
  Map<String, double> balance = {};

  Map<String, double> balancePositive = {};
  Map<String, double> balanceNegative = {};

  void calculateBalance() {
    List<DocumentSnapshot> expenses = widget.expenses;
    List uids = widget.group.data["userIds"];
    List<Payment> payments = [];

    uids.forEach((uid) {
      balance[uid] = 0;
    });

    for (var expense in expenses) {
      String paidBy = expense.data["paidBy"]["uid"];
      String paidByName = expense.data["paidBy"]["displayName"];

      double totalAmount = expense.data["amount"].toDouble();
      List paidFor = expense.data["paidFor"];
      double individualAmount = totalAmount / paidFor.length;
      double amountToSubtract = 0;

      bool found = false;
      for (var user in paidFor) {
        if (user["paid"]) {
          amountToSubtract+= individualAmount;
          continue;
        }
        var uid = user["uid"];
        if (uid == paidBy) {
          found = true;
        } else {
          balance[uid] -= individualAmount;
          var payment = Payment(user["displayName"], user["uid"], paidByName,
              paidBy, individualAmount);
          payments.add(payment);
        }
      }

      if (found) {
        balance[paidBy] += totalAmount - individualAmount - amountToSubtract;
      } else {
        balance[paidBy] += totalAmount -amountToSubtract;
      }
    }

    balance.forEach((key, value) {
      String uid = key;
      List users = group.data["users"];
      var user = users.firstWhere(
        (element) => element["uid"] == uid,
        orElse: () => "",
      );

      String displayName = user["displayName"];

      if (value > 0) {
        balancePositive[displayName] = value;
      } else if (value < 0) {
        balanceNegative[displayName] = value;
      }
    });

    print(balance);

    List<Payment> finalDebts = [];

    for (var uid in uids) {
      List<Payment> debts =
          payments.where((element) => element.fromId == uid).toList();

      for (var debt in debts) {
        var index = finalDebts.indexWhere((element) =>
            (element.fromId == debt.fromId && element.toId == debt.toId));
        if (index == -1) {
          Payment finalDebt = Payment(debt.fromName, debt.fromId, debt.toName,
              debt.toId, (debt.amount));
          finalDebts.add(finalDebt);
        } else {
          Payment newDebt = Payment(debt.fromName, debt.fromId, debt.toName,
              debt.toId, finalDebts[index].amount + (debt.amount));
          finalDebts.removeAt(index);
          finalDebts.add(newDebt);
        }
      }
    }

    for (var i = 0; i < finalDebts.length; i++) {
      var fd = finalDebts[i];

      var index = finalDebts.indexWhere(
          (element) => element.fromId == fd.toId && element.toId == fd.fromId);
      if (index != -1) {
        var indexObject = finalDebts[index];

        if (indexObject.amount >= fd.amount) {
          var payment = Payment(
              indexObject.fromName,
              indexObject.fromId,
              indexObject.toName,
              indexObject.toId,
              (indexObject.amount - fd.amount));
          finalDebts.removeAt(index);
          settlements.add(payment);
        } else {
          var payment = Payment(fd.fromName, fd.fromId, fd.toName, fd.toId,
              (fd.amount - indexObject.amount));
          finalDebts.removeAt(index);
          settlements.add(payment);
        }
      } else {
        var payment =
            Payment(fd.fromName, fd.fromId, fd.toName, fd.toId, fd.amount);

        settlements.add(payment);
      }
    }
    print("-----------------------");

    for (var settlement in settlements) {
      print(settlement.fromName +
          " will pay " +
          settlement.toName +
          settlement.amount.toString());
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
                        child: SingleChildScrollView(
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
                          Column(
                            children: balanceNegative.keys.map((key) {
                              return Card(
                                elevation: 6,
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      key,
                                      style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  trailing: Text(
                                    "${balanceNegative[key]} ₺",
                                    style: TextStyle(
                                      color: Colors.red[600],
                                      fontSize: 18,
                                      fontFamily: "WorkSansBold",
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
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
                          Column(
                            children: balancePositive.keys.map((key) {
                              return Card(
                                elevation: 6,
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      key,
                                      style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  trailing: Text(
                                    "${balancePositive[key]} ₺",
                                    style: TextStyle(
                                      color: Colors.green[600],
                                      fontSize: 18,
                                      fontFamily: "WorkSansBold",
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )),
                  ),
                  Container(
                    child: ListView.builder(
                        itemCount: settlements.length,
                        itemBuilder: (BuildContext context, int index) {
                          var s = settlements[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
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
                                        text: s.fromName,
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
                                            text: s.toName,
                                            style: TextStyle(
                                              fontFamily: "WorkSansSemiBold",
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Text(
                                      s.amount.toString() + "₺",
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
                          );
                        }),
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
