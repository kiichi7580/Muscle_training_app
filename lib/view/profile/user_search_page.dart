import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/profile/profile_page.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({Key? key}) : super(key: key);

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('1: $isShowUsers');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.cancel, color: greyColor),
                onPressed: () => searchController.clear(),
              ),
              hintText: 'ユーザー名を検索',
              hintStyle: const TextStyle(color: greyColor),
              prefixIcon: const Icon(
                Icons.search,
                color: greyColor,
              ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onFieldSubmitted: (String _) {
              print('2: $isShowUsers');
              setState(() {
                isShowUsers = true;
              });
              print(_);
              print(searchController.text);
            },
          ),
        ),
      ),
      backgroundColor: secondaryColor,
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          // backgroundImage: NetworkImage(
                          backgroundImage: AssetImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Column(
                children: [
                  Text(
                    'ユーザーを検索中です',
                    style: TextStyle(
                      color: blackColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CircularProgressIndicator(
                    color: linkBlue,
                  ),
                ],
              ),
            ),
    );
  }
}
