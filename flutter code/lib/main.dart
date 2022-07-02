import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:problock/splash.dart';
import 'firebase_options.dart';
import 'homepage.dart';
import 'signupPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff8954e7),
        primarySwatch: Colors.purple,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("error"),
              );
            } else if (snapshot.hasData) {
              return homePage();
            } else {
              return Signup();
            }
          }),
    );
  }
}

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future<int> googleLogin() async {
    int flag = -1;
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return -1;
      }
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (authResult.additionalUserInfo!.isNewUser) {
        print("This is a new user");
        flag = 1;
      } else {
        print("Already exist");
        flag = 0;
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
    return flag;
  }

  Future loggedout(BuildContext context) async {
    try {
      await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
      notifyListeners();
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
    }
  }
}
