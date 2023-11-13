import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:audioplayers/audioplayers.dart';


class MemoAddPage extends StatelessWidget {

  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('books').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ追加'),
        leading: TextButton(
          onPressed: () {
            // 元の画面に戻る
            Navigator.pop(context);
            },
          child: Text('戻る',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }


              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['title'] as String),
                    subtitle: Text(data['author']as String),
                  );
                }).toList(),
              );
            },
          )
      ),
    );
    // floatingActionButton:FloatingActionButton(
    //   onPressed: () {
        // メモ追加の画面に遷移
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => )
        // )
      // }
      // tooltip: '新しいメモを追加',


    // );
  }
}