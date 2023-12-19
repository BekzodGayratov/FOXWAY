import 'package:accountant/application/product/product_cubit.dart';
import 'package:accountant/domain/client_model.dart';
import 'package:accountant/helpers/date_picker.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/helpers/show_message.dart';
import 'package:accountant/infrastructure/fire_store_service.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:accountant/domain/post_client_model.dart' as post;
import 'package:accountant/domain/client_model.dart' as product;
import 'package:uuid/uuid.dart';

class ProductDetailsPage extends StatefulWidget {
  final ClientModel element;
  const ProductDetailsPage({super.key, required this.element});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  //CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _productTypeController;
  late final TextEditingController _priceController;
  late final TextEditingController _paidDebtController;
  late final TextEditingController _givenDateController;
  late String _currency;
  final uuid = const Uuid();

  late Stream<DocumentSnapshot<Map<String, dynamic>>> documentSnapshot;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    //CONTROLLERS
    documentSnapshot = ProductsFireStoreService()
        .clientCollection
        .doc(widget.element.id.toString())
        .snapshots() as Stream<DocumentSnapshot<Map<String, dynamic>>>;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mijoz: ${widget.element.client_name.toString()}",
              style:
                  const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
            ),
            Text("Telefon: ${widget.element.phone_number}",
                style: const TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.w400))
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
            child: StreamBuilder(
                stream: documentSnapshot,
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    final documentData = snapshot.data!.data();
                    late ClientModel? client;
                    if (documentData != null) {
                      client = ClientModel.fromMap(documentData);
                    } else {
                      client = null;
                    }

                    return Visibility(
                      visible: client != null,
                      child: DataTable(
                        showCheckboxColumn: false,
                        headingTextStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        border: TableBorder.all(color: const Color(0xffF2F4F7)),
                        columns: const [
                          DataColumn(label: Text("#")),
                          DataColumn(label: Text("Tovarlari")),
                          DataColumn(label: Text("Narxi")),
                          DataColumn(label: Text("To'landi")),
                          DataColumn(label: Text("Qoldi")),
                          DataColumn(label: Text("Berilgan sana")),
                          DataColumn(label: Text("O'chirish"))
                        ],
                        rows: List.generate(
                          client!.products.length,
                          (index) => DataRow(cells: [
                            DataCell(
                              Text("${index + 1}"),
                            ),
                            DataCell(
                              TextFormField(
                                initialValue:
                                    client!.products[index]!.product_type ?? '',
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
                                  client!.products[index]!.copyWith(
                                    product_type: v,
                                  );
                                  context.read<ProductCubit>().updateProduct(
                                      clientModel: widget.element,
                                      productModels: client.products);
                                },
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                readOnly: false,
                                inputFormatters: [
                                  NumericTextFormatter(),
                                ],
                                initialValue: client.products[index]!.price!.sum
                                    .toString()
                                    .formatMoney(),
                                decoration: InputDecoration(
                                    suffix: Text(client.products[index]!.price!
                                                .currency ==
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
                                onFieldSubmitted: (v) {
                                  // final updatedElement = data.products[index]!.copyWith(
                                  //     price: Price(
                                  //         currency: data.products[index]!.price!.currency,
                                  //         sum: num.tryParse(v.pickOnlyNumbers()) ??
                                  //             0.0));

                                  // _updateRent(updatedElement, index);
                                },
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                inputFormatters: [
                                  NumericTextFormatter(),
                                ],
                                keyboardType: TextInputType.number,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: client
                                    .products[index]!.paid_money!.sum
                                    .toString()
                                    .formatMoney(),
                                decoration: InputDecoration(
                                    isDense: true,
                                    suffix: Text(client.products[index]!
                                                .paid_money!.currency ==
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
                                    hintText: "To'langan summa"),
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "Bo'sh qoldirmang";
                                  } else if (client!
                                          .products[index]!.price!.sum! <
                                      num.parse(v.pickOnlyNumbers())) {
                                    v = client.products[index]!.price!.sum
                                        .toString()
                                        .formatMoney();
                                    return "${client.products[index]!.price!.sum!.toString().formatMoney()} dan oshib ketdi";
                                  } else if (client
                                          .products[index]!.price!.sum! >=
                                      num.parse(v.pickOnlyNumbers())) {
                                    return null;
                                  } else {
                                    return null;
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
                                initialValue:
                                    (client.products[index]!.price!.sum! -
                                            client.products[index]!.paid_money!
                                                .sum!)
                                        .toString()
                                        .formatMoney(),
                                decoration: InputDecoration(
                                    isDense: true,
                                    suffix: Text(client.products[index]!
                                                .paid_money!.currency ==
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
                                    hintText: "Qoldi"),
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                readOnly: true,
                                initialValue:
                                    DateFormat(DateFormat.YEAR_MONTH_DAY)
                                        .format(DateTime.parse(client
                                            .products[index]!.given_date
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
                            DataCell(ElevatedButton(
                              onPressed: () {
                                _deleteClient(
                                    widget.element, client!.products[index]!);
                              },
                              child: const Text("O'chirish"),
                            )),
                          ]),
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
                })),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddRentDialog(context);
          },
          child: const Icon(Icons.add)),
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
                      context.read<ProductCubit>().postProduct(
                          id: widget.element.id.toString(),
                          clientModel: widget.element,
                          productModel: product.ProductModel(
                              created_at: DateTime.now().toLocal().toString(),
                              given_date: _givenDateController.text,
                              id: uuid.v4(),
                              paid_money: product.Price(
                                  sum: num.tryParse(_paidDebtController.text
                                          .pickOnlyNumbers()) ??
                                      0.0,
                                  currency: _currency),
                              price: product.Price(
                                  sum: num.tryParse(_priceController.text
                                          .pickOnlyNumbers()) ??
                                      0.0,
                                  currency: _currency),
                              product_type:
                                  _productTypeController.text.trim()));
                      _productTypeController.clear();
                      _priceController.clear();
                      _givenDateController.clear();
                      _paidDebtController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Qo'shish"))
            ],
          );
        });
  }

  void _deleteClient(ClientModel clientModel, ProductModel product) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: ListTile(
              title: Text("Ijarachi: ${clientModel.client_name}"),
              subtitle: Text("Mahsulot: ${product.product_type}"),
            ),
            content: const Text("haqiqatdan o'chirmoqchimisiz?"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yo'q")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<ProductCubit>().deleteProduct(
                        id: widget.element.id.toString(),
                        clientModel: widget.element,
                        product: product);
                  },
                  child: const Text("Ha"))
            ],
          );
        });
  }
}
