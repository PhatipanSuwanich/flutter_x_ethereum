import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';

import 'utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter web X Ethereum'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedAddress;
  Web3Provider web3;
  Future balanceF;
  Future usdcBalanceF;

  @override
  void initState() {
    super.initState();
    if (ethereum != null) {
      web3 = Web3Provider(ethereum);
      print(ethereum.selectedAddress);
      balanceF = promiseToFuture(web3.getBalance(ethereum.selectedAddress));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: connectedStuff(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget connectedStuff() {
    if (ethereum == null) {
      return Text("Dapp Browser not found");
    }
    return Column(
      children: [
        (selectedAddress != null)
            ? Text(selectedAddress)
            : RaisedButton(
                child: Text("Connect Wallet"),
                onPressed: () async {
                  var accounts = await promiseToFuture(ethereum
                      .request(RequestParams(method: 'eth_requestAccounts')));
                  print(accounts);
                  String se = ethereum.selectedAddress;
                  print("selectedAddress: $se");
                  setState(() {
                    selectedAddress = se;
                  });
                },
              ),
        SizedBox(height: 10),
        Text("Native balance:"),
        FutureBuilder(
          future: balanceF,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            var big = BigInt.parse(snapshot.data.toString());
            var d = toDecimal(big, 18);
            return Text("${d}");
          },
        ),
      ],
    );
  }
}
