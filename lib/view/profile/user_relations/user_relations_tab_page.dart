import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/profile/user_relations/user_following_list_page.dart';
import 'package:muscle_training_app/view/profile/user_relations/user_followers_list_page.dart';

class UserRelationsTabPage extends StatefulWidget {
  const UserRelationsTabPage({
    super.key,
    required this.userData,
  });
  final Map<dynamic, dynamic> userData;

  @override
  State<UserRelationsTabPage> createState() => _UserRelationsTabPageState();
}

class _UserRelationsTabPageState extends State<UserRelationsTabPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.userData['username'],
          style: TextStyle(
            color: blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          indicatorColor: heavyBlueColor,
          dividerColor: Colors.white70,
          dividerHeight: 48,
          labelStyle: TextStyle(
            color: heavyBlueColor,
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'フォロワー',
            ),
            Tab(
              text: 'フォロー中',
            ),
          ],
        ),
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: buildTabBarView(_tabController),
          ),
        ],
      ),
    );
  }

  Widget buildTabBarView(TabController tabController) {
    return TabBarView(
      controller: tabController,
      children: [
        UserFollowersListPage(userData: widget.userData)
            .UserFollowersList(widget.userData),
        UserFollowingListPage(userData: widget.userData)
            .UserFollowingList(widget.userData),
      ],
    );
  }
}
