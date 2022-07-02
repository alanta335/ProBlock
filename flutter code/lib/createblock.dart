import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:problock/qrgen.dart';
import 'package:web3dart/web3dart.dart';

class CreBlock extends StatefulWidget {
  const CreBlock({Key? key}) : super(key: key);

  @override
  State<CreBlock> createState() => _CreBlockState();
}

class _CreBlockState extends State<CreBlock> {
  int selectedIndex = 0;
  TextEditingController modelController = TextEditingController();
  TextEditingController nameOfProController = TextEditingController();
  TextEditingController mandateController = TextEditingController();
  TextEditingController serialNoController = TextEditingController();
  var returnedFromProductIndex;
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
    print("\n\n\n\n\n\n\n\nhehehehehe\n\n\n\n\n\n\n\n");
    List<dynamic> result = await query("ProNoRetrieve", []);
    print(result.runtimeType);

    data = true;
    setState(() {
      myData = result[0].toString();
    });
  }

  Future<String> add() async {
    var response =
        await submit("createProduct", ["0", "${nameOfProController.text}"]);
    print("Deposited");
    returnedFromProductIndex = response;
    print("HEHE" + returnedFromProductIndex);
    getCount(myAddress);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 12,
                ),
                Container(
                  child: Text(
                    "Upload your product details",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Container(
                    child: Column(
                      children: [
                        TextField(
                          controller: nameOfProController,
                          decoration: InputDecoration(
                            hintText: 'Enter the name of product',
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextField(
                          controller: modelController,
                          decoration: InputDecoration(
                            hintText: 'Enter the model name',
                            labelText: 'model',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextField(
                          controller: serialNoController,
                          decoration: InputDecoration(
                            hintText: 'Enter the serialnumber',
                            labelText: 'serial no',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    add();
                    getCount(myAddress);
                    cf.FirebaseFirestore.instance
                        .collection('USERS')
                        .doc('${FirebaseAuth.instance.currentUser!.uid}')
                        .collection('Products')
                        .doc('${serialNoController.text}')
                        .set({
                      'user': "p",
                      'name': nameOfProController.text,
                      'location': modelController.text,
                      'manufactured_date': mandateController.text,
                      'serialNo': serialNoController.text,
                      'ownerid': FirebaseAuth.instance.currentUser!.uid,
                      'pindex': myData,
                    });
                    await cf.FirebaseFirestore.instance
                        .collection('Products')
                        .doc('${serialNoController.text}')
                        .set({
                      'user': "p",
                      'name': nameOfProController.text,
                      'location': modelController.text,
                      'manufactured_date': mandateController.text,
                      'serialNo': serialNoController.text,
                      'ownerid': FirebaseAuth.instance.currentUser!.uid,
                      'pindex': myData,
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => QrGen(
                                data:
                                    "${serialNoController.text.toString()}")));
                  },
                  child: Text("Generate QR Code"),
                ),
              ],
            ),
          ),
        ),
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
