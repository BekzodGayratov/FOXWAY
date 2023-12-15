import 'package:accountant/application/rent/rent_cubit.dart';
import 'package:accountant/domain/post_rent_model.dart';
import 'package:accountant/domain/rent_model.dart';
import 'package:accountant/helpers/date_picker.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:accountant/presentation/pages/home/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  // MODELS

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
  @override
  void initState() {
    //CONTROLLERS
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
  void dispose() {
    _productTypeController.dispose();
    _priceController.dispose();
    _givenDateController.dispose();
    _receivedDateController.dispose();
    _phoneController.dispose();
    _tenantNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCubit, RentState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Foxway"),
          ),
          body: MainScreen(state: state),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _showAddRentDialog(context);
              setState(() {});
            },
            child: const Icon(Icons.add),
          ),
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
                  child: Column(
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
                        inputFormatters: [NumericTextFormatter()],
                        controller: _priceController,
                        decoration: const InputDecoration(
                            hintText: "Narxi", suffixText: "SO'M"),
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
                        inputFormatters: [NumericTextFormatter()],
                        controller: _paidDebtController,
                        decoration: const InputDecoration(
                            hintText: "To'langan summa", suffixText: "SO'M"),
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
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Bo'sh qoldirmang";
                          } else if (v.trim().length < 13) {
                            return "To'g'ri telefon kiriting";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Gap(10.h),
                      StatefulBuilder(builder: (context, setState) {
                        return CheckboxListTile.adaptive(
                            title: const Text("Yetkazib berilgan"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _isDelivered,
                            onChanged: (v) {
                              setState(() {
                                _isDelivered = v as bool;
                              });
                            });
                      })
                    ],
                  ),
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
                          price: _priceController.text.pickOnlyNumbers(),
                          paidDept: _paidDebtController.text.pickOnlyNumbers(),
                          givenDate: _givenDateController.text,
                          receivedDate: _receivedDateController.text,
                          phoneNumber: _phoneController.text,
                          isDelivered: _isDelivered));

                      _productTypeController.clear();
                      _priceController.clear();
                      _givenDateController.clear();
                      _receivedDateController.clear();
                      _phoneController.clear();
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
