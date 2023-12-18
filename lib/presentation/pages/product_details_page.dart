import 'package:accountant/domain/client_model.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final ClientModel data;
  const ProductDetailsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mijozning ismi: ${data.client_name.toString()}"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
                showCheckboxColumn: false,
                headingTextStyle: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
                border: TableBorder.all(color: const Color(0xffF2F4F7)),
                columns: const [
                  DataColumn(label: Text("#")),
                  DataColumn(label: Text("Mahsulot turi")),
                  DataColumn(label: Text("Narxi")),
                  DataColumn(label: Text("To'langan summa")),
                  DataColumn(label: Text("Qolgan summa")),
                  DataColumn(label: Text("Berilgan sana")),
                  DataColumn(label: Text("O'chirish"))
                ],
                rows: List.generate(
                  data.products.length,
                  (index) => DataRow(cells: [
                    DataCell(
                      Text("${index + 1}"),
                    ),
                    DataCell(
                      TextFormField(
                        initialValue: data.products[index]!.product_type ?? '',
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            hintText: "Mahsulot turi"),
                        onFieldSubmitted: (v) {
                          // final updatedElement =
                          //     data[index].copyWith(product_type: v);

                          // _updateRent(updatedElement, index);
                        },
                      ),
                    ),
                    DataCell(
                      TextFormField(
                        readOnly: false,
                        inputFormatters: [
                          NumericTextFormatter(),
                        ],
                        initialValue: data.products[index]!.price!.sum
                            .toString()
                            .formatMoney(),
                        decoration: InputDecoration(
                            suffix: Text(
                                data.products[index]!.price!.currency == "usd"
                                    ? "USD "
                                    : "SO'M "),
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: data.products[index]!.paid_money!.sum
                            .toString()
                            .formatMoney(),
                        decoration: InputDecoration(
                            isDense: true,
                            suffix: Text(
                                data.products[index]!.paid_money!.currency ==
                                        "usd"
                                    ? "USD "
                                    : "SO'M "),
                            border: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            hintText: "Ijarachi to'lagan summa"),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Bo'sh qoldirmang";
                          } else if (data.products[index]!.price!.sum! <
                              num.parse(v.pickOnlyNumbers())) {
                            v = data.products[index]!.price!.sum
                                .toString()
                                .formatMoney();
                            return "${data.products[index]!.price!.sum!.toString().formatMoney()} dan oshib ketdi";
                          } else if (data.products[index]!.price!.sum! >=
                              num.parse(v.pickOnlyNumbers())) {
                            // final updatedElement = data.products[index]!
                            //     .copyWith(
                            //         paid_money: Price(
                            //             currency: data.products[index]!
                            //                 .paid_money!.currency,
                            //             sum:
                            //                 num.tryParse(v.pickOnlyNumbers()) ??
                            //                     0.0));

                            // _updateRent(updatedElement, index).then((value) {
                            //   setState(() {
                            //     _uniqueKey = UniqueKey();
                            //   });
                            // });
                            return null;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    DataCell(
                      Text("SALOM"),
                    ),
                    DataCell(
                      Text("SALOM"),
                    ),
                    DataCell(
                      Text("SALOM"),
                    ),
                  ]),
                )),
          ),
        ));
  }
}
