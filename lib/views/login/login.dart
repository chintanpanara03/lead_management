import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lead_manage/common/backbutton/back_button.dart';
import 'package:lead_manage/common/connectivity/internet_status.dart';
import 'package:lead_manage/common/widget/common.dart';
import 'package:lead_manage/views/admin/home/index.dart';
import 'package:lead_manage/views/login/forgot_password.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lead_manage/views/login/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    internetStatus();
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey();
  String email, password;
  String userName, mobileNo, firstName, lastName, userId;
  @override
  Widget build(BuildContext context) {
    //double deviceheight = MediaQuery.of(context).size.height;
    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: WillPopScope(
      onWillPop: onWillPop,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: devicewidth,
              //height: deviceheight / 2.5,
              decoration: BoxDecoration(
                //color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'images/user.png',
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    textFormField(
                      hintText: 'Email Address',
                      inputType: TextInputType.name,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                      onSaved: (value) => email = value,
                    ),
                    textFormField(
                      hintText: 'Password',
                      inputType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty || value.length <= 6) {
                          return 'invalid password';
                        }
                        return null;
                      },
                      onSaved: (value) => password = value,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Padding(
                              padding:
                                  EdgeInsets.only(top: 10, left: 5, right: 5),
                              child: mainbutton(
                                  buttonName: 'Login',
                                  function: () async {
                                    if (await internetStatus()) {
                                      login();
                                    }
                                  })),
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Padding(
                              padding:
                                  EdgeInsets.only(top: 10, left: 5, right: 5),
                              child: mainbutton(
                                  buttonName: 'Home Screen',
                                  function: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyHomePage()));
                                  })),
                        ),
                      ],
                    ),
                    FlatButton(
                        onPressed: forgot, child: Text('Forgot Password'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  forgot() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPassword()));
  }

  login() async {
    List<String> userDetailsList = List();
    Map<String, dynamic> userDetailsmap = Map();
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        final newUser = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        //print('-----newUser-----$newUser');

        if (newUser != null) {
          //String uid = newUser.user.uid;

          User user = FirebaseAuth.instance.currentUser;
          FirebaseFirestore.instance
              .collection('admin')
              .where('Email', isEqualTo: user.email)
              .get()
              .then((snapshot) {
            snapshot.docs.forEach((element) {
              userDetailsmap = element.data();
              userDetailsList.add(userDetailsmap["FirstName"].toString());
              userDetailsList.add(userDetailsmap["LastName"].toString());
              userDetailsList.add(userDetailsmap["Email"].toString());
              userDetailsList.add(userDetailsmap["MobileNo"].toString());
              userDetailsList.add(userDetailsmap["UserId"].toString());
              userDetailsList.add(userDetailsmap["UserName"].toString());
            });
            firstName = userDetailsList.elementAt(0);
            lastName = userDetailsList.elementAt(1);
            mobileNo = userDetailsList.elementAt(3);
            userId = userDetailsList.elementAt(4);
            userName = userDetailsList.elementAt(5);
            setValue(firstName, lastName, userName, mobileNo, userId);
          });
          //print('------------${newUser.user.uid}-----------');
        } else {
          Fluttertoast.showToast(msg: 'Invalid Email And Password');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void setValue(String firstName, String lastName, String userName,
      String mobileNo, String userId) async {
    SharedPreferences sharedPrefer = await SharedPreferences.getInstance();
    sharedPrefer.setString('user_first_name', firstName);
    sharedPrefer.setString('user_last_name', lastName);
    sharedPrefer.setString('user_user_name', userName);
    sharedPrefer.setString('user_email', email);
    sharedPrefer.setString('user_mobile_no', mobileNo);
    sharedPrefer.setString('user_id', userId);
    //setValue(firstName.toString());
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => AdminIndex()));

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => AdminIndex()),
      (Route<dynamic> route) => false,
    );
  }
}
