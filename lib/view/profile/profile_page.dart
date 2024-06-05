// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/models/profile_model/user_data_model/user_data_model.dart';
import 'package:muscle_training_app/resources/profile_firestore_methods.dart';
import 'package:muscle_training_app/util/pickImage.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:muscle_training_app/view/profile/account_setting_page.dart';
import 'package:muscle_training_app/view/profile/edit_profile_page.dart';
import 'package:muscle_training_app/view/profile/training_frequency_visualization.dart';
import 'package:muscle_training_app/view/profile/user_relations/user_relations_tab_page.dart';
import 'package:muscle_training_app/view/profile/user_search_page.dart';
import 'package:muscle_training_app/view/profile/widgets/follow_button.dart';
import 'package:muscle_training_app/view/profile/widgets/open_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.uid,
  });
  final String uid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _image;
  DateTime today = DateTime.now();
  String uid = '';
  String username = '';
  late int kMaxDaysInMonth;
  late List<String> targetMonthDateList = [];
  late UserDataModel userDataModel;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    getNumberOfDaysInThisMonth(today.month);
    userDataModel = UserDataModel(uid)..fetchUserData();
  }

  @override
  void dispose() {
    userDataModel.dispose();
    super.dispose();
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

  getNumberOfDaysInThisMonth(int index) {
    kMaxDaysInMonth = DateTime(today.year, index + 1, 0).day;
    String day = '';
    final selectedDate = DateTime(today.year, index);
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
    return ChangeNotifierProvider<UserDataModel>.value(
      value: userDataModel,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            username,
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
        body: Center(
          child: Consumer<UserDataModel>(
            builder: (context, model, child) {
              final Map<dynamic, dynamic>? userData = model.userData;
              print('プロフィールuserData: $userData');

              if (userData == null) {
                return Center(
                  child: CircularProgressIndicator(
                    color: linkBlue,
                  ),
                );
              }
              String photoUrl =
                  userData['photoUrl']?.toString() ?? defaultPhotoUrlString;
              username = model.username;
              return model.getIsLoading
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
                                        photoUrl == defaultPhotoUrlString
                                            ? InkWell(
                                                onTap: () async {
                                                  await imageDialog(
                                                    context,
                                                    photoUrl,
                                                  );
                                                },
                                                child: CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage: AssetImage(
                                                    photoUrl,
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  await imageDialog(
                                                    context,
                                                    photoUrl,
                                                  );
                                                },
                                                child: CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage: NetworkImage(
                                                    photoUrl,
                                                  ),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                                                context: context,
                                                userData: userData,
                                                num: model.consecutiveLoginDays,
                                                label: '連続ログイン',
                                              ),
                                              buildStateColumn(
                                                context: context,
                                                userData: userData,
                                                num: model.followers,
                                                label: 'フォロワー',
                                              ),
                                              buildStateColumn(
                                                context: context,
                                                userData: userData,
                                                num: model.following,
                                                label: 'フォロー中',
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              FirebaseAuth.instance.currentUser!
                                                          .uid ==
                                                      widget.uid
                                                  ? FollowButton(
                                                      text: 'プロフィールを編集',
                                                      backgroundColor:
                                                          blackColor,
                                                      textColor: mainColor,
                                                      borderColor: greyColor,
                                                      function: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditProfilePage(
                                                                    user:
                                                                        userData),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : model.isFollowing
                                                      ? FollowButton(
                                                          text: 'フォロー解除',
                                                          backgroundColor:
                                                              mainColor,
                                                          textColor: blackColor,
                                                          borderColor:
                                                              greyColor,
                                                          function: () async {
                                                            await ProfileFireStoreMethods()
                                                                .followUser(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              userData['uid'],
                                                            );

                                                            model
                                                                .userUnFollow();
                                                            model.followers--;
                                                          },
                                                        )
                                                      : FollowButton(
                                                          text: 'フォロー',
                                                          backgroundColor:
                                                              blueColor,
                                                          textColor: mainColor,
                                                          borderColor:
                                                              blueColor,
                                                          function: () async {
                                                            await ProfileFireStoreMethods()
                                                                .followUser(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              userData['uid'],
                                                            );

                                                            model.userFollow();

                                                            model.followers++;
                                                          },
                                                        ),
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
                                    username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                buildTermGoals(
                                  userData['shortTermGoals'] ?? '',
                                  userData['longTermGoals'] ?? '',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        SizedBox(
                          height: 32,
                        ),
                        Container(
                          child: CarouselSlider.builder(
                            itemCount: model.months.length,
                            options: CarouselOptions(
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              aspectRatio: 16 / 9,
                              height: 400.0,
                              viewportFraction: 0.9,
                              initialPage: model.initialPageIndex,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                final month = model.months[index];
                                getNumberOfDaysInThisMonth(month);
                              },
                            ),
                            itemBuilder: (context, index, realIndex) {
                              // 月に基づくウィジェットの作成
                              final month = model.months[index];

                              return buildBody(
                                month,
                                targetMonthDateList,
                                model.trainingDays,
                                model.amountOfTraining,
                              );
                            },
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  GestureDetector buildStateColumn({
    required BuildContext context,
    required Map<dynamic, dynamic> userData,
    required int num,
    required String label,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserRelationsTabPage(userData: userData),
          ),
        );
      },
      child: Column(
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
      ),
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
