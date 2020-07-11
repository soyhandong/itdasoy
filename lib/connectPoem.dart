import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'readPoem.dart';
import 'writePoem.dart';

class ConnectPoem extends StatefulWidget {
  @override
  _ConnectPoemState createState() => _ConnectPoemState();
}

class _ConnectPoemState extends State<ConnectPoem> {
  var selectedCard = 'WEIGHT';

  @override
  Widget build(BuildContext context) {
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
                      MaterialPageRoute(builder: (context) => ReadPoem()));
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
        body: ListView(children: [
          Stack(children: [
            Positioned(
              top: 30.0,
              left: 25.0,
              right: 25.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('시를잇다',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height - 82.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent),
            Positioned(
                top: 75.0,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                        color: Colors.white),
                    height: MediaQuery.of(context).size.height - 100.0,
                    width: MediaQuery.of(context).size.width)),
            Positioned(
              top: 120.0, right: 150.0,
              child: FlatButton(
                child: Text('글보기'),
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReadPoem()))
                },
                color: Colors.blueAccent,
                textColor:Colors.black,
              ),
            ),
            Positioned(
              top: 120.0, right: 60.0,
              child: FlatButton(
                child: Text('글쓰기'),
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WritePoem()))
                },
                color: Colors.blueAccent,
                textColor:Colors.black,
              ),
            ),
            Positioned(
                top: 150.0,
                left: 20.0,
                right: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/Itda_black.png'),
                      ),
                      title: Text('Horse'),
                      subtitle: Text('A strong animal'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        print('horse');
                      },
                      selected: true,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/Itda_black.png'),
                      ),
                      title: Text('Cow'),
                      subtitle: Text('Provider of milk'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        print('cow');
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/Itda_black.png'),
                      ),
                      title: Text('Camel'),
                      subtitle: Text('Comes with humps'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        print('camel');
                      },
                      enabled: false,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/Itda_black.png'),
                      ),
                      title: Text('Sheep'),
                      subtitle: Text('Provides wool'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        print('sheep');
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/Itda_black.png'),
                      ),
                      title: Text('Goat'),
                      subtitle: Text('Some have horns'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        print('goat');
                      },
                    ),
                  ],
                ),),
          ],),
        ]));
  }
}