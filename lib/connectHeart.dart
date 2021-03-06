//https://github.com/rajayogan/flutterui-curveddesigns
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:itda/connectPoem.dart';
import 'package:itda/help.dart';
import 'package:itda/connectSong.dart';
import 'package:itda/connectStory.dart';

class ConnectHeart extends StatefulWidget {
  @override
  _ConnectHeartState createState() => _ConnectHeartState();
}

class _ConnectHeartState extends State<ConnectHeart> {
  Future<void> checkPermissions(BuildContext context) async {

    final PermissionState aks = await PermissionsPlugin.isIgnoreBatteryOptimization;

    PermissionState resBattery;
    if(aks != PermissionState.GRANTED)
      resBattery = await PermissionsPlugin.requestIgnoreBatteryOptimization;

    print(resBattery);

    Map<Permission, PermissionState> permission = await PermissionsPlugin
        .checkPermissions([
      Permission.RECORD_AUDIO,
    ]);

    if( permission[Permission.RECORD_AUDIO] != PermissionState.GRANTED) {

      try {
        permission = await PermissionsPlugin
            .requestPermissions([
          Permission.RECORD_AUDIO,
        ]);
      } on Exception {
        debugPrint("Error");
      }

      if( permission[Permission.RECORD_AUDIO] == PermissionState.GRANTED )
        print("Login ok");
      else
        permissionsDenied(context);

    } else {
      print("Login ok");
    }
  }

  void permissionsDenied(BuildContext context){
    showDialog(context: context, builder: (BuildContext _context) {
      return SimpleDialog(
        title: const Text("Permisos denegados"),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
            child: const Text(
              "Debes conceder todo los permiso para poder usar esta aplicacion",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54
              ),
            ),
          )
        ],
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    checkPermissions(context);
    return Scaffold(
      backgroundColor: Color(0xffe9f4eb),
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
                    MaterialPageRoute(builder: (context) => HelpPage()));
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
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(60, 40, 60, 0),
            child: Text(
                "시, 이야기, 노래를 통해 나의 마음을 다스리고 상대방을 이해하기 위해 노력해 보아요!",
                style: TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Arita-dotum-_OTF",
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                  width: 140,
                  child: Divider(thickness: 1),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Icon(
                    Icons.star,
                    color: Color(0xfffbb359),
                    size: 17,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  width: 140,
                  child: Divider(thickness: 1),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
            child: Text(
                "나의 마음을 시, 이야기 노래로 녹음하여 다른 학교 친구들과 나눌 수 있어요 함께 해볼까요? ",
                style: TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Arita-dotum-_OTF",
                  fontStyle: FontStyle.normal,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center
            ),
          ),
          SizedBox(height: 50.0,),
          Container(
            height: MediaQuery.of(context).size.height - 100.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              padding: EdgeInsets.fromLTRB(100, 60, 0, 0),
              children: <Widget>[
                GestureDetector(
                  child: _buildConnectItem('assets/ink.png', '시로 마음을 잇다'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConnectPoem()));
                  },
                ),
                SizedBox(height: 30.0,),
                GestureDetector(
                  child: _buildConnectItem('assets/bookline.png', '이야기로 마음을 잇다'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConnectStory()));
                  },
                ),
                SizedBox(height: 30.0,),
                GestureDetector(
                  child: _buildConnectItem('assets/music.png', '노래로 마음을 잇다'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConnectSong()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildConnectItem(String imgPath, String linkName) {
    return Container(
      width: 250,
      height: 100.0,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: Color(0xffb5c8bc),
          offset: Offset(0,10),
          blurRadius: 20,
          spreadRadius: 0,
        )] ,
        color: Color(0xff53975c),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            bottomLeft: Radius.circular(50.0)
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width:50.0,
          ),
          Container(
            width: 35,
            height: 35,
            child: Image.asset(imgPath),
            //color: Colors.white,
          ),
          Container(
            width:20.0,
          ),
          Container(
            child: Text(
              linkName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: "Arita-dotum-_OTF",
                fontStyle: FontStyle.normal,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}