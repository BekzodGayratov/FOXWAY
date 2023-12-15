import 'package:accountant/application/login/login_cubit.dart';
import 'package:accountant/application/rent/rent_cubit.dart';
import 'package:accountant/firebase_options.dart';
import 'package:accountant/presentation/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => LoginCubit()),
    BlocProvider(create: (context) => RentCubit()),
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
