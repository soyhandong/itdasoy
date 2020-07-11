import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'connectPoem.dart';

class WritePoem extends StatefulWidget {
  @override
  _WritePoemState createState() => _WritePoemState();
}

class _WritePoemState extends State<WritePoem> {
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
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConnectPoem()));
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
                boxShadow: [BoxShadow(
                  color: Color(0xffb5c8bc),
                  offset: Offset(0,10),
                )] ,
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
                    width:20.0,
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
            Container(
              height: 60,
              decoration: BoxDecoration(
                  color: const Color(0xffe9f4eb)
              ),
              child: Row(
                children: <Widget>[
                  _recordingItem('assets/record.png','녹음 하기'),
                  _recordingItem('assets/listen.png','녹음 듣기'),
                  _recordingItem('assets/complete.png','녹음 완료'),
                  _recordingItem('assets/rerecord.png','다시 녹음'),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              height: 400.0,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xffe9f4eb),
                    width: 1.0,
                  ),
                  color: const Color(0xffffffff)
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('제목',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Container(
                            width: 350.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: const Color(0x69e9f4eb)
                            )
                        ),
                        SizedBox(height: 10.0,),
                        Text('나의 느낀점(다짐)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Container(
                            width: 350.0,
                            height: 200.0,
                            decoration: BoxDecoration(
                                color: const Color(0x69e9f4eb)
                            )
                        ),
                        SizedBox(height: 10.0,),
                        Text('녹음파일',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Container(
                            width: 350.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: const Color(0x69e9f4eb)
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                    child: _wPBuildConnectItem('assets/itda_orange.png','잇기(올리기)'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xfffff7ef),
                    ),
                    child: _wPBuildConnectItem('assets/hold.png','나만보기'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xfffff7ef),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                    ),
                    child: _wPBuildConnectItem('assets/list.png','목록'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _recordingItem(String rimgPath, String rlinkName) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 25,
            height: 25,
            child: Image.asset(rimgPath),
            //color: Colors.white,
          ),
          Container(
            height: 3.0,
          ),
          Container(
            child: Text(
              rlinkName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontFamily: "Arita-dotum-_OTF",
                fontStyle: FontStyle.normal,
                fontSize: 9,
              ),
            ),
          ),
        ],
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
}