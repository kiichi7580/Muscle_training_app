import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:muscle_training_app/auth.dart';

import 'firebase_options.dart';


void main() async {
  // firebaseの初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // riverpodを使用するための記述 scope
  const scope = ProviderScope(
    child: MaterialApp(
      home:  AuthPage(),),);

  // カレンダーパッケージを使用するための記述　initializeDateFormatting().then((_)
  await initializeDateFormatting().then((_) => runApp(scope));
}
