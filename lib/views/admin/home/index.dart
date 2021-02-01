import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lead_manage/common/backbutton/back_button.dart';
import 'package:lead_manage/common/widget/common.dart';
import 'package:lead_manage/views/admin/add/add_category.dart';
import 'package:lead_manage/views/admin/add/add_lead.dart';
import 'package:lead_manage/views/admin/add/add_product.dart';
import 'package:lead_manage/views/admin/details/all_lead.dart';
import 'package:lead_manage/views/admin/details/converted.dart';
import 'package:lead_manage/views/admin/details/dead.dart';
import 'package:lead_manage/views/admin/details/high_priority.dart';
import 'package:lead_manage/views/admin/details/low_priority.dart';
import 'package:lead_manage/views/admin/details/medium_priority.dart';
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
    setState(() {
      getValue();
      countDocuments();
    });
    super.initState();
  }

  String allLead, converted, dead, highPriority, mediumPriority, lowPriority;
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
                          statusData: allLead ?? '0',
                          statusName: 'All Lead',
                          function: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllLead()));
                          }),
                      currentStatus(
                          statusData: converted ?? '0',
                          statusName: 'Converted',
                          function: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Converted()));
                          }),
                      currentStatus(
                          statusData: dead ?? '0',
                          statusName: 'Dead',
                          function: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dead()));
                          }),
                      currentStatus(
                          statusData: highPriority ?? '0',
                          statusName: 'High Priority',
                          function: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HighPriority()));
                          }),
                      currentStatus(
                          statusData: mediumPriority ?? '0',
                          statusName: 'Medium Priority',
                          function: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MediumPriority()));
                          }),
                      currentStatus(
                          statusData: lowPriority ?? '0',
                          statusName: 'Low Priority',
                          function: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LowPriority()));
                          }),
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

  countDocuments() async {
    QuerySnapshot _allLeadDoc =
        await FirebaseFirestore.instance.collection('lead').get();
    List<DocumentSnapshot> _allLeadDocCount = _allLeadDoc.docs;
    setState(() {
      return allLead = _allLeadDocCount.length.toString();
    });

    QuerySnapshot _allHighPriorityLeadDoc = await FirebaseFirestore.instance
        .collection('lead')
        .where('Priority', isEqualTo: 'High')
        .get();
    List<DocumentSnapshot> _allHighPriorityLeadDocCount =
        _allHighPriorityLeadDoc.docs;
    setState(() {
      return highPriority = _allHighPriorityLeadDocCount.length.toString();
    });

    QuerySnapshot _allMediumPriorityLeadDoc = await FirebaseFirestore.instance
        .collection('lead')
        .where('Priority', isEqualTo: 'Medium')
        .get();
    List<DocumentSnapshot> _allMediumPriorityLeadDocCount =
        _allMediumPriorityLeadDoc.docs;
    setState(() {
      return mediumPriority = _allMediumPriorityLeadDocCount.length.toString();
    });

    QuerySnapshot _allLowPriorityLeadDoc = await FirebaseFirestore.instance
        .collection('lead')
        .where('Priority', isEqualTo: 'Low')
        .get();
    List<DocumentSnapshot> _allLowPriorityLeadDocCount =
        _allLowPriorityLeadDoc.docs;
    setState(() {
      return lowPriority = _allLowPriorityLeadDocCount.length.toString();
    });

    QuerySnapshot _allConvertedDoc = await FirebaseFirestore.instance
        .collection('lead')
        .where('Status', isEqualTo: 'Converted')
        .get();
    List<DocumentSnapshot> _allConvertedDocCount = _allConvertedDoc.docs;
    setState(() {
      return converted = _allConvertedDocCount.length.toString();
    });

    QuerySnapshot _allDeadDoc = await FirebaseFirestore.instance
        .collection('lead')
        .where('Status', isEqualTo: 'Dead')
        .get();
    List<DocumentSnapshot> _allDeadDocCount = _allDeadDoc.docs;
    setState(() {
      return dead = _allDeadDocCount.length.toString();
    });
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
