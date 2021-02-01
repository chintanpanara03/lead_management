import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lead_manage/common/widget/common.dart';

class HighPriority extends StatefulWidget {
  HighPriority({Key key}) : super(key: key);

  @override
  _HighPriorityState createState() => _HighPriorityState();
}

class _HighPriorityState extends State<HighPriority> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: detailsappbar(
        appbarTitle: 'All Lead',
      ),
      body: mainpadding(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('lead')
                    .where('Priority', isEqualTo: 'High')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return new Text('Loading...');
                  } else {
                    return ListView(
                      //shrinkWrap: true,
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return GestureDetector(
                          onTap: () {},
                          child: Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Table(
                                    children: [
                                      TableRow(children: [
                                        simplepadding(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: boldText(
                                                text:
                                                    '${document['FirstName']} ${document['LastName']}'),
                                          ),
                                        ),
                                        simplepadding(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: simpleText(
                                                text:
                                                    '${document['ProductName']}'),
                                          ),
                                        )
                                      ]),
                                      TableRow(children: [
                                        simplepadding(
                                          child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.phone_forwarded,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  simpleText(
                                                      text:
                                                          '${document['MobileNo']}'),
                                                ],
                                              )),
                                        ),
                                        simplepadding(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: simpleText(
                                                text:
                                                    '${document['Priority']}'),
                                          ),
                                        )
                                      ]),
                                    ],
                                  ))),
                        );
                      }).toList(),
                    );
                  }
                })),
      ),
    );
  }
}
