import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:problock/createblock.dart';
import 'package:problock/history.dart';
import 'package:problock/profile.dart';
import 'package:problock/qrgen.dart';
import 'package:problock/qrscan.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int selectedIndex = 0;
  var userData;
  Future<cf.DocumentSnapshot>? getUserData() async {
    cf.DocumentSnapshot? user = await cf.FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .get();
    return user;
  }

  late Client httpClient;
  late Web3Client ethClient;
  final myAddress = "0x912e0dc0ba8C442C516537bA3dfd23cb269ABaEc";
  var myData;
  bool data = false;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://polygon-mumbai.g.alchemy.com/v2/ZUFoIfmu_DwOAqHcST4p9L74RPO47LiD",
        httpClient);
    getCount(myAddress);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("lib/assets/abi.json");
    String contractAddress = "0x083e809de04c5a2915249f67cd22dcc472b5123a";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "Array"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<void> getCount(String targetAddress) async {
    EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    var x = 0;

    List<dynamic> result = await query(
        "getValue", [BigInt.parse("0"), BigInt.parse("2"), BigInt.parse("0")]);
    myData = result[0];
    data = true;
    setState(() {});
  }

  Future<String> add() async {
    var response =
        await submit("insertOwner", [BigInt.parse("0"), "0003", "abhi"]);
    print("Deposited");
    return response;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex("private key");
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        chainId: 80001,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  List<Widget> widgets = [];
  Future<void> getArr() async {
    var x = await query("returnarr", []);
    print(x[0][0]);

    for (var i = 0; i < x[0][0].length; i++) {
      widgets.add(new Card(
          child: SizedBox(
        height: 40,
        child: Center(
            child: Column(
          children: [
            Text("Owner ID : " + x[0][0][i][0].toString()),
            Text("Owner Name: " + x[0][0][i][1].toString()),
          ],
        )),
      )));
    }

    print(x[0][0]);
  }

  void gotoScan(userData, context) {
    if (userData['user'] == 'm') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => CreBlock()));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => QrScan()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getUserData(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (selectedIndex == 2) {
                  return HistoryPage();
                }
                return ProfilePage(snapshot.data);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xff8954e7),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner_rounded), label: 'Scan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
          ],
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ));
  }
}
