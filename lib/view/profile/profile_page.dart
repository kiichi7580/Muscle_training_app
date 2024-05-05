import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/resources/profile_firestore_methods.dart';
import 'package:muscle_training_app/util/pickImage.dart';
import 'package:muscle_training_app/view/profile/account_setting_page.dart';
import 'package:muscle_training_app/view/profile/edit_profile_page.dart';
import 'package:muscle_training_app/view/profile/training_frequency_visualization.dart';
import 'package:muscle_training_app/view/profile/user_search_page.dart';
import 'package:muscle_training_app/view/profile/widgets/follow_button.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({
    super.key,
    required this.uid,
  });

  @override
  State<ProfilePage> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilePage> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  int consecutiveLoginDays = 0;
  bool isFollowing = false;
  bool isLoading = false;
  Uint8List? _image;
  DateTime today = DateTime.now();
  late int kMaxDaysInMonth;
  late List<String> targetMonthDateList = [];
  var userTrainingData = {};
  late List<String> trainingDays = [];
  List<int> amountOfTraining = [];

  @override
  void initState() {
    super.initState();
    getData();
    getNumberOfDaysInThisMonth();
  }

  Future<void> selectImage(BuildContext context) async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
    await upDateUserIcon(context);
  }

  Future<void> upDateUserIcon(BuildContext context) async {
    try {
      String res = await ProfileFireStoreMethods().upDateUserIcon(
        file: _image!,
        uid: widget.uid,
      );
      if (res == successRes) {
        res = successUpDate;
        showSnackBar(res, context);
      } else {
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var trainingSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('trainingDays')
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      // postLen = postSnap.docs.length;
      userData = userSnap.data()!;

      // trainingSnapからデータをMap<String, dynamic>に変換する
      trainingSnap.docs.forEach((doc) {
        userTrainingData[doc.id] = doc.data();
      });
      print('userTrainingData: $userTrainingData');

      String day = '';
      userTrainingData.forEach((documentId, data) {
        if (data.containsKey('trainingDay')) {
          // トレーニングした日付を取得
          Timestamp trainingDayTimestamp = data['trainingDay'];
          DateTime trainingDay = trainingDayTimestamp.toDate();
          day = '${trainingDay.month}/${trainingDay.day}';
          trainingDays.add(day);

          // トレーニング量を取得
          int _amountOfTraining = data['amountOfTraining'];
          amountOfTraining.add(_amountOfTraining);
        }
      });

      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      DateTime lastLogin = (userData['lastLogin'] as Timestamp).toDate();
      DateTime now = DateTime.now();

      // 連続ログイン日数を計算
      if (lastLogin.year == now.year &&
          lastLogin.month == now.month &&
          lastLogin.day == now.day - 1) {
        setState(() {
          consecutiveLoginDays = (userData['consecutiveLoginDays'] as int) + 1;
        });
      } else {
        setState(() {
          consecutiveLoginDays = 1; // 前日以降のログインがない場合はリセットして1日目とする
        });
      }
      setState(() {});
    } catch (e) {
      showSnackBar(
        'ユーザー情報の取得に失敗しました',
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  getNumberOfDaysInThisMonth() {
    kMaxDaysInMonth = DateTime(today.year, today.month + 1, 0).day;
    String day = '';
    final selectedDate = DateTime(today.year, today.month);
    List<String> _targetMonthDateList = [];
    for (var i = 0; i < kMaxDaysInMonth; i++) {
      final date = selectedDate.add(Duration(days: i));
      if (date.month != selectedDate.month) break;
      day = '${date.month}/${date.day}';
      _targetMonthDateList.add(day);
    }
    setState(() {
      targetMonthDateList = _targetMonthDateList;
    });
    print(targetMonthDateList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          userData['username'] != null ? userData['username'] : 'unknown',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserSearchPage(),
                ),
              );
            },
            icon: Icon(
              Icons.person_add,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettingPage(),
                ),
              );
            },
            icon: Icon(
              Icons.menu,
            ),
          ),
        ],
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: linkBlue,
              ),
            )
          : ListView(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                _image != null
                                    ? CircleAvatar(
                                        radius: 40,
                                        backgroundImage: MemoryImage(_image!),
                                      )
                                    : CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                          userData['photoUrl'],
                                        ),
                                      ),
                                Positioned(
                                  bottom: 2,
                                  left: 54,
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 3,
                                  left: 56,
                                  child: Container(
                                    height: 22,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      color: linkBlue,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 43,
                                  bottom: -10,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: mainColor,
                                      size: 16,
                                    ),
                                    onPressed: () async {
                                      await selectImage(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStateColumn(
                                          consecutiveLoginDays, '連続ログイン'),
                                      buildStateColumn(followers, 'フォロワー'),
                                      buildStateColumn(following, 'フォロー中'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uid
                                          ? FollowButton(
                                              text: 'プロフィールを編集',
                                              backgroundColor: blackColor,
                                              textColor: mainColor,
                                              borderColor: greyColor,
                                              function: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProfilePage(
                                                            user: userData),
                                                  ),
                                                );
                                              },
                                            )
                                          : isFollowing
                                              ? FollowButton(
                                                  text: 'フォロー解除',
                                                  backgroundColor: mainColor,
                                                  textColor: blackColor,
                                                  borderColor: greyColor,
                                                  function: () async {
                                                    await ProfileFireStoreMethods()
                                                        .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid'],
                                                    );

                                                    setState(() {
                                                      isFollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                )
                                              : FollowButton(
                                                  text: 'フォロー',
                                                  backgroundColor: blueColor,
                                                  textColor: mainColor,
                                                  borderColor: blueColor,
                                                  function: () async {
                                                    await ProfileFireStoreMethods()
                                                        .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid'],
                                                    );

                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: Text(
                            userData['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        buildTermGoals(
                          userData['shortTermGoals'],
                          userData['longTermGoals'],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 32,
                ),
                TrainingFrequencyVisualization().buildBody(
                  today,
                  targetMonthDateList,
                  trainingDays,
                  amountOfTraining,
                ),
              ],
            ),
    );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: greyColor,
            ),
          ),
        ),
      ],
    );
  }
}

Container buildTermGoals(
  String shortTermGoals,
  String longTermGoals,
) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(
      top: 1,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '短期目標: ',
              style: TextStyle(
                color: blackColor,
              ),
            ),
            Text(
              shortTermGoals,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '長期目標: ',
              style: TextStyle(
                color: blackColor,
              ),
            ),
            Text(
              longTermGoals,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
