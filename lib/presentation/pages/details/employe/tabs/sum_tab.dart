import 'package:accountant/domain/client_model.dart';
import 'package:accountant/domain/price_model.dart';
import 'package:accountant/domain/sum_controller.dart';
import 'package:accountant/domain/sum_model.dart';
import 'package:accountant/helpers/date_picker.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class EmployeeSumTab extends StatefulWidget {
  final ClientModel element;
  const EmployeeSumTab({super.key, required this.element});

  @override
  State<EmployeeSumTab> createState() => _EmployeeSumTabState();
}

class _EmployeeSumTabState extends State<EmployeeSumTab>
    with TickerProviderStateMixin {
  //CONTROLLERS
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;
  late final TextEditingController _givenDateController;
  late String _currency;

  late Stream<QuerySnapshot<Map<String, dynamic>>> sumSnapshot;
  late final CollectionReference<Map<String, dynamic>> sumCollection;
  late final CollectionReference<Map<String, dynamic>> clientCollection;

  //
  double totalPriceUzs = 0.0;
  double totalPriceUsd = 0.0;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    //CONTROLLERS

    clientCollection = FirebaseFirestore.instance.collection("clients");
    sumCollection = FirebaseFirestore.instance
        .collection("clients")
        .doc(widget.element.id)
        .collection('sums');
    sumSnapshot = FirebaseFirestore.instance
        .collection("clients")
        .doc(widget.element.id)
        .collection('sums')
        .orderBy("given_date")
        .snapshots();

    _currency = "sum";

    _priceController = TextEditingController();
    _givenDateController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _givenDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: sumSnapshot,
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              final sums = snapshot.data!.docs
                  .map((e) => SumModel.fromMap(e.data()))
                  .toList();
              for (var i = 0; i < snapshot.data!.docs.length; i++) {
                sums[i].id = snapshot.data!.docs[i].id.toString();
              }

              _calculateTotalPaidMoney(sums);

              return sums.isEmpty
                  ? const Center(child: Text("Pullar mavjud emas"))
                  : Scaffold(
                      body: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingTextStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            border:
                                TableBorder.all(color: const Color(0xffF2F4F7)),
                            columns: const [
                              DataColumn(label: Text("#")),
                              DataColumn(label: Text("Pul qiymati")),
                              DataColumn(label: Text("Berilgan sana")),
                            ],
                            rows: List.generate(
                              sums.length,
                              (index) => DataRow(cells: [
                                DataCell(
                                  Text("${index + 1}"),
                                ),
                                DataCell(
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                    inputFormatters: [
                                      NumericTextFormatter(),
                                    ],
                                    initialValue: sums[index]
                                        .sum!
                                        .sum
                                        .toString()
                                        .formatMoney(),
                                    decoration: InputDecoration(
                                        suffix: Text(
                                            sums[index].sum!.currency == "usd"
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
                                        hintText: "Berilgan pul narxi"),
                                    // onFieldSubmitted: (v) {
                                    //   if (v.pickOnlyNumbers().trim() !=
                                    //       sums[index]
                                    //           .sum!
                                    //           .sum
                                    //           .toString()
                                    //           .pickOnlyNumbers()
                                    //           .trim()) {
                                    //     sums[index] = sums[index].copyWith(
                                    //       sum: Price(
                                    //           sum: num.tryParse(
                                    //                   v.pickOnlyNumbers()) ??
                                    //               0.0,
                                    //           currency:
                                    //               sums[index].sum!.currency),
                                    //     );
                                    //     _updateSum(sums[index]);
                                    //   }
                                    // },
                                  ),
                                ),
                                DataCell(
                                  TextFormField(
                                    readOnly: true,
                                    initialValue: DateFormat(
                                            DateFormat.YEAR_MONTH_DAY)
                                        .format(DateTime.parse(
                                            sums[index].given_date.toString())),
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
                      ),
                      bottomNavigationBar: Container(
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
                                          "${totalPriceUzs.toString().formatMoney()} UZS",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white)),
                                      Text(
                                          "${totalPriceUsd.toString().formatMoney()} USD",
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 90.h),
        child: FloatingActionButton(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            onPressed: () {
              _showAddSumDialog(context);
            },
            child: const Icon(Icons.remove)),
      ),
    );
  }

  Future<dynamic> _showAddSumDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Summa qo'shish",
                  style: TextStyle(fontSize: 18.0),
                ),
                IconButton(
                    onPressed: () {
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            NumericTextFormatter(),
                          ],
                          controller: _priceController,
                          decoration: InputDecoration(
                            hintText: "Summa",
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
                      _postSum().then((value) {
                        _priceController.clear();
                        _givenDateController.clear();
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Qo'shish"))
            ],
          );
        });
  }

  Future<void> _postSum() async {
    await sumCollection.add({
      "sum": Price(
              sum: num.tryParse(_priceController.text.pickOnlyNumbers()) ?? 0.0,
              currency: _currency.toLowerCase())
          .toMap(),
      "given_date": _givenDateController.text,
    });
  }

  Future<void> _calculateTotalPaidMoney(List<SumModel> sums) async {
    totalPriceUzs = 0.0;
    totalPriceUsd = 0.0;
    for (var element in sums) {
      if (element.sum!.currency == "sum") {
        totalPriceUzs += element.sum!.sum ?? 0;
      } else {
        totalPriceUsd += element.sum!.sum ?? 0;
      }
    }
    SumController.totalSumUzs = totalPriceUzs;
    SumController.totalSumUsd = totalPriceUsd;
  }
}
