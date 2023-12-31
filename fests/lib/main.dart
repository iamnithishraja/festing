import 'package:fests/firebase_options.dart';
import 'package:fests/screens/auth/changePassword.dart';
import 'package:fests/screens/auth/login.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fests/screens/auth/signup.dart';
import 'package:fests/screens/others/splashScreen.dart';
import 'package:fests/utils/notificationPusher.dart';
import 'package:fests/widgets/tabs/tabs_conroller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './globals/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(ProviderScope(child: MyApp()));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNotificationManager().initNotification();
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({super.key});

  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp>
    with SingleTickerProviderStateMixin {
  void _switchLoginSignUp() {
    setState(() {
      if (currScreen == "login") {
        currScreen = "signup";
      } else {
        currScreen = "login";
      }
    });
  }

  String currScreen = "login";
  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => FutureBuilder(
            future: ref.watch(userProvider.notifier).tryAutoLogin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              if (ref.watch(userProvider) == null) {
                return currScreen == "login"
                    ? Login(
                        callBack: _switchLoginSignUp,
                      )
                    : SignUp(
                        callBack: _switchLoginSignUp,
                      );
              }
              return DefaultTabController(
                length: 4,
                child: Menu(),
                initialIndex: 0,
              );
            },
          ),
          routes: [
            GoRoute(
              path: "password/reset/:id",
              builder: (context, state) =>
                  ChangePassword(state.pathParameters["id"]),
            )
          ],
        ),
      ],
    );
    return MaterialApp.router(
      themeMode: ThemeMode.dark,
      theme: AppTheme.darkTheme(),
      routerConfig: router,
    );
  }
}
