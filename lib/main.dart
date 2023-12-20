import 'package:accountant/application/client/client_cubit.dart';
import 'package:accountant/application/login/login_cubit.dart';
import 'package:accountant/firebase_options.dart';
import 'package:accountant/presentation/pages/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kWebRecaptchaSiteKey = '6Lemcn0dAAAAABLkf6aiiHvpGD6x-zF3nOSDU2M8';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  await FirebaseAppCheck.instance
      // Your personal reCaptcha public key goes here:
      .activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
  );

  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => LoginCubit()),
    BlocProvider(create: (context) => ClientCubit()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return const MaterialApp(
          // theme: ThemeData(
          //     inputDecorationTheme: const InputDecorationTheme(
          //   border: OutlineInputBorder(
          //       borderSide: BorderSide(color: Colors.transparent)),
          //   enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(color: Colors.transparent)),
          //   focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(color: Colors.transparent)),
          //   errorBorder:
          //       OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          // )),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
      designSize: const Size(378, 815),
    );
  }
}
