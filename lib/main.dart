import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app.dart';

import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting().then((_) => runApp(MyApp()));
  // runApp(MyApp());
}

//   const app = MaterialApp(home: MyPage());
//   runApp(app);
//
// }
//
// class MyPage extends StatelessWidget {
//   const MyPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final button = ElevatedButton(
//         onPressed: () {},
//         child: const Text('サインインする'),
//     );
//   }
//
//   return Scaffold(
//       body: Center(child: button),
//   );
// }
