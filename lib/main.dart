import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:muscle_training_app/resposive/mobile_screen_layout.dart';
import 'package:muscle_training_app/resposive/resposive_layout.dart';
import 'package:muscle_training_app/resposive/web_screen_layout.dart';
import 'package:muscle_training_app/view/login/login_page.dart';

import 'firebase_options.dart';

void main() async {
  // firebaseの初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // riverpodを使用するための記述 scope
  final scope = ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData.dark(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // User が null でなない、つまりサインイン済みのホーム画面へ
              return const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          return const LoginPage();
        },
      ),
    ),
  );

  // カレンダーパッケージを使用するための記述　initializeDateFormatting().then((_)
  await initializeDateFormatting().then((_) => runApp(scope));
}
