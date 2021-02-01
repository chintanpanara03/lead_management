import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lead_manage/common/connectivity/internet_status.dart';
import 'package:lead_manage/common/widget/common.dart';
import 'package:lead_manage/views/admin/home/index.dart';
import 'package:lead_manage/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  void initState() {
    getValue();
    getCategory();
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey();
  String userFirstName, userLastName, userUserName, userEmail, userMobileNo;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String product;
  String price;
  String dropdownValue = '';
  List<String> categoryList = List();

  @override
  Widget build(BuildContext context) {
    //double deviceheight = MediaQuery.of(context).size.height;
    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: appbar(
          appbarTitle: 'Add Product',
          drawerFunction: () {
            _scaffoldKey.currentState.openDrawer();
          },
          logoutFunction: logOut),
      drawer: commonDrawer(
          adminName: '$userFirstName  $userLastName',
          adminEmail: '$userEmail',
          headerWidth: devicewidth),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 15, right: 15, bottom: 5),
                            child: Container(
                              height: 50,
                              width: devicewidth,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1, color: Colors.black54)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 28),
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.black54),
                                  underline: SizedBox(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
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
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: textFormField(
                            hintText: 'Product Name',
                            inputType: TextInputType.name,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter product';
                              }
                              return null;
                            },
                            onSaved: (value) => product = value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: textFormField(
                            hintText: 'Product Price',
                            inputType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter product price';
                              }
                              return null;
                            },
                            onSaved: (value) => price = value,
                          ),
                        ),
                        Container(
                          //height: 60,
                          width: MediaQuery.of(context).size.width / 2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 10, right: 10, bottom: 15),
                            child: mainbutton(
                              buttonName: 'Add Product',
                              buttonBorderColor: Colors.green,
                              function: () async {
                                if (await internetStatus()) {
                                  seleCateId();
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

  seleCateId() {
    String categoryId;
    String categoryName;
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      FirebaseFirestore.instance
          .collection('category')
          .where("CategoryName", isEqualTo: dropdownValue)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          setState(() {
            categoryId = element['CategoryId'];
            categoryName = element['CategoryName'];
            getProduct(categoryId, categoryName);
          });
        });
      });
    }
  }

  getProduct(String categoryId, String categoryName) {
    String cId = categoryId;
    String cName = categoryName;
    List<String> productList = List();
    Map<String, dynamic> dataMap = Map();

    FirebaseFirestore.instance
        .collection('product')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        dataMap = doc.data();
        productList.add(dataMap["ProductName"]);
      });
      if (productList.isNotEmpty) {
        if (productList.contains(product)) {
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text('Product is already exiset')));
        } else {
          addProduct(cId, cName);
        }
      } else {
        addProduct(cId, cName);
      }
    });
  }

  addProduct(String cId, String cName) {
    String productId =
        FirebaseFirestore.instance.collection('product').doc().id;
    try {
      FirebaseFirestore.instance.collection('product').add({
        'ProductId': productId,
        'ProductName': product,
        'ProductPrice': price,
        'CategoryId': cId,
        'CategoryName': cName,
      });
      Fluttertoast.showToast(msg: 'Product is Added');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminIndex()),
          (route) => false);
    } catch (e) {
      print(e.m);
    }
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
        dropdownValue = categoryList.first;
        return categoryList;
      });
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
      userFirstName = sharedPrefer.getString('user_first_name');
      userLastName = sharedPrefer.getString('user_last_name');
      userUserName = sharedPrefer.getString('user_user_name');
      userEmail = sharedPrefer.getString('user_email');
      userMobileNo = sharedPrefer.getString('user_mobile_no');
    });
  }
}
