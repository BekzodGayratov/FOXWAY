import 'package:accountant/application/rent/rent_cubit.dart';
import 'package:accountant/domain/foxway_credentials.dart';
import 'package:accountant/domain/post_rent_model.dart';
import 'package:accountant/helpers/date_picker.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:accountant/presentation/pages/home/screens/employee_screen.dart';
import 'package:accountant/presentation/pages/home/screens/manager_screen.dart';
import 'package:accountant/presentation/pages/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RentCubit _cubit;

  //CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tenantNameController;
  late final TextEditingController _productTypeController;
  late final TextEditingController _priceController;
  late final TextEditingController _paidDebtController;
  late final TextEditingController _givenDateController;
  late final TextEditingController _receivedDateController;
  late final TextEditingController _phoneController;
  late bool _isDelivered;

  ///
  String title = "Foxway";

  late String _currency;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    //CONTROLLERS

    _currency = "sum";

    if (FirebaseAuth.instance.currentUser!.email ==
        FoxwayCredentials.managerEmail) {
      title = "Foxway boshqaruvchisi";
    } else {
      title = "Foxway xodimi";
    }

    _isDelivered = false;
    _tenantNameController = TextEditingController();
    _productTypeController = TextEditingController();
    _priceController = TextEditingController();
    _givenDateController = TextEditingController();
    _receivedDateController = TextEditingController();
    _phoneController = TextEditingController();
    _paidDebtController = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _cubit = BlocProvider.of<RentCubit>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _productTypeController.dispose();
    _priceController.dispose();
    _givenDateController.dispose();
    _receivedDateController.dispose();
    _phoneController.dispose();
    _tenantNameController.dispose();

    if (_cubit.myStreamSubscription != null) {
      _cubit.myStreamSubscription!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCubit, RentState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            elevation: 4,
            centerTitle: true,
            title: Text(
              title,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
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
              ? ManagerScreen(state: state)
              : EmployeeScreen(state: state),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onPressed: () async {
              await _showAddRentDialog(context);
              setState(() {});
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: state.when(
              initial: () => null,
              loading: () => null,
              empty: () => null,
              error: (err) => null,
              success: (data) => SizedBox(
                    height: 50.h,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0)),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 50.h, left: 10.w, right: 10.w),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 10.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Barcha ijara: ",
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    " ${context.watch<RentCubit>().totalPriceSom.toString()} SO'M | ${context.watch<RentCubit>().totalPriceUsd.toString()} USD",
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors.yellow[400]),
                                                  ),
                                                ],
                                              ),
                                              Gap(10.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "To'langan: ",
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    " ${context.watch<RentCubit>().totalPaidDeptSom.toString()} SO'M | ${context.watch<RentCubit>().totalPaidDeptUsd.toString()} USD",
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors.yellow[400]),
                                                  ),
                                                ],
                                              ),
                                              Gap(10.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "To'lanmagan: ",
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    " ${context.watch<RentCubit>().totalDeptSom.toString()} SO'M | ${context.watch<RentCubit>().totalDeptUsd.toString()} USD",
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors.yellow[400]),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: const Text("Umumiy holatni ko'rish")),
                  )),
        );
      },
    );
  }

  Future<dynamic> _showAddRentDialog(BuildContext context) {
    _isDelivered = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Arenda berish",
                  style: TextStyle(fontSize: 18.0),
                ),
                IconButton(
                    onPressed: () {
                      _productTypeController.clear();
                      _priceController.clear();
                      _givenDateController.clear();
                      _receivedDateController.clear();
                      _phoneController.clear();
                      _tenantNameController.clear();
                      _isDelivered = false;
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
                              const InputDecoration(hintText: "Ijarachi ismi"),
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
                          controller: _productTypeController,
                          decoration:
                              const InputDecoration(hintText: "Tovar turi"),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Bo'sh qoldirmang";
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            NumericTextFormatter(),
                          ],
                          controller: _priceController,
                          decoration: InputDecoration(
                            hintText: "Narxi",
                            suffixIcon: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: _currency,
                                  items: const [
                                    DropdownMenuItem(
                                        value: "sum", child: Text("SO'M")),
                                    DropdownMenuItem(
                                        value: "usd", child: Text("USD"))
                                  ],
                                  onChanged: (v) {
                                    setState(() {
                                      _currency = v as String;
                                    });
                                  }),
                            ),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Bo'sh qoldirmang";
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            NumericTextFormatter(),
                          ],
                          controller: _paidDebtController,
                          decoration: InputDecoration(
                            suffixIcon: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: _currency,
                                  items: const [
                                    DropdownMenuItem(
                                        value: "sum", child: Text("SO'M")),
                                    DropdownMenuItem(
                                        value: "usd", child: Text("USD"))
                                  ],
                                  onChanged: (v) {
                                    setState(() {
                                      _currency = v as String;
                                    });
                                  }),
                            ),
                            hintText: "To'langan summa",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Bo'sh qoldirmang";
                            } else if ((num.tryParse(_priceController.text
                                        .pickOnlyNumbers()) ??
                                    0) <
                                (num.tryParse(v.pickOnlyNumbers()) ?? 0)) {
                              return "Narxdan oshib ketdi";
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onTap: () {
                            showFoxDatePicker(context, (dateTime) {
                              setState(() {
                                _givenDateController.text =
                                    DateFormat('yyyy-MM-dd').format(dateTime);
                              });
                            });
                          },
                          controller: _givenDateController,
                          decoration:
                              const InputDecoration(hintText: "Berilgan sana"),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Bo'sh qoldirmang";
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onTap: () {
                            showFoxDatePicker(context, (dateTime) {
                              setState(() {
                                _receivedDateController.text =
                                    DateFormat('yyyy-MM-dd').format(dateTime);
                              });
                            });
                          },
                          controller: _receivedDateController,
                          decoration: const InputDecoration(
                              hintText: "Qabul qilingan sana"),
                        ),
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
                        CheckboxListTile.adaptive(
                            title: const Text("Yetkazib berilgan"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _isDelivered,
                            onChanged: (v) {
                              setState(() {
                                _isDelivered = v as bool;
                              });
                            }),
                      ],
                    );
                  }),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<RentCubit>().postRent(PostRentModel(
                          tenantName: _tenantNameController.text,
                          productType: _productTypeController.text,
                          price: PostPrice(
                              currency: _currency,
                              sum: num.tryParse(_priceController.text
                                      .pickOnlyNumbers()) ??
                                  0.0),
                          paidDept: PostPrice(
                              currency: _currency,
                              sum: num.tryParse(_paidDebtController.text
                                      .pickOnlyNumbers()) ??
                                  0.0),
                          givenDate: _givenDateController.text,
                          receivedDate: _receivedDateController.text,
                          phoneNumber: _phoneController.text,
                          isDelivered: _isDelivered));

                      _productTypeController.clear();
                      _priceController.clear();
                      _givenDateController.clear();
                      _receivedDateController.clear();
                      _phoneController.clear();
                      _tenantNameController.clear();
                      _isDelivered = false;
                      Navigator.of(context).pop();
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
