//https://minwook-shin.github.io/flutter-use-image-picker/ -->imagepicker
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itda/mealList.dart';
import 'package:itda/help.dart';

class ReadMeal extends StatefulWidget {
  String mindexing;
  ReadMeal({Key key,@required this.mindexing}) : super(key: key);
  @override
  _ReadMealState createState() => _ReadMealState();
}

class _ReadMealState extends State<ReadMeal> {
  File _image1, _image2, _image3, _image4, _image5, _image6;
  final _formKey = GlobalKey<FormState>();
  bool tansu = false;
  bool danback = false;
  bool jibang = false;
  bool vitamin = false;
  bool moogi = false;
  bool water = false;

  String pic1, pic2, pic3, pic4, pic5, pic6,
      pic1n, pic2n, pic3n, pic4n, pic5n, pic6n;
  static int mindex = 1;
  String mindexing = "$mindex";

  Firestore _firestore = Firestore.instance;
  FirebaseUser user;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  int point = -1;
  dynamic data;

  Future<String> getUser () async {
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("loginInfo").document(user.email);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        nickname =snapshot.data["nickname"];
        school = snapshot.data["schoolname"];
        grade = snapshot.data["grade"];
        clas = snapshot.data["class"];
        point = snapshot.data["point"];
      });
    });
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _imgUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _ImageURL1 = "";
  String _ImageURL2 = "";
  String _ImageURL3 = "";
  String _ImageURL4 = "";
  String _ImageURL5 = "";
  String _ImageURL6 = "";

  Future<String> getMeal () async {
    _imgUser = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("mealList").document(widget.mindexing);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        _image1 = snapshot.data["_image1"];
        _image2 = snapshot.data["_image2"];
        _image3 = snapshot.data["_image3"];
        _image4 = snapshot.data["_image4"];
        _image5 = snapshot.data["_image5"];
        _image6 = snapshot.data["_image6"];
        tansu = snapshot.data["tansu"];
        danback = snapshot.data["danback"];
        jibang = snapshot.data["jibang"];
        vitamin = snapshot.data["vitamin"];
        moogi = snapshot.data["moogi"];
        water = snapshot.data["water"];
        pic1 = snapshot.data["pic1"];
        pic2 = snapshot.data["pic2"];
        pic3 = snapshot.data["pic3"];
        pic4 = snapshot.data["pic4"];
        pic5 = snapshot.data["pic5"];
        pic6 = snapshot.data["pic6"];
        pic1n = snapshot.data["pic1n"];
        pic2n = snapshot.data["pic2n"];
        pic3n = snapshot.data["pic3n"];
        pic4n = snapshot.data["pic4n"];
        pic5n = snapshot.data["pic5n"];
        pic6n = snapshot.data["pic6n"];
        mindexing = snapshot.data["mindexing"];
      });
    });
  }


  @override
  void initState() {
    super.initState();
    getUser();
    _prepareService();
  }

  void _prepareService() async {
    _imgUser = await _firebaseAuth.currentUser();
  }

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
                    MaterialPageRoute(builder: (context) => HelpPage()));
              },
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "식사를 ",
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage('assets/oneline.png'),
                  height: 50.0,
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 45,
                            height: 45,
                            child: Image.asset('assets/rice_green.png'),
                            //color: Colors.white,
                          ),
                          Container(
                            height: 10.0,
                          ),
                          Container(
                            child: Text(
                              '우리들의 식단',
                              style: TextStyle(
                                color: Color(0xff53975c),
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
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      child: Text(
                          "친구들이 만든 식단은 어떨까요?\n가정에서도, 영양 선생님도 보시고응원해 주세요.",
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontFamily: "Arita-dotum-_OTF",
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      width: 350.0,
                      height: 270.0,
                      decoration: BoxDecoration(
                        color: Color(0xfff2f2f2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _smallImageItem(getGalleryImage1, _image1, pic1n, "one"),
                                _smallImageItem(getGalleryImage2, _image2, pic2n, "two"),
                                _smallImageItem(getGalleryImage3, _image3, pic3n, "three"),
                                _smallImageItem(getGalleryImage4, _image4, pic4n, "four"),
                              ],
                            ),
                          ),
                          Container(
                            height: 10.0,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _bigImageItem(getGalleryImage5, _image5, pic5n, "five"),
                                _bigImageItem(getGalleryImage6, _image6, pic6n, "six"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 20.0,
                          ),
                          Container(
                            width: 100.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: const Color(0xfffbb359)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '영양소 확인',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Arita-dotum-_OTF",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            width: 300.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xfffbb359)
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _nutrients(tansu, "탄수화물"),
                                    _nutrients(danback, "단백질"),
                                    _nutrients(jibang, "지방"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _nutrients(vitamin, "비타민"),
                                    _nutrients(moogi, "무기질"),
                                    _nutrients(water, "물"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 10.0,),
                    Container(
                      width: 300.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Color(0xfffff7ef),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                      ),
                      child: GestureDetector(
                        child: _wPBuildConnectItem('assets/itda_orange.png', '잇기(올리기)'),
                        onTap: () async{
                          await Firestore.instance.collection('mealList').document(mindexing)
                              .setData({'email':email, 'nickname':nickname, 'school':school, 'clas':clas, 'grade':grade, 'mindexing':mindexing,
                            'tansu':tansu, 'danback':danback, 'jibang': jibang, 'vitamin' : vitamin, 'moogi' : moogi, 'water' : water,
                            'pic1' : _ImageURL1, 'pic2' : _ImageURL2, 'pic3' : _ImageURL3, 'pic4' : _ImageURL4, 'pic5' : _ImageURL5, 'pic6' : _ImageURL6,
                            'pic1n' : pic1n, 'pic2n' : pic2n, 'pic3n' : pic3n, 'pic4n' : pic4n, 'pic5n' : pic5n, 'pic6n' : pic6n,});
                          email = ''; nickname = ''; school = ''; clas = ''; grade = ''; mindexing = '';
                          tansu = false; danback = false; jibang = false; vitamin = false; moogi = false; water = false;
                          pic1 = ''; pic2 = ''; pic3 = ''; pic4 = ''; pic5 = ''; pic6 = '';
                          pic1n = ''; pic2n = ''; pic3n = ''; pic4n = ''; pic5n = ''; pic6n = '';
                          mindex = mindex + 1;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MealList()));
                        },
                      ),
                    ),
                    Container(height: 10.0,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void getGalleryImage1() async {
    File image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    //var image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image1 == null) return;
    setState(() {
      _image1 = image1;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}1_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image1);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL1 = downloadURL;
    });
  }
  void getGalleryImage2() async {
    File image2 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    if(image2 == null) return;
    setState(() {
      _image2 = image2;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}2_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image2);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL2 = downloadURL;
    });
  }
  void getGalleryImage3() async {
    File image3 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    if(image3 == null) return;
    setState(() {
      _image3 = image3;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}3_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image3);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL3 = downloadURL;
    });
  }
  void getGalleryImage4() async {
    File image4 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    if(image4 == null) return;
    setState(() {
      _image4 = image4;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}4_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image4);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL4 = downloadURL;
    });
  }
  void getGalleryImage5() async {
    File image5 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    if(image5 == null) return;
    setState(() {
      _image5 = image5;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}5_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image5);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL5 = downloadURL;
    });
  }
  void getGalleryImage6() async {
    File image6 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    if(image6 == null) return;
    setState(() {
      _image6 = image6;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}6_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image6);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL6 = downloadURL;
    });
  }
  Widget _wPBuildConnectItem( String wPimgPath, String wPlinkName) {
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
  Widget _smallImageItem(Function gettingImg, File sImgPath, String sImgName, String i){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: gettingImg,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Container(
                    height: 80.0,
                    width: 80.0,
                    child: sImgPath == null ?
                    Container(child: Image.asset('assets/add_photo.png'),)
                        : Image.file(sImgPath),
                    decoration: BoxDecoration(
                      color: Color(0xffd1dad5),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Container(
                    height: 30.0,
                    width: 80.0,
                    child: TextFormField(
                      maxLines: 1,
                      //onChanged: (text) => sImgName = text,
                      onChanged: (String value) {
                        setState(() {
                          switch(i){
                            case "one":
                              pic1n = value;
                              break;
                            case "two" :
                              pic2n = value;
                              break;
                            case "three" :
                              pic3n = value;
                              break;
                            case "four" :
                              pic4n = value;
                              break;
                          }
                        });
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _bigImageItem(Function gettingImg, File bImgPath, String bImgName, String i){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: gettingImg,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    child: bImgPath == null ?
                    Container(child: Image.asset('assets/add_photo.png'),)
                        : Image.file(bImgPath),
                    decoration: BoxDecoration(
                      color: Color(0xffd1dad5),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Container(
                    height: 30.0,
                    width: 100.0,
                    child: TextFormField(
                      maxLines: 1,
                      onChanged: (String value) {
                        setState(() {
                          switch(i){
                            case "five":
                              pic5n = value;
                              break;
                            case "six" :
                              pic6n = value;
                              break;
                          }
                        });
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _nutrients(bool nuVal, String nuName){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: nuVal,
          onChanged: (bool value) {
            setState(() {
              switch(nuName){
                case "탄수화물" :
                  tansu = value;
                  break;
                case "단백질" :
                  danback = value;
                  break;
                case "지방" :
                  jibang = value;
                  break;
                case "비타민" :
                  vitamin = value;
                  break;
                case "무기질" :
                  moogi = value;
                  break;
                case "물" :
                  water = value;
                  break;
              }
            });
          },
        ),
        Text(nuName,
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}