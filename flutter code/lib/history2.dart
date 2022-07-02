import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
  }

  Future<List<Widget>> getArr() async {
    var x = await query("returnarr", []);
    print(x[0][0]);
    List<Widget> widgets = [];
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
    return widgets;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("lib/assets/abi.json");
    String contractAddress = "0x083e809de04c5a2915249f67cd22dcc472b5123a";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "Array"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Widget>>(
        future: getArr(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: snapshot.data!,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
