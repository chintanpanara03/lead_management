import 'package:flutter/material.dart';
import 'package:lead_manage/common/connectivity/internet_status.dart';
import 'package:lead_manage/common/widget/common.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String mobileNo, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              //height: deviceheight / 2.5,
              decoration: BoxDecoration(
                //color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
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
                      hintText: 'Mobile Number',
                      inputType: TextInputType.number,
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty || value.length <= 10) {
                          return 'invalid mobile number';
                        }
                        return null;
                      },
                      onSaved: (value) => mobileNo = value,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Padding(
                          padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                          child: mainbutton(
                              buttonName: 'Submit',
                              function: () async {
                                if (await internetStatus()) {
                                  otpSubmit();
                                }
                              })),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: OTPTextField(
                            length: 5,
                            style: TextStyle(fontSize: 17),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onCompleted: (pin) {
                              print("Completed: " + pin);
                            },
                          )),
                    ),
                    textFormField(
                      hintText: 'New Password',
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
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Padding(
                          padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                          child: mainbutton(
                              buttonName: 'Forgot Password',
                              function: () async {
                                if (await internetStatus()) {
                                  forgotPassword();
                                }
                              })),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  forgotPassword() {}
  otpSubmit() {}
}
