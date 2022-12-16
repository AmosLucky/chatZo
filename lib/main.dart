import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social_app/Utils/colors.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/responsive/mobile_screen_layout.dart';
import 'package:social_app/responsive/responsive_layout.dart';
import 'package:social_app/responsive/web_screen_layout.dart';
import 'package:social_app/screens/home.dart';
import 'package:social_app/screens/signin.dart';

import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  if (kIsWeb) {
    await Firebase.initializeApp(options: Config.firbaseOptions);
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: Main(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Social App",
      routes: {
        "Home": (_) => Home(),
      },
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      // home: ResponsiveLayout(
      //   webScreenLayout: WebScreenLayout(),
      //   mobileScreenLayout: MobileScreenLayout(),
      // ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (contex, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
              );
            }
            // else {
            //   return Center(
            //     child: Text('An error occoured: ${snapshot.error}'),
            //   );
            // }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SignIn();
        },
      ),
    );
  }
}
