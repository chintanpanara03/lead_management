import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lead_manage/common/backbutton/back_button.dart';
import 'package:lead_manage/common/connectivity/internet_status.dart';
import 'package:lead_manage/common/widget/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lead_manage/views/admin/home/index.dart';
import 'package:lead_manage/views/login/home_page.dart';
import 'package:lead_manage/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userRef = FirebaseFirestore.instance.collection('admin');

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  void initState() {
    //getUsers();
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey();
  String email, password, userName, mobileNo, firstName, lastName;
  //int userId = 0;
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: devicewidth / 2.3,
                            child: textFormField(
                              hintText: 'First Name',
                              inputType: TextInputType.name,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter First Name';
                                }
                                return null;
                              },
                              onSaved: (value) => firstName = value,
                            ),
                          ),
                          Container(
                            width: devicewidth / 2.3,
                            child: textFormField(
                              hintText: 'Last Name',
                              inputType: TextInputType.name,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Last Name';
                                }
                                return null;
                              },
                              onSaved: (value) => lastName = value,
                            ),
                          ),
                        ],
                      ),
                      textFormField(
                        hintText: 'User Name',
                        inputType: TextInputType.name,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter UserName';
                          }
                          return null;
                        },
                        onSaved: (value) => userName = value,
                      ),
                      textFormField(
                        hintText: 'Email Address',
                        inputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Email';
                          } else if (!value.contains('@')) {
                            return 'Invalid Email';
                          }
                          return null;
                        },
                        onSaved: (value) => email = value,
                      ),
                      textFormField(
                        hintText: 'Mobile Number',
                        inputType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Mobile Number';
                          } else if (value.length <= 9) {
                            return 'Invalid Mobile Number';
                          }
                          return null;
                        },
                        onSaved: (value) => mobileNo = value,
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
                                    buttonName: 'Registration',
                                    function: () async {
                                      if (await internetStatus()) {
                                        getUsers();
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  registration(int userId) async {
    int uId = userId;
    final formState = formKey.currentState;
    String adminId = FirebaseFirestore.instance.collection('admin').doc().id;
    print('adminId  :------------ $adminId');
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((registrationUser) =>
                FirebaseFirestore.instance.collection('admin').add({
                  'UserId': adminId,
                  'FirstName': firstName,
                  'LastName': lastName,
                  'UserName': userName,
                  'Email': email,
                  'MobileNo': mobileNo,
                  'Password': password
                }).then((value) {
                  if (registrationUser != null) {
                    //getUsers();
                    setValue(uId);
                  }
                }));
      } catch (e) {
        print(e.m);
      }
    }
  }

  void setValue(int id) async {
    String userId = id.toString();
    SharedPreferences sharedPrefer = await SharedPreferences.getInstance();
    sharedPrefer.setString('user_first_name', firstName);
    sharedPrefer.setString('user_last_name', lastName);
    sharedPrefer.setString('user_user_name', userName);
    sharedPrefer.setString('user_email', email);
    sharedPrefer.setString('user_mobile_no', mobileNo);
    sharedPrefer.setString('user_id', userId);
    //setValue(firstName.toString());
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AdminIndex()));
  }

  // test(int userIdd) {
  //   int abc = userIdd;
  //   print(abc);
  // }

  getUsers() {
    int userId = 0;
    List<String> emailList = List();
    Map<String, dynamic> dataMap = Map();
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();

      FirebaseFirestore.instance
          .collection('admin')
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((DocumentSnapshot doc) {
          dataMap = doc.data();
          emailList.add(dataMap["Email"]);
        });
        userId = emailList.length + 1;
        //print('-----------$userId-----------');
        //print(emailList);
        if (emailList.isNotEmpty) {
          if (emailList.contains(email)) {
            //print("------ is match --------");
            //test(userId);
            Fluttertoast.showToast(
                msg:
                    'an account is already registered with your email address. please login');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          } else {
            //print("------ is not match --------");
            registration(userId);
          }
        } else {
          //print("------ list is empty --------");
          registration(userId);
        }
      });
    }
  }
}
