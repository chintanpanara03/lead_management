import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lead_manage/common/connectivity/internet_status.dart';
import 'package:lead_manage/common/widget/common.dart';

class AddFollows extends StatefulWidget {
  final String leadId;
  AddFollows({Key key, this.leadId}) : super(key: key);

  @override
  _AddFollowsState createState() => _AddFollowsState();
}

class _AddFollowsState extends State<AddFollows> {
  GlobalKey<FormState> formKey = GlobalKey();
  String note;
  DateTime date;
  TimeOfDay time;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  @override
  Widget build(BuildContext context) {
    //double deviceheight = MediaQuery.of(context).size.height;
    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: detailsappbar(
        appbarTitle: 'Add Follow',
      ),
      body: mainpadding(
        child: Center(
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
                              textFormField(
                                hintText: 'Note',
                                inputType: TextInputType.name,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter Note';
                                  }
                                  return null;
                                },
                                onSaved: (value) => note = value,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Container(
                                        width: devicewidth / 1.7,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.black54)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Meeting Date",
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
                                      height: 45,
                                      width: devicewidth / 6,
                                      child: RaisedButton(
                                          child: Icon(Icons.calendar_today),
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.green),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          onPressed: () =>
                                              _selectDate(context)),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Container(
                                        width: devicewidth / 1.7,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.black54)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Meeting Time",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${selectedTime.hour}:${selectedTime.minute} ",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 45,
                                      width: devicewidth / 6,
                                      child: RaisedButton(
                                          child: Icon(Icons.calendar_today),
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.green),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          onPressed: () =>
                                              _selectTime(context)),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                //height: 60,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 10, right: 10, bottom: 15),
                                  child: mainbutton(
                                    buttonName: 'Add Follow',
                                    buttonBorderColor: Colors.green,
                                    function: () async {
                                      if (await internetStatus()) {
                                        addFollow();
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
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2022, 12));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = picked;
        return date;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        time = picked;
        return time;
      });
  }

  addFollow() {
    final formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      String leadId = widget.leadId;
      FirebaseFirestore.instance.collection('follow').add({
        'LeadId': leadId,
        'Note': note,
        'Date': date,
        'Time': time,
      });
      Fluttertoast.showToast(msg: 'Follow is Added');
    }
  }
}
