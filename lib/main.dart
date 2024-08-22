import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whitematrix/controller/authcontroller.dart';
import 'package:whitematrix/controller/cartcontroller.dart';
import 'package:whitematrix/controller/favcontroller.dart';
import 'package:whitematrix/controller/logincontroller.dart';
import 'package:whitematrix/controller/ordercontroller.dart';
import 'package:whitematrix/controller/otpcontroller.dart';
import 'package:whitematrix/controller/usercontroller.dart';
import 'package:whitematrix/firebase_options.dart';
import 'package:whitematrix/view/splashscreen/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Authcontroller(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cartcontroller(),
        ),
        ChangeNotifierProvider(
          create: (context) => Favoritecontroller(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginController(),
        ),
        ChangeNotifierProvider(
          create: (context) => Ordercontroller(),
        ),
        ChangeNotifierProvider(
            create: (context) => OtpVerificationController()),
        ChangeNotifierProvider(
          create: (context) => UserController(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SplashScreen(
                islogged: true,
              );
            } else {
              return SplashScreen(
                islogged: false,
              );
            }
          },
        ),
      ),
    );
  }
}
