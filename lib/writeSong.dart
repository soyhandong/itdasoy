//https://here4you.tistory.com/235
//https://www.youtube.com/watch?v=VuVe-319WH4
//https://github.com/doyle-flutter/Recipe/blob/master/RecorderAppLocalFile.dart

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data' show Uint8List;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';

import 'package:itda/help.dart';

enum Media { file, buffer, asset, stream, remoteExampleFile, }
enum AudioState { isPlaying, isPaused, isStopped, isRecording, isRecordingPaused, }
final exampleAudioFilePath = "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3";
final albumArtPath = "https://file-examples.com/wp-content/uploads/2017/10/file_example_PNG_500kB.png";

class WriteSong extends StatefulWidget {
  @override
  _WriteSongState createState() => _WriteSongState();
}

class _WriteSongState extends State<WriteSong> {
  var ssubject, scontent, srecord;
  static int sindex = 1;
  String sindexing = "$sindex";

  Firestore _firestore = Firestore.instance;
  FirebaseUser user;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  int point = -1;
  dynamic data;
  final _formKey = GlobalKey<FormState>();

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

  bool _isRecording = false;
  List<String> _path = [null, null, null, null, null, null, null, null, null, null, null, null, null, null,];
  StreamSubscription _recorderSubscription;
  StreamSubscription _playerSubscription;

  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();

  String _recorderTxt = '00:00:00';
  String _playerTxt = '00:00:00';
  double _dbLevel;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  Media _media = Media.file;
  Codec _codec = Codec.aacADTS;

  bool _encoderSupported = true; // Optimist
  bool _decoderSupported = true; // Optimist

  // Whether the user wants to use the audio player features
  bool _isAudioPlayer = false;

  double _duration = null;

  File _music1;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _audioUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _audioURL1 = "";

  Future<void> _initializeExample(bool withUI) async {
    await playerModule.closeAudioSession();
    _isAudioPlayer = withUI;
    if (withUI) {
      await playerModule.openAudioSessionWithUI(focus: AudioFocus.requestFocusTransient, category: SessionCategory.playAndRecord, mode: SessionMode.modeDefault, device: AudioDevice.speaker);
    } else {
      await playerModule.openAudioSession( focus: AudioFocus.requestFocusTransient, category: SessionCategory.playAndRecord, mode: SessionMode.modeDefault, device: AudioDevice.speaker);
    }
    await playerModule.setSubscriptionDuration(Duration(milliseconds: 10));
    await recorderModule.setSubscriptionDuration(Duration(milliseconds: 10));
    initializeDateFormatting();
    setCodec(_codec);
  }

  Future<void> init() async {
    //playerModule = await FlutterSoundPlayer().openAudioSession();
    recorderModule.openAudioSession(focus: AudioFocus.requestFocusTransient, category: SessionCategory.playAndRecord, mode: SessionMode.modeDefault, device: AudioDevice.speaker);
    await _initializeExample(false);

    if (Platform.isAndroid) {
      copyAssets();
    }
  }

  Future<void> copyAssets() async {
    Uint8List dataBuffer = (await rootBundle.load("assets/canardo.png")).buffer.asUint8List();
    String path = await playerModule.getResourcePath() + "/assets";
    if (!await Directory(path).exists()) {
      await Directory(path).create(recursive: true);
    }
    await File(path + '/canardo.png').writeAsBytes(dataBuffer);
  }

  @override
  void initState() {
    super.initState();
    init();
    getUser();
  }

  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }
  }

  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelPlayerSubscriptions();
    cancelRecorderSubscriptions();
    releaseFlauto();
  }

  Future<void> releaseFlauto() async {
    try {
      await playerModule.closeAudioSession();
      await recorderModule.closeAudioSession();
    } catch (e) {
      print('Released unsuccessful');
      print(e);
    }
  }

  void startRecorder() async {
    try {
      // String path = await flutterSoundModule.startRecorder
      // (
      //   paths[_codec.index],
      //   codec: _codec,
      //   sampleRate: 16000,
      //   bitRate: 16000,
      //   numChannels: 1,
      //   androidAudioSource: AndroidAudioSource.MIC,
      // );
      // Request Microphone permission if needed
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException("Microphone permission not granted");
      }

      Directory tempDir = await getTemporaryDirectory();
      String path = '${tempDir.path}/${recorderModule.slotNo}-flutter_sound${ext[_codec.index]}';

      await recorderModule.startRecorder(
        toFile: path,
        codec: _codec,
        bitRate: 8000,
        sampleRate: 8000,
      );
      print('startRecorder');

      _recorderSubscription = recorderModule.onProgress.listen((e) {
        if (e != null && e.duration != null) {
          DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds, isUtc: true);
          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

          this.setState(() {
            _recorderTxt = txt.substring(0, 8);
            _dbLevel = e.decibels;
          });
        }
      });
      this.setState(() {
        this._isRecording = true;
        this._path[_codec.index] = path;
      });
    } catch (err) {
      print('startRecorder error: $err');
      setState(() {
        stopRecorder();
        this._isRecording = false;
        if (_recorderSubscription != null) {
          _recorderSubscription.cancel();
          _recorderSubscription = null;
        }
      });
    }
  }

  Future<void> getDuration() async {
    switch (_media) {
      case Media.file:
      case Media.buffer:
        Duration d = await flutterSoundHelper.duration(this._path[_codec.index]);
        _duration = d != null ? d.inMilliseconds / 1000.0 : null;
        break;
      case Media.asset:
        _duration = null;
        break;
      case Media.remoteExampleFile:
        _duration = null;
        break;
    }
    setState(() {});
  }

  void stopRecorder() async {
    try {
      await recorderModule.stopRecorder();
      print('stopRecorder');
      cancelRecorderSubscriptions();
      getDuration();
    } catch (err) {
      print('stopRecorder error: $err');
    }
    this.setState(() {
      this._isRecording = false;
    });
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  // In this simple example, we just load a file in memory.This is stupid but just for demonstration  of startPlayerFromBuffer()
  Future<Uint8List> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      File file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();
      print('The file is ${contents.length} bytes long.');
      return contents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<String> assetSample = ['assets/samples/sample.aac', 'assets/samples/sample.aac', 'assets/samples/sample.opus', 'assets/samples/sample_opus.caf',
    'assets/samples/sample.mp3', 'assets/samples/sample.ogg', 'assets/samples/sample.pcm', 'assets/samples/sample.wav', 'assets/samples/sample.aiff',
    'assets/samples/sample_pcm.caf', 'assets/samples/sample.flac', 'assets/samples/sample.mp4', 'assets/samples/sample.amr', // amrNB
    'assets/samples/sample.amr', // amrWB
  ];

  void _addListeners() {
    cancelPlayerSubscriptions();
    _playerSubscription = playerModule.onProgress.listen((e) {
      if (e != null) {
        maxDuration = e.duration.inMilliseconds.toDouble();
        if (maxDuration <= 0) maxDuration = 0.0;

        sliderCurrentPosition = min(e.position.inMilliseconds.toDouble(), maxDuration);
        if (sliderCurrentPosition < 0.0) {
          sliderCurrentPosition = 0.0;
        }

        DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.position.inMilliseconds, isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
        this.setState(() {
          this._playerTxt = txt.substring(0, 8);
        });
      }
    });
  }

  Future<void> startPlayer() async {
    try {
      //String path;
      Uint8List dataBuffer;
      String audioFilePath;
      if (_media == Media.asset) {
        dataBuffer = (await rootBundle.load(assetSample[_codec.index])).buffer.asUint8List();
      } else if (_media == Media.file) {
        // Do we want to play from buffer or from file ?
        if (await fileExists(_path[_codec.index])) audioFilePath = this._path[_codec.index];
      } else if (_media == Media.buffer) {
        // Do we want to play from buffer or from file ?
        if (await fileExists(_path[_codec.index])) {
          dataBuffer = await makeBuffer(this._path[_codec.index]);
          if (dataBuffer == null) {
            throw Exception('Unable to create the buffer');
          }
        }
      } else if (_media == Media.remoteExampleFile) {
        // We have to play an example audio file loaded via a URL
        audioFilePath = exampleAudioFilePath;
      }

      // Check whether the user wants to use the audio player features
      if (_isAudioPlayer) {
        String albumArtUrl;
        String albumArtAsset;
        String albumArtFile;
        if (_media == Media.remoteExampleFile)
          albumArtUrl = albumArtPath;
        else {
          albumArtFile = await playerModule.getResourcePath() + "/assets/canardo.png";
          print(albumArtFile);
        }

        final track = Track(
          trackPath: audioFilePath,
          dataBuffer: dataBuffer,
          trackTitle: "This is a record",
          trackAuthor: "from flutter_sound",
          albumArtUrl: albumArtUrl,
          albumArtAsset: albumArtAsset,
          albumArtFile: albumArtFile,
        );
        await playerModule.startPlayerFromTrack(track,
            /*canSkipForward:true, canSkipBackward:true,*/
            whenFinished: () {
              print('I hope you enjoyed listening to this song');
              setState(() {});
            }, onSkipBackward: () {
              print('Skip backward');
              stopPlayer();
              startPlayer();
            }, onSkipForward: () {
              print('Skip forward');
              stopPlayer();
              startPlayer();
            }, onPaused: (bool b) {
              if (b)
                playerModule.pausePlayer();
              else
                playerModule.resumePlayer();
            });
      } else {
        if (audioFilePath != null) {
          await playerModule.startPlayer(
              fromURI: audioFilePath,
              codec: _codec,
              whenFinished: () {
                print('Play finished');
                setState(() {});
              });
        } else if (dataBuffer != null) {
          await playerModule.startPlayer(
              fromDataBuffer: dataBuffer,
              codec: _codec,
              whenFinished: () {
                print('Play finished');
                setState(() {});
              });
        }
      }
      _addListeners();
      print('startPlayer');
      // await flutterSoundModule.setVolume(1.0);
    } catch (err) {
      print('error: $err');
    }
    setState(() {});
  }

  Future<void> stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      print('stopPlayer');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
    } catch (err) {
      print('error: $err');
    }
    this.setState(() {
      //this._isPlaying = false;
    });
  }

  void pauseResumePlayer() {
    if (playerModule.isPlaying) {
      playerModule.pausePlayer();
    } else {
      playerModule.resumePlayer();
    }
  }

  void pauseResumeRecorder() {
    if (recorderModule.isPaused) {
      recorderModule.resumeRecorder();
    } else {
      recorderModule.pauseRecorder();
    }
  }

  void seekToPlayer(int milliSecs) async {
    await playerModule.seekToPlayer(Duration(milliseconds: milliSecs));
    print('seekToPlayer');
  }

  void Function() onPauseResumePlayerPressed() {
    if (playerModule == null) return null;
    if (playerModule.isPaused || playerModule.isPlaying) {
      return pauseResumePlayer;
    }
    return null;
  }

  void Function() onPauseResumeRecorderPressed() {
    if (recorderModule == null) return null;
    if (recorderModule.isPaused || recorderModule.isRecording) {
      return pauseResumeRecorder;
    }
    return null;
  }

  void Function() onStopPlayerPressed() {
    if (playerModule == null) return null;
    return (playerModule.isPlaying || playerModule.isPaused) ? stopPlayer : null;
  }

  void Function() onStartPlayerPressed() {
    if (playerModule == null) return null;
    if (_media == Media.file || _media == Media.buffer) // A file must be already recorded to play it
        {
      if (_path[_codec.index] == null) return null;
    }
    if (_media == Media.remoteExampleFile && _codec != Codec.mp3) // in this example we use just a remote mp3 file
      return null;

    // Disable the button if the selected codec is not supported
    if (!_decoderSupported) return null;
    return (playerModule.isStopped) ? startPlayer : null;
  }

  void Function() startStopRecorder() {
    if (recorderModule.isRecording || recorderModule.isPaused)
      stopRecorder();
    else
      startRecorder();
  }

  void Function() onStartRecorderPressed() {
    //if (_media == t_MEDIA.ASSET || _media == t_MEDIA.BUFFER || _media == t_MEDIA.REMOTE_EXAMPLE_FILE) return null;
    // Disable the button if the selected codec is not supported
    if (recorderModule == null || !_encoderSupported) return null;
    return startStopRecorder;
  }

  AssetImage recorderAssetImage() {
    if (onStartRecorderPressed() == null) return AssetImage('res/icons/ic_mic_disabled.png');
    return (recorderModule.isStopped) ? AssetImage('res/icons/ic_mic.png') : AssetImage('res/icons/ic_stop.png');
  }

  void setCodec(Codec codec) async {
    _encoderSupported = await recorderModule.isEncoderSupported(codec);
    _decoderSupported = await playerModule.isDecoderSupported(codec);

    setState(() {
      _codec = codec;
    });
  }

  void musicUpload() async {
    File music1 = _media as File;
    DateTime nowtime = new DateTime.now();
    if(music1 == null) return;
    setState((){
      _music1 = music1;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("songfile/${_audioUser.uid}1_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_music1);
    StorageTaskSnapshot downloadUrl = (await storageUploadTask.onComplete);
    String url = (await downloadUrl.ref.getDownloadURL());
    print('URL is $url');
    _audioURL1 = url;
/*
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _audioURL1 = downloadURL;
    });
* */
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
              onPressed: () {
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
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                          '노래로 마음을 잇다',
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
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  height: 200.0,
                  decoration: BoxDecoration(
                      color: const Color(0xffe9f4eb)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _isRecording ? LinearProgressIndicator(value: 100.0 / 160.0 * (this._dbLevel ?? 1) / 100,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          backgroundColor: Colors.red)
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text('녹음하기'),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              this._recorderTxt,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            width: 40.0,
                            height: 40.0,
                            child: ClipOval(
                              child: FlatButton(
                                onPressed: onStartRecorderPressed(),
                                padding: EdgeInsets.all(8.0),
                                child: Image(
                                  image: recorderAssetImage(),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40.0,
                            height: 40.0,
                            child: ClipOval(
                              child: FlatButton(
                                onPressed: onPauseResumeRecorderPressed(),
                                disabledColor: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                child: Image(
                                  width: 36.0,
                                  height: 36.0,
                                  image: AssetImage(onPauseResumeRecorderPressed() != null ? 'res/icons/ic_pause.png' : 'res/icons/ic_pause_disabled.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text('녹음듣기'),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12.0, bottom: 16.0),
                            child: Text(
                              this._playerTxt,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            width: 40.0,
                            height: 40.0,
                            child: ClipOval(
                              child: FlatButton(
                                onPressed: onStartPlayerPressed(),
                                disabledColor: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                child: Image(
                                  image: AssetImage(onStartPlayerPressed() != null ? 'res/icons/ic_play.png' : 'res/icons/ic_play_disabled.png'),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40.0,
                            height: 40.0,
                            child: ClipOval(
                              child: FlatButton(
                                onPressed: onPauseResumePlayerPressed(),
                                disabledColor: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                child: Image(
                                  width: 36.0,
                                  height: 36.0,
                                  image: AssetImage(onPauseResumePlayerPressed() != null ? 'res/icons/ic_pause.png' : 'res/icons/ic_pause_disabled.png'),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40.0,
                            height: 40.0,
                            child: ClipOval(
                              child: FlatButton(
                                onPressed: onStopPlayerPressed(),
                                disabledColor: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                child: Image(
                                  width: 28.0,
                                  height: 28.0,
                                  image: AssetImage(onStopPlayerPressed() != null ? 'res/icons/ic_stop.png' : 'res/icons/ic_stop_disabled.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          height: 30.0,
                          child: Slider(
                              value: min(sliderCurrentPosition, maxDuration),
                              min: 0.0,
                              max: maxDuration,
                              onChanged: (double value) async {
                                await playerModule.seekToPlayer(Duration(milliseconds: value.toInt()));
                              },
                              divisions: maxDuration == 0.0 ? 1 : maxDuration.toInt())),
                      Container(
                        height: 30.0,
                        child: Text(_duration != null ? "Duration: $_duration sec." : ''),
                      ),

                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 430.0,
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
                              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                              width: 350.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: const Color(0x69e9f4eb)
                              ),
                              child: TextFormField(
                                maxLines: 1,
                                onChanged: (text) => ssubject = text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '제목을 쓰세요';
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '제목을 쓰세요',
                                  //labelText: "Enter your username",
                                ),
                              ),
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
                              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                              width: 350.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                  color: const Color(0x69e9f4eb)
                              ),
                              child: TextFormField(
                                maxLines: 30,
                                onChanged: (text) => scontent = text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '느낀점을 쓰세요';
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '느낀점을 쓰세요',
                                  //labelText: "Enter your username",
                                ),
                              ),
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
                              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                              width: 350.0,
                              height: 45.0,
                              decoration: BoxDecoration(
                                  color: const Color(0x69e9f4eb)
                              ),
                              child: TextFormField(
                                onChanged: (text) => srecord = text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '녹음을 하세요';
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '녹음을 하세요',
                                  //labelText: "Enter your username",
                                ),
                              ),
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
                        child: GestureDetector(
                          child: _wPBuildConnectItem('assets/itda_orange.png','잇기(올리기)'),
                          onTap: () async{
                            await Firestore.instance.collection('songList').document(sindexing).setData({'email':email, 'nickname':nickname, 'school':school, 'clas':clas, 'grade':grade, 'ssubject':ssubject, 'scontent':scontent, 'srecord': srecord, 'sindexing':sindexing});
                            email = ''; nickname = ''; school = ''; clas = ''; grade = ''; ssubject = ''; scontent = ''; srecord = ''; sindexing = '';
                            sindex = sindex + 1;
                            Navigator.pop(context);
                          },
                        ),
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
}
