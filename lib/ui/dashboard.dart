import 'dart:html';

import 'package:flutter/material.dart';

import '../utils.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.all(20),
            child: totalValueLocked(),
            color: Colors.black,
          ),
          flex: 1,
        ),
        Expanded(
          child: Card(
            margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
            child: tableTransactions(),
            color: Colors.black,
          ),
          flex: 2,
        )
      ],
    );
  }

  Widget totalValueLocked() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        Text(
          "ยอดกองมรดกทั้งหมด",
          style: themeText(size: 31),
        ),
        SizedBox(height: 20),
        Text(
          "0 ETH",
          style: themeText(size: 28),
        )
      ],
    );
  }

  Widget tableTransactions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: 20,
        ),
        Text(
          "จำนวนพินัยกรรมในระบบ",
          style: themeText(size: 31),
        ),
        SizedBox(height: 10),
        Text(
          "ตาราง",
          style: themeText(),
        )
      ],
    );
  }


}
