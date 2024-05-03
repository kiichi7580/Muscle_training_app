import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  final String id;
  final String menuName;
  final String uid;

  const Menu({
    required this.id,
    required this.menuName,
    required this.uid,
  });

  static Menu fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Menu(
      id: snapshot['id'],
      menuName: snapshot['menuName'],
      uid: snapshot['uid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'menuName': menuName,
        'uid': uid,
      };
}
