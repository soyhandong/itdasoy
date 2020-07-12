import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itda/writePoem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itda/writeStory.dart';

class StoryConnect extends StatefulWidget {
  @override
  _StoryConnectState createState() => _StoryConnectState();
}

class _StoryConnectState extends State<StoryConnect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xffe9f4eb),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.help,
                color: Color(0xfffbb359),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WriteStory()));
              },
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "마음을 ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                width: 28,
                child: Image.asset('assets/Itda_black.png'),
              ),
            ],
          )
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 50.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xff53975c),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    child: Image.asset('assets/ink.png'),
                    //color: Colors.white,
                  ),
                  Container(
                    width: 20.0,
                  ),
                  Container(
                    child: Text(
                      '시로 마음을 잇다',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Arita-dotum-_OTF",
                        fontStyle: FontStyle.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/Itda_black.png'),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('소영',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            //color: Colors.black,
                          ),
                        ),
                        Container(width: 10.0,),
                        Text('학교',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text('제목',),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => WritePoem())),
                    },
                    //selected: true,
                  ),
                ],
              ),
            ),
            */
            _slist(),
            SizedBox(height: 10.0,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xfffff7ef),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                      ),
                    ),
                    child: GestureDetector(
                      child: _wPBuildConnectItem('assets/itda_orange.png', '글쓰기'),
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WritePoem())),
                      },
                    ),
                  ),
                ],
              ),
            ),
            //_list(),
          ],
        ),
      ),
    );
  }
  Widget _wPBuildConnectItem(String wPimgPath, String wPlinkName) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: 80.0,
      height: 50.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 20,
            height: 20,
            child: Image.asset(wPimgPath),
            //color: Colors.white,
          ),
          Container(
            height: 3.0,
          ),
          Container(
            child: Text(
              wPlinkName,
              style: TextStyle(
                color: Color(0xfffbb359),
                fontWeight: FontWeight.w700,
                fontFamily: "Arita-dotum-_OTF",
                fontStyle: FontStyle.normal,
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _slist () {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('storyList').snapshots(),
          builder: (context, snapshot) {
            final items = snapshot.data.documents;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/Itda_black.png'),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(item['ssubject'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            //color: Colors.black,
                          ),
                        ),
                        Container(width: 10.0,),
                        Text(item['scontent'],
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(item['srecord'],),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => WritePoem())),
                    },
                    //selected: true,
                );
              },
            );
          }
      ),
    );
  }
  /*
  Widget _list () {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('test').snapshots(),
          builder: (context, snapshot) {
            final items = snapshot.data.documents;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                    title: Text(item['title']),
                    subtitle: Text(item['subtitle'])
                );
              },
            );
          }
      ),
    );
  }
   */
}