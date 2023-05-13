import 'package:e_mart/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'auth_screens/login_screen.dart';
import 'dataclass/person.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await checkUser();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserPerson()),
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
  Future<UserPerson>? retrievePersonInfo() async {
    UserPerson person = Provider.of<UserPerson>(context, listen: false);
    await person.retrieveBasicInfo(FirebaseAuth.instance.currentUser!.uid);
    print(person);
    return person;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserPerson>(
        future: retrievePersonInfo(),
        builder: (BuildContext context, AsyncSnapshot<UserPerson> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Splash Screen
            return const SizedBox(
                width: 60,
                height: 60,
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
