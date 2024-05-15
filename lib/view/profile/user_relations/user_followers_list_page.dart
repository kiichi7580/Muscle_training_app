import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/models/profile_model/user_relations/user_followers_model.dart';
import 'package:muscle_training_app/view/profile/profile_page.dart';
import 'package:provider/provider.dart';

class UserFollowersListPage {
  const UserFollowersListPage({
    required this.userData,
  });
  final Map<dynamic, dynamic> userData;
  Widget UserFollowersList(Map<dynamic, dynamic> userData) {
    return ChangeNotifierProvider<UserFollowersModel>(
      create: (_) => UserFollowersModel(userData)..getFollowersInfo(),
      child: Scaffold(
        body: Center(
          child: Consumer<UserFollowersModel>(
            builder: (context, model, child) {
              final List<Map<dynamic, dynamic>>? userFollowers =
                  model.userFollowers;

              if (userFollowers == null) {
                return Center(
                  child: CircularProgressIndicator(
                    color: linkBlue,
                  ),
                );
              }

              if (userFollowers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: blackColor,
                        size: 45,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'フォロワーはいません',
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
                itemCount: userFollowers.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          uid: userFollowers[index]['uid'],
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: userFollowers[index]['photoUrl'] ==
                              defaultPhotoUrlString
                          ? CircleAvatar(
                              backgroundImage: AssetImage(
                                userFollowers[index]['photoUrl'],
                              ),
                              radius: 16,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                userFollowers[index]['photoUrl'],
                              ),
                              radius: 16,
                            ),
                      title: Text(
                        userFollowers[index]['username'],
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
