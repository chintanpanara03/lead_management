import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lead_manage/views/admin/home/index.dart';
import 'package:lead_manage/views/login/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences sharedPrefer = await SharedPreferences.getInstance();
  bool isLoggedIn = false;
  String useremail = sharedPrefer.getString('user_email');
  if (useremail != null) {
    isLoggedIn = true;
  }
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    debugShowCheckedModeBanner: false,
    home: isLoggedIn ? AdminIndex() : MyHomePage(), //MyHomePage(),
  ));
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   User firebaseUser = FirebaseAuth.instance.currentUser;
//   Widget firstWidget;
//   if (firebaseUser != null) {
//   firstWidget = Home();
// } else {
//   firstWidget = LoginScreen();
// }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: firstWidget
//     );
//   }
// }
