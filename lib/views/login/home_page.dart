import 'package:flutter/material.dart';
import 'package:lead_manage/common/backbutton/back_button.dart';
import 'package:lead_manage/common/widget/common.dart';
import 'package:lead_manage/views/login/login.dart';
import 'package:lead_manage/views/login/registration.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        height: deviceheight,
        width: devicewidth,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         colorFilter: new ColorFilter.mode(
        //             Colors.white.withOpacity(0.4), BlendMode.dstATop),
        //         image: AssetImage('images/leads.png'),
        //         fit: BoxFit.fitWidth)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Container(
                  width: devicewidth / 2,
                  height: 40,
                  child: mainbutton(
                      buttonName: 'Login',
                      function: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      })),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Container(
                  width: devicewidth / 2,
                  height: 40,
                  child: mainbutton(
                      buttonName: 'Registration',
                      function: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationPage()));
                      })),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Container(
                width: devicewidth / 2,
                height: 40,
                child: RaisedButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/google.png',
                          height: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Sign In With'),
                      ],
                    ),
                    onPressed: () {}),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
