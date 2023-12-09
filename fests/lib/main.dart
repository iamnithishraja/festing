import 'package:fests/screens/auth/login.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fests/screens/auth/signup.dart';
import 'package:fests/screens/fests/adminScreens/createFest.dart';
import 'package:fests/screens/fests/userScreens/fest.dart';
import 'package:fests/widgets/tabs/tabs_conroller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './globals/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({super.key});

  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
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
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: AppTheme.darkTheme(),
      home: FutureBuilder(
        future: ref.watch(userProvider.notifier).tryAutoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
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
      routes: {
        Fests().route: (context) => Fests(),
        CreateFest().route: (context) => CreateFest(),
      },
    );
  }
}
