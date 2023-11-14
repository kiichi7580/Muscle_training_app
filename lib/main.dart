import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

import 'package:intl/date_symbol_data_local.dart';


void main() async {
  // firebaseの初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // riverpodを使用するための記述　scope
  const scope = ProviderScope(child: MaterialApp(home: Myapp()));

  // カレンダーパッケージを使用するための記述　initializeDateFormatting().then((_)
  initializeDateFormatting().then((_) => runApp(scope));
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
