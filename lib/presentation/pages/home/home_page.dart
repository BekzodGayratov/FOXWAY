import 'package:accountant/application/client/client_cubit.dart';
import 'package:accountant/domain/client_model.dart';
import 'package:accountant/domain/foxway_credentials.dart';
import 'package:accountant/domain/post_client_model.dart';
import 'package:accountant/domain/price_model.dart';
import 'package:accountant/domain/product_model.dart';
import 'package:accountant/helpers/date_picker.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:accountant/presentation/pages/home/screens/employee_screen.dart';
import 'package:accountant/presentation/pages/home/screens/manager_screen.dart';
import 'package:accountant/presentation/pages/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late ClientCubit _cubit;

  //CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tenantNameController;
  late final TextEditingController _productTypeController;
  late final TextEditingController _phoneController;
  late final TextEditingController _priceController;
  late final TextEditingController _paidDebtController;
  late final TextEditingController _givenDateController;

  ///
  String title = "Foxway";

  late String _currency;

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
    _cubit = BlocProvider.of<ClientCubit>(context);
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
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amber,
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
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              onPressed: () async {
                await _showAddClientDialog(context);
                setState(() {});
              },
              child: const Icon(Icons.add),
            ),
            bottomNavigationBar: state.when(
                initial: () => null,
                loading: () => null,
                empty: () => null,
                error: (err) => null,
                success: (data) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _calculateTotalSum(data);
                    });
                  });

                  return Container(
                      height: 80.h,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 5.0)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Umumiy qoldiq:",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white)),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                      "${totalSumUzs.toString().pickOnlyNumbers().formatMoney()} UZS",
                                      style: const TextStyle(
                                          fontSize: 20.0, color: Colors.white)),
                                  Text(
                                      "${totalSumUsd.toString().pickOnlyNumbers().formatMoney()} USD",
                                      style: const TextStyle(
                                          fontSize: 20.0, color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                }));
      },
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      context
                          .read<ClientCubit>()
                          .postClient(PostClientModel(
                            clientName: _tenantNameController.text,
                            phoneNumber: _phoneController.text,
                            givenDate: _givenDateController.text,
                          ))
                          .then((clientRef) async {
                        if (clientRef != null) {
                          final CollectionReference productCollection =
                              FirebaseFirestore.instance.collection(
                                  "clients/${clientRef.id}/products");

                          final s = await productCollection.add({
                            "product_type": _productTypeController.text,
                            "price": Price(
                                    sum: num.tryParse(_priceController.text
                                            .pickOnlyNumbers()) ??
                                        0.0,
                                    currency: _currency.toLowerCase())
                                .toMap(),
                            "paid_money": Price(
                                    sum: num.tryParse(_paidDebtController.text
                                            .pickOnlyNumbers()) ??
                                        0.0,
                                    currency: _currency.toLowerCase())
                                .toMap(),
                            "given_date": _givenDateController.text,
                            "created_at": DateTime.now().toString()
                          });
                          final productRef = await s.get();
                          final clientRes = ClientModel.fromMap(
                              clientRef.data() as Map<String, dynamic>);
                          final productRes = ProductModel.fromMap(
                              productRef.data() as Map<String, dynamic>);
                          _productTypeController.clear();
                          _priceController.clear();
                          _givenDateController.clear();
                          _paidDebtController.clear();
                          _phoneController.clear();
                          _tenantNameController.clear();
                          Future.delayed(Duration.zero).then((value) async {
                            if (productRes.price!.currency == "sum") {
                              await context.read<ClientCubit>().updateClient(
                                  id: clientRef.id,
                                  rentModel: ClientModel(
                                      client_name: clientRes.client_name,
                                      phone_number: clientRes.phone_number,
                                      given_date: clientRes.given_date,
                                      created_at: clientRes.created_at,
                                      updated_at: clientRes.updated_at,
                                      total_sum_uzs:
                                          ((productRes.price!.sum ?? 0.0) -
                                                  (productRes.paid_money!.sum ??
                                                      0.0))
                                              .toString()
                                              .pickOnlyNumbers(),
                                      total_sum_usd: "0.0"));
                            } else {
                              await context.read<ClientCubit>().updateClient(
                                  id: clientRef.id,
                                  rentModel: ClientModel(
                                      client_name: clientRes.client_name,
                                      phone_number: clientRes.phone_number,
                                      given_date: clientRes.given_date,
                                      created_at: clientRes.created_at,
                                      updated_at: clientRes.updated_at,
                                      total_sum_usd:
                                          ((productRes.price!.sum ?? 0.0) -
                                                  (productRes.paid_money!.sum ??
                                                      0.0))
                                              .toString()
                                              .pickOnlyNumbers(),
                                      total_sum_uzs: "0.0"));
                            }
                          });
                        }
                      });

                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text("Qo'shish"))
            ],
          );
        });
  }

  void _calculateTotalSum(List<ClientModel> clients) {
    totalSumUzs = 0.0;
    totalSumUsd = 0.0;
    for (var element in clients) {
      totalSumUzs +=
          int.tryParse(element.total_sum_uzs.toString().pickOnlyNumbers()) ??
              0.0;
      totalSumUsd +=
          int.tryParse(element.total_sum_usd.toString().pickOnlyNumbers()) ??
              0.0;
    }
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
