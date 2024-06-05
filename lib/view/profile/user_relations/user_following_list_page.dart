// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/models/profile_model/user_relations/user_following_model.dart';
import 'package:muscle_training_app/view/profile/profile_page.dart';

class UserFollowingListPage {
  const UserFollowingListPage({
    required this.userData,
  });
  final Map<dynamic, dynamic> userData;
  Widget UserFollowingList() {
    return ChangeNotifierProvider<UserFollowingModel>(
      create: (_) => UserFollowingModel(userData)..getFollowingInfo(),
      child: Scaffold(
        body: Center(
          child: Consumer<UserFollowingModel>(
            builder: (context, model, child) {
              final List<Map<dynamic, dynamic>>? userFollowing =
                  model.userFollowing;

              if (userFollowing == null) {
                return Center(
                  child: CircularProgressIndicator(
                    color: linkBlue,
                  ),
                );
              }

              if (userFollowing.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add,
                        color: blackColor,
                        size: 45,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '他のユーザーをフォローしましょう',
                        style: TextStyle(
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                itemCount: userFollowing.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          uid: userFollowing[index]['uid'],
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: userFollowing[index]['photoUrl'] ==
                              defaultPhotoUrlString
                          ? CircleAvatar(
                              backgroundImage: AssetImage(
                                userFollowing[index]['photoUrl'],
                              ),
                              radius: 16,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                userFollowing[index]['photoUrl'],
                              ),
                              radius: 16,
                            ),
                      title: Text(
                        userFollowing[index]['username'],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
