import 'package:accountant/domain/foxway_credentials.dart';
import 'package:accountant/presentation/pages/home/screens/employee_screen.dart';
import 'package:accountant/presentation/pages/home/screens/manager_screen.dart';
import 'package:accountant/presentation/pages/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //CONTROLLERS

  ///
  String title = "Foxway";

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    //CONTROLLERS

    if (FirebaseAuth.instance.currentUser!.email ==
        FoxwayCredentials.managerEmail) {
      title = "Boshqaruvchi";
    } else {
      title = "FOXWAY";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 4,
        leadingWidth: kToolbarHeight + 20.w,
        toolbarHeight: kToolbarHeight + 20.h,
        leading: SizedBox(
          height: 160.0,
          width: 160.w,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/logo.png", fit: BoxFit.fill),
          ),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout, color: Colors.white))
        ],
      ),
      body: FirebaseAuth.instance.currentUser!.email ==
              FoxwayCredentials.managerEmail
          ? const ManagerScreen()
          : const EmployeeScreen(),
    );
  }

  void showLogoutDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Haqiqatdan tizimdan chiqmoqchimisiz?"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yo'q")),
              ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SplashScreen())));
                  },
                  child: const Text("Ha"))
            ],
          );
        });
  }
}
// Container(
//             height: 80.h,
//             width: double.infinity,
//             decoration: const BoxDecoration(
//                 color: Colors.amber,
//                 boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)]),
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("Umumiy qoldiq:",
//                       style: TextStyle(
//                           fontSize: 20.0,
//                           fontStyle: FontStyle.italic,
//                           color: Colors.white)),
//                   SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                             "${totalSumUzs.toString().pickOnlyNumbers().formatMoney()} UZS",
//                             style: const TextStyle(
//                                 fontSize: 20.0, color: Colors.white)),
//                         Text(
//                             "${totalSumUsd.toString().pickOnlyNumbers().formatMoney()} USD",
//                             style: const TextStyle(
//                                 fontSize: 20.0, color: Colors.white)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ))