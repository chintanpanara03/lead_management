import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lead_manage/common/connectivity/internet_status.dart';
import 'package:lead_manage/common/widget/common.dart';
import 'package:lead_manage/views/admin/add/add_lead.dart';
import 'package:lead_manage/views/admin/add/add_product.dart';
import 'package:lead_manage/views/admin/details/setting.dart';
import 'package:lead_manage/views/admin/home/index.dart';
import 'package:lead_manage/views/admin/profile/profile.dart';
import 'package:lead_manage/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCategory extends StatefulWidget {
  AddCategory({Key key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  void initState() {
    getValue();
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey();
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
  String category;
  @override
  Widget build(BuildContext context) {
    double devicewidth = MediaQuery.of(context).size.width;
    // deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: appbar(
          appbarTitle: 'Add Category',
          drawerFunction: () {
            _scaffoldKey.currentState.openDrawer();
          },
          logoutFunction: logOut),
      drawer: commonDrawer(
        adminName: '$userFirstName  $userLastName',
        adminEmail: '$userEmail',
        headerWidth: devicewidth,
        dashboard: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminIndex()));
        },
        addcategory: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddCategory()));
        },
        addlead: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddLead()));
        },
        addproduct: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddProduct()));
        },
        setting: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Setting()));
        },
        yourprofile: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Profile()));
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mainpadding(
              child: Card(
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        mainpadding(
                          child: textFormField(
                            hintText: 'Category Name',
                            inputType: TextInputType.name,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Category';
                              }
                              return null;
                            },
                            onSaved: (value) => category = value,
                          ),
                        ),
                        Container(
                          //height: 60,
                          width: MediaQuery.of(context).size.width / 2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 10, right: 10, bottom: 15),
                            child: mainbutton(
                              buttonName: 'Add Category',
                              buttonBorderColor: Colors.green,
                              function: () async {
                                if (await internetStatus()) {
                                  getCategory();
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  getCategory() {
    List<String> categoryList = List();
    Map<String, dynamic> dataMap = Map();
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();

      FirebaseFirestore.instance
          .collection('category')
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((DocumentSnapshot doc) {
          dataMap = doc.data();
          categoryList.add(dataMap["CategoryName"]);
        });
        if (categoryList.isNotEmpty) {
          if (categoryList.contains(category)) {
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text('Category is already exiset')));
          } else {
            addCategory();
          }
        } else {
          addCategory();
        }
      });
    }
  }

  addCategory() async {
    String cId = FirebaseFirestore.instance.collection('category').doc().id;
    print('----------$cId---------');
    try {
      FirebaseFirestore.instance.collection('category').add({
        'CategoryId': cId,
        'CategoryName': category,
      });
      Fluttertoast.showToast(msg: 'Category is Added');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminIndex()),
          (route) => false);
    } catch (e) {
      print(e.m);
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences sharedPrefer = await SharedPreferences.getInstance();
    await sharedPrefer.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
