import 'package:accountant/application/rent/rent_cubit.dart';
import 'package:accountant/domain/post_rent_model.dart';
import 'package:accountant/domain/rent_model.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/helpers/show_message.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:accountant/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EmployeeScreen extends StatefulWidget {
  final RentState state;

  const EmployeeScreen({super.key, required this.state});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  Key _uniqueKey = UniqueKey();
  GlobalKey<_EmployeeScreenState> _dataTableKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return widget.state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(
              child: FoxLoadingWidget(),
            ),
        empty: () => const Center(
              child: Text("Sizda ijaralar mavjud emas"),
            ),
        error: (err) => Center(child: Text(err)),
        success: (data) {
          setState(() {
            data = data;
            _dataTableKey = GlobalKey();
          });
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                  key: _dataTableKey,
                  decoration: const BoxDecoration(color: Colors.red),
                  showCheckboxColumn: false,
                  headingTextStyle: const TextStyle(color: Colors.black),
                  headingRowColor: MaterialStateProperty.all(Colors.blue[200]),
                  dataRowColor: MaterialStateProperty.all(Colors.blue[50]),
                  border: TableBorder.all(color: const Color(0xffF2F4F7)),
                  dataRowMaxHeight: 60.h,
                  columns: const [
                    DataColumn(label: Text("#")),
                    DataColumn(label: Text("Ijarachi ismi")),
                    DataColumn(label: Text("Mahsulot turi")),
                    DataColumn(label: Text("Narxi")),
                    DataColumn(label: Text("To'langan summa")),
                    DataColumn(label: Text("Umumiy hisob")),
                    DataColumn(label: Text("Holati")),
                    DataColumn(label: Text("Berilgan sana")),
                    DataColumn(label: Text("Qabul qilingan sana")),
                    DataColumn(label: Text("Qayd qilingan sana")),
                  ],
                  rows: List.generate(
                    data.length,
                    (index) => _returnDataRow(data, index, context),
                  )),
            ),
          );
        });
  }

  DataRow _returnDataRow(
      List<RentModel> data, int index, BuildContext context) {
    return DataRow(cells: [
      DataCell(
        Text("${index + 1}"),
      ),
      DataCell(
        TextFormField(
          initialValue: data[index].tenant_name.toString(),
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              errorBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              hintText: "Ijarachi ismi"),
          onFieldSubmitted: (v) {
            final updatedElement = data[index].copyWith(tenant_name: v);

            _updateRent(updatedElement, index);
          },
        ),
      ),
      DataCell(
        TextFormField(
          initialValue: data[index].product_type,
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              errorBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              hintText: "Mahsulot turi"),
          onFieldSubmitted: (v) {
            final updatedElement = data[index].copyWith(product_type: v);

            _updateRent(updatedElement, index);
          },
        ),
      ),
      DataCell(
        TextFormField(
          readOnly: true,
          inputFormatters: [
            NumericTextFormatter(),
          ],
          initialValue: data[index].price!.sum.toString().formatMoney(),
          decoration: InputDecoration(
              suffix:
                  Text(data[index].price!.currency == "usd" ? "USD " : "SO'M "),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              hintText: "Mahsulot narxi"),
        ),
      ),
      DataCell(
        TextFormField(
          inputFormatters: [
            NumericTextFormatter(),
          ],
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: data[index].paid_dept!.sum.toString().formatMoney(),
          decoration: InputDecoration(
              isDense: true,
              suffix: Text(
                  data[index].paid_dept!.currency == "usd" ? "USD " : "SO'M "),
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              hintText: "Ijarachi to'lagan summa"),
          validator: (v) {
            if (v!.isEmpty) {
              return "Bo'sh qoldirmang";
            } else if (data[index].price!.sum! <
                num.parse(v.pickOnlyNumbers())) {
              v = data[index].price!.sum.toString().formatMoney();
              return "${data[index].price!.sum!.toString().formatMoney()} dan oshib ketdi";
            } else if (data[index].price!.sum! >=
                num.parse(v.pickOnlyNumbers())) {
              final updatedElement = data[index].copyWith(
                  paid_dept: RentPrice(
                      currency: data[index].paid_dept!.currency,
                      sum: num.tryParse(v.pickOnlyNumbers()) ?? 0.0));

              _updateRent(updatedElement, index).then((value) {
                setState(() {
                  _uniqueKey = UniqueKey();
                });
              });
              return null;
            } else {
              return null;
            }
          },
        ),
      ),
      DataCell(
        TextFormField(
          key: _uniqueKey,
          readOnly: true,
          inputFormatters: [
            NumericTextFormatter(),
          ],
          initialValue: ((num.tryParse(data[index]
                          .price!
                          .sum
                          .toString()
                          .pickOnlyNumbers()) ??
                      0) -
                  (num.tryParse(data[index]
                          .paid_dept!
                          .sum
                          .toString()
                          .pickOnlyNumbers()) ??
                      0))
              .toString()
              .formatMoney(),
          decoration: InputDecoration(
              suffix: Text(
                  data[index].paid_dept!.currency == "usd" ? "USD " : "SO'M "),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              hintText: "Umumiy hisob"),
        ),
      ),
      DataCell(SizedBox(
        width: 200.w,
        child: Visibility(
          visible: data[index].is_delivered != null,
          child: CheckboxListTile.adaptive(
              title: Text(
                  data[index].is_delivered! ? "Yetkazilgan" : "Yetkazilmagan"),
              value: data[index].is_delivered,
              onChanged: (v) {
                setState(() {
                  data[index].is_delivered = v;
                });
                final updatedElement = data[index]
                    .copyWith(is_delivered: data[index].is_delivered);
                _updateRent(updatedElement, index);
              }),
        ),
      )),
      DataCell(
        TextFormField(
          readOnly: true,
          initialValue: DateFormat(DateFormat.YEAR_MONTH_DAY)
              .format(DateTime.parse(data[index].given_date.toString())),
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              errorBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              hintText: "Berilgan sana"),
        ),
      ),
      DataCell(
        TextFormField(
          initialValue: data[index].received_date!.isNotEmpty
              ? DateFormat(DateFormat.YEAR_MONTH_DAY)
                  .format(DateTime.parse(data[index].received_date.toString()))
              : "Mavjud emas",
          inputFormatters: [FoxTextInputFormatter.dateFormatter],
          readOnly: false,
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              errorBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              hintText: "Yil-oy-kun"),
          onChanged: (v) async {
            if (v.length == 10) {
              final updatedElement = data[index].copyWith(received_date: v);
              _updateRent(updatedElement, index);
            }
          },
        ),
      ),
      DataCell(
        TextFormField(
          readOnly: true,
          initialValue: DateFormat(DateFormat.YEAR_MONTH_DAY)
              .format(DateTime.parse(data[index].created_at.toString())),
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              errorBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              hintText: "Qayd qilingan sana"),
          // onChanged: (v) {
          //   // final updatedElement = data[index].copyWith(product_type: v);

          //   // _updateRent(updatedElement, index);
          // },
        ),
      ),
    ]);
  }

  Future<void> _updateRent(RentModel updatedElement, int index) async {
    await Future.delayed(const Duration(seconds: 2)).then((value) => context
        .read<RentCubit>()
        .updateRent(
            id: updatedElement.id.toString(),
            rentModel: PostRentModel(
                tenantName: updatedElement.tenant_name.toString(),
                productType: updatedElement.product_type.toString(),
                price: PostPrice(
                    currency: updatedElement.price!.currency,
                    sum: num.tryParse(updatedElement.price
                            .toString()
                            .pickOnlyNumbers()) ??
                        0.0),
                paidDept: PostPrice(
                    currency: updatedElement.paid_dept!.currency,
                    sum: num.tryParse(updatedElement.paid_dept
                            .toString()
                            .pickOnlyNumbers()) ??
                        0.0),
                givenDate: updatedElement.given_date.toString(),
                receivedDate: updatedElement.received_date.toString(),
                phoneNumber: updatedElement.phone_number.toString(),
                isDelivered: updatedElement.is_delivered!),
            createdAt: updatedElement.created_at.toString()));
  }
}
