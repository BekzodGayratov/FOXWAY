import 'package:accountant/application/product/product_cubit.dart';
import 'package:accountant/domain/foxway_credentials.dart';
import 'package:accountant/domain/post_client_model.dart';
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
  late ProductCubit _cubit;

  //CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tenantNameController;
  late final TextEditingController _productTypeController;
  late final TextEditingController _priceController;
  late final TextEditingController _paidDebtController;
  late final TextEditingController _givenDateController;
  late final TextEditingController _phoneController;

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
      title = "Boshqaruvchi";
    } else {
      title = "Xodim";
    }

    _tenantNameController = TextEditingController();
    _productTypeController = TextEditingController();
    _priceController = TextEditingController();
    _givenDateController = TextEditingController();

    _phoneController = TextEditingController();
    _paidDebtController = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _cubit = BlocProvider.of<ProductCubit>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _productTypeController.dispose();
    _priceController.dispose();
    _givenDateController.dispose();
    _phoneController.dispose();
    _tenantNameController.dispose();
    _paidDebtController.dispose();
    if (_cubit.myStreamSubscription != null) {
      _cubit.myStreamSubscription!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
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
                                return Container(
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
                                                  "Barcha tovar narxi: ",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  " ${context.watch<ProductCubit>().totalPriceSom.toString().formatMoney()} SO'M | ${context.watch<ProductCubit>().totalPriceUsd.toString().formatMoney()} USD",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
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
                                                  "To'landi: ",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  " ${context.watch<ProductCubit>().totalPaidDeptSom.toString().formatMoney()} SO'M | ${context.watch<ProductCubit>().totalPaidDeptUsd.toString().formatMoney()} USD",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
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
                                                  "Qoldi: ",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  " ${context.watch<ProductCubit>().totalDeptSom.toString().formatMoney()} SO'M | ${context.watch<ProductCubit>().totalDeptUsd.toString().formatMoney()} USD",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
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
    return showDialog(
        context: context,
        builder: (context) {
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
                          inputFormatters: [
                            FoxTextInputFormatter.birthDateFormatter
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onTap: () {
                            _givenDateController.text =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                            setState(() {});
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ProductCubit>().postClient(PostClientModel(
                            clientName: _tenantNameController.text,
                            product: ProductModel(
                              productType: _productTypeController.text,
                              price: Price(
                                  currency: _currency,
                                  sum: num.tryParse(_priceController.text
                                          .pickOnlyNumbers()) ??
                                      0.0),
                              paidMoney: Price(
                                  currency: _currency,
                                  sum: num.tryParse(_paidDebtController.text
                                          .pickOnlyNumbers()) ??
                                      0.0),
                              givenDate: _givenDateController.text,
                            ),
                            phoneNumber: _phoneController.text,
                            givenDate: _givenDateController.text,
                          ));

                      _productTypeController.clear();
                      _priceController.clear();
                      _givenDateController.clear();

                      _phoneController.clear();
                      _tenantNameController.clear();

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
