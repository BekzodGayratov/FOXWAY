import 'package:accountant/presentation/pages/auth/login_page.dart';
import 'package:accountant/presentation/pages/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_storage/get_storage.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _passwordController.addListener(() async {
      if (_passwordController.text.trim().length == 6) {
        final setPassword = await GetStorage().read('password');
        if (setPassword == _passwordController.text.trim()) {
          Future.delayed(Duration.zero).then((value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false);
          });
        } else {
          Future.delayed(Duration.zero).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 10),
                showCloseIcon: true,
                content: const Text(
                    "Parol noto'g'ri. \n\n AGAR PAROLNI UNUTGAN BO'LSANGIZ TIZIMGA QAYTA KIRISHINGIZ KERAK"),
                action: SnackBarAction(
                    label: "Tizimdan chiqish",
                    onPressed: () async {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      await FirebaseAuth.instance.signOut().then((value) =>
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (route) => false));
                    })));
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Shaxsiy parolni kiriting"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 100.h,
                width: 100.w,
                child: Image.asset("assets/logo.png", fit: BoxFit.fill)),
            Gap(100.h),
            TextFormField(
              autofocus: false,
              maxLines: 1,
              controller: _passwordController,
              readOnly: true,
              cursorColor: Colors.amber,
              cursorOpacityAnimates: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 10.0,
                  color: Colors.amber),
            ),
            Gap(20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 60.h,
                    width: 80.w,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.length < 6) {
                            _passwordController.text += "1";
                          }
                        },
                        child: const Text(
                          "1",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber),
                        ))),
                Gap(20.w),
                SizedBox(
                    height: 60.h,
                    width: 80.w,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.length < 6) {
                            _passwordController.text += "2";
                          }
                        },
                        child: const Text(
                          "2",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber),
                        ))),
                Gap(20.w),
                SizedBox(
                    height: 60.h,
                    width: 80.w,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.length < 6) {
                            _passwordController.text += "3";
                          }
                        },
                        child: const Text(
                          "3",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber),
                        ))),
              ],
            ),
            Gap(10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 60.h,
                    width: 80.w,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.length < 6) {
                            _passwordController.text += "4";
                          }
                        },
                        child: const Text(
                          "4",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber),
                        ))),
                Gap(20.w),
                SizedBox(
                    height: 60.h,
                    width: 80.w,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.length < 6) {
                            _passwordController.text += "5";
                          }
                        },
                        child: const Text(
                          "5",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber),
                        ))),
                Gap(20.w),
                SizedBox(
                    height: 60.h,
                    width: 80.w,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.length < 6) {
                            _passwordController.text += "6";
                          }
                        },
                        child: const Text(
                          "6",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber),
                        ))),
              ],
            ),
            Gap(10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 60.h,
                    width: 80.w,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.length < 6) {
                            _passwordController.text += "7";
                          }
                        },
                        child: const Text(
                          "7",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber),
                        ))),
                Gap(20.w),
                SizedBox(
                    height: 60.h,
                    width: 80.w,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.length < 6) {
                            _passwordController.text += "8";
                          }
                        },
                        child: const Text(
                          "8",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber),
                        ))),
                Gap(20.w),
                SizedBox(
                    height: 60.h,
                    width: 80.w,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.length < 6) {
                            _passwordController.text += "9";
                          }
                        },
                        child: const Text(
                          "9",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber),
                        ))),
              ],
            ),
            Gap(10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60.h,
                  width: 80.w,
                ),
                Gap(20.w),
                SizedBox(
                    height: 60.h,
                    width: 80.w,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.length < 6) {
                            _passwordController.text += "0";
                          }
                        },
                        child: const Text(
                          "0",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber),
                        ))),
                Gap(20.w),
                SizedBox(
                    height: 60.h,
                    width: 80.w,
                    child: ElevatedButton(
                        onPressed: () {
                          String originalString = _passwordController.text;
                          if (originalString.isNotEmpty) {
                            // Remove the last character
                            _passwordController.text = originalString.substring(
                                0, originalString.length - 1);
                          }
                        },
                        child: const Icon(Icons.arrow_circle_left_outlined,
                            color: Colors.amber))),
              ],
            ),
          ],
        ));
  }
}
