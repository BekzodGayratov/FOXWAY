import 'package:accountant/application/client/client_cubit.dart';
import 'package:accountant/domain/client_model.dart';
import 'package:accountant/domain/price_model.dart';
import 'package:accountant/domain/product_model.dart';
import 'package:accountant/helpers/date_picker.dart';
import 'package:accountant/helpers/input_formatters.dart';

import 'package:accountant/presentation/extension/ext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class EmployeeProductDetailsPage extends StatefulWidget {
  final ClientModel element;
  const EmployeeProductDetailsPage({super.key, required this.element});

  @override
  State<EmployeeProductDetailsPage> createState() =>
      _EmployeeProductDetailsPageState();
}

class _EmployeeProductDetailsPageState
    extends State<EmployeeProductDetailsPage> {
  //CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _productTypeController;
  late final TextEditingController _priceController;
  late final TextEditingController _paidDebtController;
  late final TextEditingController _givenDateController;
  late String _currency;

  late Future<QuerySnapshot<Map<String, dynamic>>>? productsSnapshot;
  late final CollectionReference<Map<String, dynamic>> productsCollection;
  late final CollectionReference<Map<String, dynamic>> clientCollection;

  //
  double totalPriceUzs = 0.0;
  double totalPriceUsd = 0.0;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    //CONTROLLERS
    clientCollection = FirebaseFirestore.instance.collection("clients");
    productsCollection = FirebaseFirestore.instance
        .collection("clients")
        .doc(widget.element.id)
        .collection('products');
    productsSnapshot = FirebaseFirestore.instance
        .collection("clients")
        .doc(widget.element.id)
        .collection('products')
        .orderBy("created_at")
        .get();

    _currency = "sum";

    _productTypeController = TextEditingController();
    _priceController = TextEditingController();
    _givenDateController = TextEditingController();

    _paidDebtController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _productTypeController.dispose();
    _priceController.dispose();
    _givenDateController.dispose();
    _paidDebtController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    setState(() {
      productsSnapshot = FirebaseFirestore.instance
          .collection("clients")
          .doc(widget.element.id)
          .collection('products')
          .orderBy("created_at")
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.amber,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mijoz: ${widget.element.client_name.toString()}",
              style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
            Text("Telefon: ${widget.element.phone_number}",
                style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white))
          ],
        ),
      ),
      body: FutureBuilder(
          future: productsSnapshot,
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              final products = snapshot.data!.docs
                  .map((e) => ProductModel.fromMap(e.data()))
                  .toList();
              for (var i = 0; i < snapshot.data!.docs.length; i++) {
                products[i].id = snapshot.data!.docs[i].id.toString();
              }

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  _calculateTotalPaidMoney(products);
                });
              });

              return products.isEmpty
                  ? const Center(child: Text("Tovarlar mavjud emas"))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          showCheckboxColumn: false,
                          headingTextStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                          border:
                              TableBorder.all(color: const Color(0xffF2F4F7)),
                          columns: const [
                            DataColumn(label: Text("#")),
                            DataColumn(label: Text("Tovarlari")),
                            DataColumn(label: Text("Narxi")),
                            DataColumn(label: Text("To'landi")),
                            DataColumn(label: Text("Qoldiq")),
                            DataColumn(label: Text("Berilgan sana")),
                          ],
                          rows: List.generate(
                            products.length,
                            (index) => DataRow(cells: [
                              DataCell(
                                Text("${index + 1}"),
                              ),
                              DataCell(
                                TextFormField(
                                  readOnly: true,
                                  initialValue:
                                      products[index].product_type ?? '',
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      hintText: "Mahsulot turi"),
                                  onFieldSubmitted: (v) {
                                    if (v.trim() !=
                                        products[index]
                                            .product_type!
                                            .toString()
                                            .trim()) {
                                      products[index] =
                                          products[index].copyWith(
                                        product_type: v,
                                      );
                                      _updateProduct(products[index]);
                                    }
                                  },
                                ),
                              ),
                              DataCell(
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  readOnly: true,
                                  inputFormatters: [
                                    NumericTextFormatter(),
                                  ],
                                  initialValue: products[index]
                                      .price!
                                      .sum
                                      .toString()
                                      .formatMoney(),
                                  decoration: InputDecoration(
                                      suffix: Text(
                                          products[index].price!.currency ==
                                                  "usd"
                                              ? "USD "
                                              : "SO'M "),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      errorBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      hintText: "Mahsulot narxi"),
                                ),
                              ),
                              DataCell(
                                TextFormField(
                                  inputFormatters: [
                                    NumericTextFormatter(),
                                  ],
                                  keyboardType: TextInputType.number,
                                  readOnly: false,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  initialValue: products[index]
                                      .paid_money!
                                      .sum
                                      .toString()
                                      .formatMoney(),
                                  decoration: InputDecoration(
                                      isDense: true,
                                      suffix: Text(
                                          products[index].price!.currency ==
                                                  "usd"
                                              ? "USD "
                                              : "SO'M "),
                                      border: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      errorBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      hintText: "To'landi"),
                                  validator: (v) {
                                    if (v!.isEmpty) {
                                      return "Bo'sh qoldirmang";
                                    } else if (products[index].price!.sum! <
                                        num.parse(v.pickOnlyNumbers())) {
                                      v = products[index]
                                          .price!
                                          .sum
                                          .toString()
                                          .formatMoney();
                                      return "${products[index].price!.sum!.toString().formatMoney()} dan oshib ketdi";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onFieldSubmitted: (v) {
                                    if (products[index]
                                            .paid_money!
                                            .sum
                                            .toString()
                                            .pickOnlyNumbers()
                                            .trim() !=
                                        v.trim()) {
                                      if (products[index].price!.sum! >=
                                          num.parse(v.pickOnlyNumbers())) {
                                        products[index] =
                                            products[index].copyWith(
                                          paid_money: Price(
                                              sum: num.tryParse(
                                                      v.pickOnlyNumbers()) ??
                                                  0.0),
                                        );
                                        _updateProduct(products[index]);
                                      }
                                    }
                                  },
                                ),
                              ),
                              DataCell(
                                TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  initialValue: (products[index].price!.sum! -
                                          products[index].paid_money!.sum!)
                                      .toString()
                                      .formatMoney(),
                                  decoration: InputDecoration(
                                      isDense: true,
                                      suffix: Text(
                                          products[index].price!.currency ==
                                                  "usd"
                                              ? "USD "
                                              : "SO'M "),
                                      border: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      errorBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      hintText: "Qoldiq"),
                                ),
                              ),
                              DataCell(
                                TextFormField(
                                  readOnly: true,
                                  initialValue:
                                      DateFormat(DateFormat.YEAR_MONTH_DAY)
                                          .format(DateTime.parse(products[index]
                                              .given_date
                                              .toString())),
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      hintText: "Berilgan sana"),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    );
            } else if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const SizedBox.shrink();
            }
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          onPressed: () {
            _showAddRentDialog(context);
          },
          child: const Icon(Icons.add)),
      bottomNavigationBar: Container(
          height: 80.h,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.amber,
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                      Text("${totalPriceUzs.toString().formatMoney()} UZS",
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                      Text("${totalPriceUsd.toString().formatMoney()} USD",
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          )),
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
                  "Tovar qo'shish",
                  style: TextStyle(fontSize: 18.0),
                ),
                IconButton(
                    onPressed: () {
                      _productTypeController.clear();
                      _priceController.clear();
                      _paidDebtController.clear();
                      _givenDateController.clear();

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
                            hintText: "To'landi",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return null;
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
                      _postProduct().then((value) {
                        _productTypeController.clear();
                        _priceController.clear();
                        _paidDebtController.clear();
                        _givenDateController.clear();
                        refreshData();
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Qo'shish"))
            ],
          );
        });
  }

  void _updateProduct(ProductModel product) {
    productsCollection.doc(product.id).update({
      "product_type": product.product_type,
      "price": Price(
              sum: product.price!.sum ?? 0.0, currency: product.price!.currency)
          .toMap(),
      "paid_money": Price(
              sum: product.paid_money!.sum ?? 0.0,
              currency: product.paid_money!.currency)
          .toMap(),
      "given_date": product.given_date.toString(),
      "created_at": product.created_at.toString()
    });
  }

  Future<void> _postProduct() async {
    await productsCollection.add({
      "product_type": _productTypeController.text,
      "price": Price(
              sum: num.tryParse(_priceController.text.pickOnlyNumbers()) ?? 0.0,
              currency: _currency.toLowerCase())
          .toMap(),
      "paid_money": Price(
              sum: num.tryParse(_paidDebtController.text.pickOnlyNumbers()) ??
                  0.0,
              currency: _currency.toLowerCase())
          .toMap(),
      "given_date": _givenDateController.text,
      "created_at": DateTime.now().toString()
    });
  }

  void _calculateTotalPaidMoney(List<ProductModel> products) {
    totalPriceUzs = 0.0;
    totalPriceUsd = 0.0;
    for (var element in products) {
      if (element.paid_money!.currency == "sum") {
        totalPriceUzs +=
            (element.price!.sum ?? 0.0) - (element.paid_money!.sum ?? 0.0);
      } else {
        totalPriceUsd +=
            (element.price!.sum ?? 0.0) - (element.paid_money!.sum ?? 0.0);
      }
    }
  }
}
