import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lead_manage/common/backbutton/back_button.dart';
import 'package:lead_manage/common/widget/common.dart';
import 'package:lead_manage/views/admin/add/add_category.dart';
import 'package:lead_manage/views/admin/add/add_lead.dart';
import 'package:lead_manage/views/admin/add/add_product.dart';
import 'package:lead_manage/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminIndex extends StatefulWidget {
  AdminIndex({
    Key key,
  }) : super(key: key);

  @override
  _AdminIndexState createState() => _AdminIndexState();
}

class _AdminIndexState extends State<AdminIndex> {
  @override
  void initState() {
    getValue();
    super.initState();
  }

  String userFirstName, userLastName, userUserName, userEmail, userMobileNo;
  void getValue() async {
    final SharedPreferences sharedPrefer =
        await SharedPreferences.getInstance();
    setState(() {
      userFirstName = sharedPrefer.getString('user_first_name');
      userLastName = sharedPrefer.getString('user_last_name');
      userUserName = sharedPrefer.getString('user_user_name');
      userEmail = sharedPrefer.getString('user_email');
      userMobileNo = sharedPrefer.getString('user_mobile_no');
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double devicewidth = MediaQuery.of(context).size.width;
    double deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      appBar: appbar(
          appbarTitle: 'Lead Manage',
          drawerFunction: () {
            _scaffoldKey.currentState.openDrawer();
          },
          logoutFunction: logOut),
      drawer: commonDrawer(
          adminName: '$userFirstName  $userLastName',
          adminEmail: '$userEmail',
          headerWidth: devicewidth),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 10, right: 10, bottom: 30),
                  child: Container(
                    width: deviceheight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        iconButton(
                            buttonName: 'New Lead',
                            icon: Icons.person_add_alt_1,
                            function: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddLead()));
                            }),
                        iconButton(
                            buttonName: 'Add Category',
                            icon: Icons.category,
                            function: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddCategory()));
                            }),
                        iconButton(
                            buttonName: 'Add Product',
                            icon: Icons.add_circle_outline,
                            function: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddProduct()));
                            }),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: devicewidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 1),
                        child: Card(
                          child: Container(
                            height: 150,
                            width: devicewidth / 2.2,
                            child: displayFollowUp(
                                color: Colors.blue,
                                displayData: '20',
                                displayName: "Today's Follow Up",
                                function: () {}),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 1),
                        child: Card(
                          child: Container(
                            height: 150,
                            width: devicewidth / 2.2,
                            child: displayFollowUp(
                                color: Colors.red,
                                displayData: '2',
                                displayName: "Missed Follow Up",
                                function: () {}),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Current Status',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                      )),
                ),
                Container(
                  width: devicewidth,
                  child: Column(
                    children: [
                      currentStatus(
                          statusData: '2',
                          statusName: 'Following',
                          function: () {}),
                      currentStatus(
                          statusData: '2',
                          statusName: 'Converted',
                          function: () {}),
                      currentStatus(
                          statusData: '2', statusName: 'Dead', function: () {}),
                      currentStatus(
                          statusData: '2',
                          statusName: 'High Priority',
                          function: () {}),
                      currentStatus(
                          statusData: '2',
                          statusName: 'Medium Priority',
                          function: () {}),
                      currentStatus(
                          statusData: '2',
                          statusName: 'Low Priority',
                          function: () {}),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences sharedPrefer = await SharedPreferences.getInstance();
    await sharedPrefer.clear();
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => LoginPage()));

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
