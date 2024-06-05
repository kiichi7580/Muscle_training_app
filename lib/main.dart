// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:muscle_training_app/models/menu_model/menu_model.dart';
import 'package:muscle_training_app/providers/auth_check_page.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'firebase_options.dart';

void main() async {
  // Firebaseの初期化
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Firebaseの初期化に失敗した場合のエラーハンドリング追記予定
    return;
  }

  // RiverpodのProviderScopeを定義
  final scope = riverpod.ProviderScope(
    child: MyApp(),
  );

  // カレンダーパッケージを使用するための記述
  await initializeDateFormatting().then((_) => runApp(scope));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MenuModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          // クパチーノウジェットを日本語化
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ja'),
        ],
        locale: Locale('ja'),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData.dark(),
        // home: StreamBuilder<User?>(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.active) {
        //       if (snapshot.hasData) {
        //         // User が null でなない、つまりサインイン済みのホーム画面へ
        //         return const ResponsiveLayout(
        //           webScreenLayout: WebScreenLayout(),
        //           mobileScreenLayout: MobileScreenLayout(),
        //         );
        //       } else if (snapshot.hasError) {
        //         return Center(
        //           child: Text('${snapshot.error}'),
        //         );
        //       } else {
        //         // User がnullの場合、ログイン画面へ
        //         return LoginPage();
        //       }
        //     }
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const SizedBox();
        //     }
        //     return const LoginPage();
        //   },
        // ),
        home: AuthCheckPage(),
      ),
    );
  }
}
