import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:flutter_x_ethereum/ui/dashboard.dart';

import 'utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter web X Ethereum',
      home: MyHomePage(),
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

  @override
  void initState() {
    super.initState();
    if (ethereum != null) {
      web3 = Web3Provider(ethereum);
      selectedAddress = ethereum.selectedAddress;
      balanceF = promiseToFuture(web3.getBalance(ethereum.selectedAddress));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Last Wills and Testament"),
        actions: [
          (selectedAddress != null)
              ? wallet(selectedAddress)
              : wallet("connect", onclick: () async {
                  await promiseToFuture(ethereum
                      .request(RequestParams(method: 'eth_requestAccounts')));
                  setState(() {
                    selectedAddress = ethereum.selectedAddress;
                    balanceF = promiseToFuture(
                        web3.getBalance(ethereum.selectedAddress));
                  });
                }),
          SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              width: 100,
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              width: 100,
              child: Dashboard(),
            ),
            flex: 2,
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget connectedStuff() {
    if (ethereum == null) {
      return Text("Dapp Browser not found");
    }
    return Column(
      children: [
        SizedBox(height: 10),
        Text("Native balance:"),
        FutureBuilder(
          future: balanceF,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Connect wallet");
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

  Widget wallet(String titile, {Function onclick}) => TextButton.icon(
        onPressed: onclick,
        icon: Icon(
          Icons.account_balance_wallet,
          color: Colors.white,
        ),
        label: SizedBox(
          width: 100,
          child: Text(
            titile,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: themeText(),
          ),
        ),
      );
}
