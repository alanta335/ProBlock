import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:problock/history.dart';
import 'package:problock/homepage.dart';
import 'package:web3dart/web3dart.dart';

class addOwner extends StatefulWidget {
  final data;
  var sno;
  addOwner(this.sno, {@required this.data});

  @override
  State<addOwner> createState() => _addOwnerState(d: data);
}

class _addOwnerState extends State<addOwner> {
  cf.DocumentSnapshot? user;
  final d;

  _addOwnerState({@required this.d});
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
    List<dynamic> result = await query("ownerNoRetrieve", [BigInt.parse(d)]);
    print(result.runtimeType);

    data = true;
    setState(() {
      myData = result[0].toString();
    });
    print(myData);
  }

  Future<String> add(var r) async {
    user = await cf.FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .get();
    print(user!["name"]);
    cf.FirebaseFirestore.instance
        .collection('USERS')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection("devices")
        .doc()
        .set({
      "serial_no": "${r}",
      "timestamp": DateTime.now().millisecondsSinceEpoch
    });

    var response = await submit("insertOwner", [
      BigInt.parse(d),
      "${FirebaseAuth.instance.currentUser!.uid}",
      "${user!["name"]}"
    ]);
    print("Deposited");
    getCount(myAddress);
    return response;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(
        "private key");
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

  @override
  Widget build(BuildContext context) {
    var r = widget.sno;
    return Scaffold(
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                add(r);
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => homePage()));
              },
              child: Text("Do you want to add to block?")),
        ));
  }
}
