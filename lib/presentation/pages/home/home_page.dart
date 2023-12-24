import 'package:accountant/domain/client_model.dart';
import 'package:accountant/domain/foxway_credentials.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/presentation/pages/home/screens/employee_screen.dart';
import 'package:accountant/presentation/pages/home/screens/manager_screen.dart';
import 'package:accountant/presentation/pages/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tenantNameController;
  late final TextEditingController _productTypeController;
  late final TextEditingController _phoneController;
  late final TextEditingController _priceController;
  late final TextEditingController _paidDebtController;
  late final TextEditingController _givenDateController;

  //
  late final CollectionReference<Map<String, dynamic>> clientCollection;

  ///
  String title = "Foxway";

  num totalSumUzs = 0.0;
  num totalSumUsd = 0.0;
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
      title = "Xodim";
    }

    clientCollection = FirebaseFirestore.instance.collection("clients");
    _tenantNameController = TextEditingController();
    _productTypeController = TextEditingController();
    _priceController = TextEditingController();
    _givenDateController = TextEditingController();

    _phoneController = TextEditingController();
    _paidDebtController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _productTypeController.dispose();
    _priceController.dispose();
    _givenDateController.dispose();
    _phoneController.dispose();
    _tenantNameController.dispose();
    _paidDebtController.dispose();

    super.dispose();
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 100.h),
        child: FloatingActionButton(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          onPressed: () async {
            await _showAddClientDialog(context);
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<dynamic> _showAddClientDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mijoz qo'shish",
                  style: TextStyle(fontSize: 18.0),
                ),
                IconButton(
                    onPressed: () {
                      _productTypeController.clear();
                      _priceController.clear();
                      _givenDateController.clear();
                      _paidDebtController.clear();
                      _phoneController.clear();
                      _tenantNameController.clear();

                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel_outlined))
              ],
            ),
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: StatefulBuilder(builder: (context, setState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10.h),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _tenantNameController,
                          decoration:
                              const InputDecoration(hintText: "Mijoz ismi"),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Bo'sh qoldirmang";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Gap(10.h),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FoxTextInputFormatter.phoneNumberFormatter
                          ],
                          controller: _phoneController,
                          decoration:
                              const InputDecoration(hintText: "Telefon raqami"),
                        ),
                        Gap(10.h),
                      ],
                    );
                  }),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      clientCollection.add({
                        "client_name": _tenantNameController.text,
                        "phone_number": _phoneController.text,
                        "created_at": DateTime.now().toString(),
                        "updated_at": DateTime.now().toString(),
                        "total_sum_uzs": 0.0,
                        "total_sum_usd": 0.0,
                      }).then((value) {
                        _productTypeController.clear();
                        _priceController.clear();
                        _givenDateController.clear();
                        _paidDebtController.clear();
                        _phoneController.clear();
                        _tenantNameController.clear();
                      });

                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text("Qo'shish"))
            ],
          );
        });
  }
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