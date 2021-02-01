import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lead_manage/common/widget/common.dart';
import 'package:lead_manage/views/admin/details/details_page.dart';

class AllLead extends StatefulWidget {
  AllLead({Key key}) : super(key: key);

  @override
  _AllLeadState createState() => _AllLeadState();
}

class _AllLeadState extends State<AllLead> {
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
                    .where('Status', isEqualTo: 'Following')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: new Text('Loading...'));
                  } else {
                    return ListView(
                      //shrinkWrap: true,
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return GestureDetector(
                          onTap: () => navigateToDetails(document),
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
                                      TableRow(children: [
                                        SizedBox(),
                                        simplepadding(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: simpleText(
                                                text:
                                                    '${document['Date'].toDate().toString().split(' ')[0]}'),
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

  navigateToDetails(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailsPage(
                  post: post,
                )));
  }
}
