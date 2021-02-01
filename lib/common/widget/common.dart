import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget mainbutton(
    {String buttonName,
    Function function,
    Color buttonBorderColor = Colors.white}) {
  return RaisedButton(
      child: Text(buttonName),
      color: Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: buttonBorderColor),
          borderRadius: BorderRadius.circular(5)),
      onPressed: function);
}

Widget textFormField(
    {Function onSaved,
    Function validator,
    String hintText,
    TextInputType inputType,
    bool obscureText = false}) {
  return Padding(
    padding: EdgeInsets.all(5),
    child: Container(
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: inputType,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
      ),
    ),
  );
}

Widget iconButton({String buttonName, IconData icon, Function function}) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.circular(100)),
          child:
              IconButton(icon: Icon(icon), iconSize: 40, onPressed: function),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(buttonName),
        )
      ],
    ),
  );
}

Widget displayFollowUp(
    {String displayName, Color color, String displayData, Function function}) {
  return FlatButton(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(100)),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                displayData,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(displayName),
          )
        ],
      ),
    ),
    onPressed: function,
  );
}

Widget currentStatus(
    {String statusData, String statusName, Function function}) {
  return FlatButton(
    onPressed: function,
    padding: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.only(top: 0, left: 4, right: 4, bottom: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100)),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      statusData,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  statusName,
                  style: TextStyle(fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget appbar(
    {String appbarTitle, Function drawerFunction, Function logoutFunction}) {
  return AppBar(
    backgroundColor: Colors.white,
    leading: Padding(
      padding: const EdgeInsets.only(right: 5),
      child: IconButton(
        icon: Icon(Icons.menu),
        color: Colors.black,
        onPressed: drawerFunction,
      ),
    ),
    centerTitle: true,
    title: Text(
      appbarTitle,
      style: TextStyle(color: Colors.black),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(left: 5),
        child: IconButton(
          icon: Icon(Icons.exit_to_app),
          color: Colors.black,
          onPressed: logoutFunction,
        ),
      )
    ],
  );
}

Widget commonDrawer(
    {double headerWidth = 305, String adminName, String adminEmail}) {
  return Drawer(
    child: Column(children: [
      Container(
        width: headerWidth,
        color: Colors.blue[200],
        child: Padding(
          padding: EdgeInsets.only(top: 50.0, bottom: 30, left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                adminName,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                adminEmail,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      //Now let's Add the button for the Menu
      //and let's copy that and modify it
      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.dashboard,
          color: Colors.black,
        ),
        title: Text("Dashboard"),
      ),

      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.person_add,
          color: Colors.black,
        ),
        title: Text("Add Lead"),
      ),
      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.category,
          color: Colors.black,
        ),
        title: Text("Add Category"),
      ),
      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.add_circle_outline,
          color: Colors.black,
        ),
        title: Text("Add Product"),
      ),

      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.person,
          color: Colors.black,
        ),
        title: Text("Your Profile"),
      ),

      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.settings,
          color: Colors.black,
        ),
        title: Text("Settings"),
      ),
    ]),
  );
}

Widget internetLoder({double cheight, double cwidth}) {
  return Container(
    height: cheight,
    width: cwidth,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "No Internet",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        )
      ],
    ),
  );
}

Widget detailsappbar({String appbarTitle}) {
  return AppBar(
    backgroundColor: Colors.black54,
    centerTitle: true,
    title: Text(
      appbarTitle,
      style: TextStyle(color: Colors.white),
    ),
  );
}

Widget mainpadding({Widget child}) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: child,
  );
}

Widget boldText({String text}) {
  return Text(
    text,
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );
}

Widget simpleText({String text}) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
  );
}

Widget simplepadding({Widget child}) {
  return Padding(
    padding: EdgeInsets.all(5),
    child: child,
  );
}

Widget boldTextColor({String text}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  );
}

Widget simpleTextColor({String text}) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  );
}
