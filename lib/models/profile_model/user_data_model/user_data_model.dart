// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataModel extends ChangeNotifier {
  UserDataModel(this.uid) {
    this.uid = uid;
  }
  String uid = '';
  Map<dynamic, dynamic> userData = {};
  int followers = 0;
  int following = 0;
  int consecutiveLoginDays = 0;

  DateTime oldestDate = DateTime.now();
  DateTime newestDate = DateTime.now();
  List<int> months = [];
  int initialPageIndex = 0;
  Map<dynamic, dynamic> userTrainingData = {};
  List<String> trainingDays = [];
  List<int> amountOfTraining = [];

  bool isLoding = false;
  bool get getIsLoading => isLoding;
  bool isFollowing = false;
  bool get getIsFollowing => isFollowing;
  String username = '';
  String get getUsername => username;

  void startLoding() {
    isLoding = true;
    notifyListeners();
  }

  void endLoding() {
    isLoding = false;
    notifyListeners();
  }

  void userFollow() {
    isFollowing = true;
    notifyListeners();
  }

  void userUnFollow() {
    isFollowing = false;
    notifyListeners();
  }

  void setUserName(String username) {
    this.username = username;
    notifyListeners();
  }

  void setFollowerStatus(DocumentSnapshot<Map<String, dynamic>> userSnap) {
    this.isFollowing = userSnap
        .data()!['followers']
        .contains(FirebaseAuth.instance.currentUser!.uid);
    notifyListeners();
  }

  void setInitialPageIndex(List<int> months) {
    this.initialPageIndex = months.isNotEmpty ? months.last - 1 : 0;
    notifyListeners();
  }

  void setTrainingDays(dynamic data) {
    String day = '';
    // トレーニングした日付を取得
    Timestamp trainingDayTimestamp = data;
    DateTime trainingDay = trainingDayTimestamp.toDate();
    day = '${trainingDay.month}/${trainingDay.day}';
    this.trainingDays.add(day);
    notifyListeners();
  }

  void setAmountOfTraining(dynamic data) {
    // トレーニング量を取得
    int _amount = data;
    this.amountOfTraining.add(_amount);
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    startLoding();
    late var userSnap;
    if (this.uid == FirebaseAuth.instance.currentUser!.uid) {
      userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
    } else {
      userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(this.uid)
          .get();
    }
    var trainingSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('trainingDays')
        .get();

    this.userData = userSnap.data()!;

    setUserName(userSnap.data()!['username']);

    // trainingSnapからデータをMap<String, dynamic>に変換する
    trainingSnap.docs.forEach((doc) {
      this.userTrainingData[doc.id] = doc.data();
    });
    print('userTrainingData: ${this.userTrainingData}');

    this.userTrainingData.forEach((documentId, data) {
      if (data.containsKey('trainingDay')) {
        setTrainingDays(data['trainingDay']);
        setAmountOfTraining(data['amountOfTraining']);

        // メモしたことのある月と月の間の全ての月を取得するリストを作成
        // 最も古い日付と最も新しい日付を見つける
        DateTime date = (data['trainingDay'] as Timestamp).toDate();
        if (date.isBefore(oldestDate)) {
          oldestDate = date;
        }
        if (date.isAfter(newestDate)) {
          newestDate = date;
        }
      }
    });

    // 最も古い日付から最も新しい日付までの間の月を取得し、リストに追加
    DateTime currentDate = DateTime(oldestDate.year, oldestDate.month);
    List<int> _months = [];
    while (currentDate.isBefore(newestDate)) {
      _months.add(currentDate.month);
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }
    // 月のリストをソートして返す
    _months.sort();
    this.months = _months;
    setInitialPageIndex(this.months);

    this.followers = userSnap.data()!['followers'].length;
    this.following = userSnap.data()!['following'].length;

    setFollowerStatus(userSnap);

    this.consecutiveLoginDays = userSnap.data()!['consecutiveLoginDays'] as int;

    notifyListeners();
    endLoding();
  }
}
