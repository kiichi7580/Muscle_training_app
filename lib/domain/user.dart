class User {
  final String email;
  final String uid;
  final DateTime createAt;

  const User({
    required this.email,
    required this.uid,
    required this.createAt,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'createAt': createAt,
      };
}
