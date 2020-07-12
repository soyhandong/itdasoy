import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itda/writePoem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itda/writeStory.dart';

class ReadStory extends StatefulWidget {
  @override
  _ReadStoryState createState() => _ReadStoryState();
}

class _ReadStoryState extends State<ReadStory> {
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
      body: _list(),
    );
  }
  Widget _list () {
    return StreamBuilder<QuerySnapshot>(
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
    );
  }
}