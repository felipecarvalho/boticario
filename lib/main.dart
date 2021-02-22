import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:boticario/providers/global/global.dart';
import 'package:boticario/views/signin/signin.dart';
import 'package:boticario/views/signup/signup.dart';
import 'package:boticario/utils/colors/colors.dart';
import 'package:boticario/views/tabs.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GlobalProvider(
      child: CupertinoApp(
        title: 'Boticário',
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          scaffoldBackgroundColor: DefaultSwatches.light,
          brightness: Brightness.light,
          primaryColor: DefaultSwatches.primary,
          textTheme: CupertinoTextThemeData(
            primaryColor: DefaultSwatches.primary,
            navActionTextStyle: TextStyle(
              color: DefaultSwatches.standard,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        routes: {
          '/home': (context) => AppTabs(),
          '/signup': (context) => SignUp(),
          '/signin': (context) => SignIn(),
        },
        initialRoute: '/',
        onGenerateRoute: (item) {
          if (item.name == "/logout") {
            return PageRouteBuilder(pageBuilder: (_, __, ___) => SignIn());
          }
          if (item.name == "/") {
            var data = Hive.box('global').get('loggedUser');
            if (data == null) {
              return PageRouteBuilder(pageBuilder: (_, __, ___) => SignIn());
            } else {
              return PageRouteBuilder(pageBuilder: (_, __, ___) => AppTabs());
            }
          }
          return null;
        },
      ),
    );
  }
}
