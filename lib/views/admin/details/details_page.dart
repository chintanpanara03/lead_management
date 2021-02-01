import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lead_manage/common/widget/common.dart';

class DetailsPage extends StatefulWidget {
  final DocumentSnapshot post;
  DetailsPage({Key key, this.post}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String firstName,
      lastName,
      mobileNo,
      email,
      productName,
      status,
      priority,
      id;
  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }

  getData() {
    firstName = widget.post.get('FirstName');
    lastName = widget.post.get('LastName');
    mobileNo = widget.post.get('MobileNo');
    email = widget.post.get('Email');
    productName = widget.post.get('ProductName');
    status = widget.post.get('Status');
    priority = widget.post.get('Priority');
    id = widget.post.get('AdminId');
  }

  priorityColor() {
    if (status == 'Low') {
    } else if (status == 'Medium') {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black54,
          centerTitle: true,
          title: Text('Lead Details'),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert_rounded),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
                color: Colors.black54,
                height: 130,
                child: mainpadding(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          simplepadding(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.blue[300],
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: boldTextColor(text: status),
                              ),
                            ),
                          ),
                          simplepadding(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: 30,
                              color: Colors.amber,
                              child: Align(
                                alignment: Alignment.center,
                                child: boldTextColor(text: priority),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Table(
                        children: [
                          TableRow(children: [
                            simplepadding(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    boldTextColor(text: '$firstName $lastName'),
                              ),
                            ),
                            simplepadding(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: simpleTextColor(text: '$productName'),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            simplepadding(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.phone_forwarded,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      simpleTextColor(text: '$mobileNo'),
                                    ],
                                  )),
                            ),
                            simplepadding(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: simpleTextColor(text: '$email'),
                              ),
                            ),
                          ]),
                        ],
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}
