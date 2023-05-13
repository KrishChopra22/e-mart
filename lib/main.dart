import 'package:e_mart/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'auth_screens/login_screen.dart';
import 'dataclass/person.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await checkUser();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Person()),
    ],
    child: MyApp(),
  ));
}

Future<void> checkUser() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final snapshot = await FirebaseDatabase.instance
        .ref('Users/${FirebaseAuth.instance.currentUser!.uid}')
        .get();

    if (!snapshot.exists) {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
          msg: "^_^ You Got Deleted ^_^", toastLength: Toast.LENGTH_LONG);
    }
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          fontFamily: 'Poppins',
        ),
        home: LoginScreen(),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Poppins',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Person>? retrievePersonInfo() async {
    Person person = Provider.of<Person>(context, listen: false);
    await person.retrieveBasicInfo(FirebaseAuth.instance.currentUser!.uid);
    print(person);
    return person;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Person>(
        future: retrievePersonInfo(),
        builder: (BuildContext context, AsyncSnapshot<Person> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Splash Screen
            return const SizedBox(
                child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                    child: CircularProgressIndicator(
                        strokeWidth: 5, color: Colors.indigo)));
          } else if (snapshot.data == null) {
            Fluttertoast.showToast(msg: "User Not Found");
            return LoginScreen();
          }
          return const DashBoard();
        });
  }
}
