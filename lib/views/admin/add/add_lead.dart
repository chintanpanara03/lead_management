import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lead_manage/common/connectivity/internet_status.dart';
import 'package:lead_manage/common/widget/common.dart';
import 'package:lead_manage/views/admin/add/add_category.dart';
import 'package:lead_manage/views/admin/add/add_product.dart';
import 'package:lead_manage/views/admin/details/setting.dart';
import 'package:lead_manage/views/admin/home/index.dart';
import 'package:lead_manage/views/admin/profile/profile.dart';
import 'package:lead_manage/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLead extends StatefulWidget {
  AddLead({Key key}) : super(key: key);

  @override
  _AddLeadState createState() => _AddLeadState();
}

class _AddLeadState extends State<AddLead> {
  @override
  void initState() {
    getValue();
    getCategory();
    //seleCateId();
    super.initState();
  }

  String userFirstName,
      userLastName,
      userId,
      userUserName,
      userEmail,
      userMobileNo;
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String firstName, lastName, email, mobileNo, city;
  DateTime dob;
  String dropdownPriority = 'High';
  List<String> productList = List();
  String dropdownProduct = '';
  List<String> categoryList = List();
  String dropdownCategory = '';
  @override
  Widget build(BuildContext context) {
    //double deviceheight = MediaQuery.of(context).size.height;
    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: appbar(
          appbarTitle: 'New Lead',
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
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
                                      } else if (value.contains(' ')) {
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
                              hintText: 'Email',
                              inputType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Email';
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
                                  return 'Please enter Mobile Number';
                                } else if (value.length <= 9) {
                                  return 'Mobile Length is 10';
                                }
                                return null;
                              },
                              onSaved: (value) => mobileNo = value,
                            ),
                            textFormField(
                              hintText: 'City',
                              inputType: TextInputType.name,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter City';
                                }
                                return null;
                              },
                              onSaved: (value) => city = value,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Container(
                                      width: devicewidth / 1.6,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1, color: Colors.black54)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Date Of Birthday",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${selectedDate.toLocal()}"
                                                .split(' ')[0],
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 50,
                                    width: devicewidth / 4.8,
                                    child: RaisedButton(
                                        child: Icon(Icons.calendar_today),
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.green),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        onPressed: () => _selectDate(context)),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                height: 50,
                                width: devicewidth,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 1, color: Colors.black54)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 28),
                                  child: DropdownButton<String>(
                                    value: dropdownPriority,
                                    //icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black54),
                                    // underline: Container(
                                    //   height: 2,
                                    //   color: Colors.deepPurpleAccent,
                                    // ),
                                    underline: SizedBox(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownPriority = newValue;
                                      });
                                    },
                                    items: <String>[
                                      'High',
                                      'Medium',
                                      'Low',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                height: 50,
                                width: devicewidth,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 1, color: Colors.black54)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 28),
                                  child: DropdownButton<String>(
                                    value: dropdownCategory,
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black54),
                                    underline: SizedBox(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownCategory = newValue;
                                        productList.clear();
                                        seleCateId();
                                      });
                                    },
                                    items: categoryList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                height: 50,
                                width: devicewidth,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 1, color: Colors.black54)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 28),
                                  child: DropdownButton<String>(
                                    value: dropdownProduct,
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black54),
                                    underline: SizedBox(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownProduct = newValue;
                                      });
                                    },
                                    items: productList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              //height: 60,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 10, right: 10, bottom: 15),
                                child: mainbutton(
                                  buttonName: 'Add Lead',
                                  buttonBorderColor: Colors.green,
                                  function: () async {
                                    if (await internetStatus()) {
                                      addLead();
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getCategory() {
    Map<String, dynamic> dataMap = Map();
    FirebaseFirestore.instance
        .collection('category')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        dataMap = doc.data();
        categoryList.add(dataMap["CategoryName"]);
      });
      setState(() {
        dropdownCategory = categoryList.first;
        seleCateId();
        //return categoryList;
      });
    });
  }

  seleCateId() {
    String categoryId;
    FirebaseFirestore.instance
        .collection('category')
        .where("CategoryName", isEqualTo: dropdownCategory)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          categoryId = element["CategoryId"];
          getProduct(categoryId);
        });
      });
    });
  }

  getProduct(String categoryId) {
    Map<String, dynamic> dataMap = Map();

    FirebaseFirestore.instance
        .collection('product')
        .where("CategoryId", isEqualTo: categoryId)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        dataMap = doc.data();
        productList.add(dataMap["ProductName"]);
      });
      setState(() {
        dropdownProduct = productList.first;
        return productList;
      });
    });
  }

  addLead() {
    String leadId = FirebaseFirestore.instance.collection('lead').doc().id;
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseFirestore.instance.collection('lead').add({
          'LeadId': leadId,
          'CategoryName': dropdownCategory,
          'ProductName': dropdownProduct,
          'City': city,
          'DateOfBirth': dob,
          'Email': email,
          'FirstName': firstName,
          'LastName': lastName,
          'MobileNo': mobileNo,
          'Priority': dropdownPriority,
          'AdminId': userId,
          'Status': 'Following',
          'Date': DateTime.now(),
        });
        Fluttertoast.showToast(msg: 'Lead is Added');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AdminIndex()),
            (route) => false);
      } catch (e) {
        print(e.m);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dob = picked;
        return dob;
      });
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

  void getValue() async {
    final SharedPreferences sharedPrefer =
        await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPrefer.getString('user_id');
      userFirstName = sharedPrefer.getString('user_first_name');
      userLastName = sharedPrefer.getString('user_last_name');
      userUserName = sharedPrefer.getString('user_user_name');
      userEmail = sharedPrefer.getString('user_email');
      userMobileNo = sharedPrefer.getString('user_mobile_no');
    });
  }
}
