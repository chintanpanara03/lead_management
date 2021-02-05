import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lead_manage/common/widget/common.dart';
import 'package:lead_manage/views/admin/add/add_follow.dart';
import 'package:lead_manage/views/admin/home/index.dart';

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
      categoryName,
      productName,
      status,
      priority,
      id,
      leadId;
  Timestamp date;

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
    categoryName = widget.post.get('CategoryName');
    status = widget.post.get('Status');
    priority = widget.post.get('Priority');
    leadId = widget.post.get('LeadId');
    date = widget.post.get('Date');
    id = widget.post.id;
  }

  priorityColor() {
    if (priority == 'High') {
      return BoxDecoration(
        color: Colors.purple[400],
      );
    } else if (priority == 'Medium') {
      return BoxDecoration(
        color: Colors.lightGreen,
      );
    } else {
      return BoxDecoration(
        color: Colors.grey[400],
      );
    }
  }

  statusColor() {
    if (status == 'Following') {
      return BoxDecoration(
        color: Colors.blue,
      );
    } else if (status == 'Converted') {
      return BoxDecoration(
        color: Colors.green,
      );
    } else {
      return BoxDecoration(
        color: Colors.red,
      );
    }
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
            onPressed: () {
              showPopUpMenu();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
              color: Colors.black54,
              height: 170,
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
                            decoration: statusColor(),
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
                            decoration: priorityColor(),
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
                              child: simpleTextColor(text: '$categoryName'),
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
                              child: simpleTextColor(text: '$productName'),
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          simplepadding(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: simpleTextColor(text: '$email'),
                            ),
                          ),
                          simplepadding(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: simpleTextColor(
                                  text:
                                      '${date.toDate().toString().split(' ')[0]}'),
                            ),
                          ),
                        ]),
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String leadId = id;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddFollows(leadId: leadId)));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  showPopUpMenu() async {
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(100, 70, 0, 0),
        items: [
          PopupMenuItem(
              child: GestureDetector(
                  child: Text('Converted'),
                  onTap: () {
                    convertedStatus();
                  })),
          PopupMenuItem(
              child: GestureDetector(
                  child: Text('Dead'),
                  onTap: () {
                    deadStatus();
                  })),
          PopupMenuItem(
              child: GestureDetector(child: Text('Edit'), onTap: () {})),
          PopupMenuItem(
              child: GestureDetector(
                  child: Text('Delete'),
                  onTap: () {
                    deleteLead();
                  })),
        ]);
  }

  convertedStatus() {
    FirebaseFirestore.instance
        .collection('lead')
        .doc(id)
        .update({'Status': 'Converted'});
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AdminIndex()));
  }

  deadStatus() {
    FirebaseFirestore.instance
        .collection('lead')
        .doc(id)
        .update({'Status': 'Dead'});
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AdminIndex()));
  }

  deleteLead() {
    FirebaseFirestore.instance.collection('lead').doc(id).delete();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AdminIndex()));
  }
}
