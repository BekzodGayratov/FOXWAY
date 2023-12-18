import 'package:accountant/application/rent/rent_cubit.dart';
import 'package:accountant/domain/client_model.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:accountant/presentation/pages/product_details_page.dart';
import 'package:accountant/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeScreen extends StatefulWidget {
  final ProductState state;

  const EmployeeScreen({super.key, required this.state});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
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
                  //decoration: const BoxDecoration(color: Colors.red),
                  showCheckboxColumn: false,
                  headingTextStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  // headingRowColor: MaterialStateProperty.all(Colors.blue[200]),
                  // dataRowColor: MaterialStateProperty.all(Colors.blue[50]),
                  border: TableBorder.all(color: const Color(0xffF2F4F7)),
                  columns: const [
                    DataColumn(label: Text("#")),
                    DataColumn(label: Text("Mijoz ismi")),
                    DataColumn(label: Text("Barcha olingan tovar narxi")),
                    DataColumn(label: Text("Umumiy to'lagan summa")),
                    DataColumn(label: Text("Berishi kerak")),
                    DataColumn(label: Text("O'chirish"))
                  ],
                  rows: List.generate(
                    data.length,
                    (index) => _returnDataRow(data, index, context),
                  )),
            ),
          );
        });
  }

  void _deleteClient(String id, String tenant, String product) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: ListTile(
              title: Text("Ijarachi: $tenant"),
              subtitle: Text("Mahsulot: $product"),
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
                    context.read<ProductCubit>().deleteClient(id: id);
                  },
                  child: const Text("Ha"))
            ],
          );
        });
  }

  DataRow _returnDataRow(
      List<ClientModel> data, int index, BuildContext context) {
    return DataRow(
        onSelectChanged: (v) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage(data: data[index]),
            ),
          );
        },
        cells: [
          DataCell(
            Text("${index + 1}"),
          ),
          DataCell(
            Text(data[index].client_name.toString()),
          ),
          // DataCell(Text(data[index].price!.sum.toString().formatMoney())),
          // DataCell(Text(data[index].paid_dept!.sum.toString().formatMoney())),
          // DataCell(Text(((num.tryParse(data[index]
          //                 .price!
          //                 .sum
          //                 .toString()
          //                 .pickOnlyNumbers()) ??
          //             0) -
          //         (num.tryParse(data[index]
          //                 .paid_dept!
          //                 .sum
          //                 .toString()
          //                 .pickOnlyNumbers()) ??
          //             0))
          //     .toString()
          //     .formatMoney())),
          // DataCell(
          //   TextFormField(
          //     readOnly: true,
          //     initialValue: DateFormat(DateFormat.YEAR_MONTH_DAY)
          //         .format(DateTime.parse(data[index].given_date.toString())),
          //     decoration: const InputDecoration(
          //         border: OutlineInputBorder(
          //             borderSide: BorderSide(color: Colors.transparent)),
          //         enabledBorder: OutlineInputBorder(
          //             borderSide: BorderSide(color: Colors.transparent)),
          //         focusedBorder: OutlineInputBorder(
          //             borderSide: BorderSide(color: Colors.transparent)),
          //         errorBorder: OutlineInputBorder(
          //             borderSide: BorderSide(color: Colors.red)),
          //         hintText: "Berilgan sana"),
          //   ),
          // ),
          // DataCell(ElevatedButton(
          //   onPressed: () {
          //     _deleteClient(
          //         data[index].id.toString(),
          //         data[index].tenant_name.toString(),
          //         data[index].product_type.toString());
          //   },
          //   child: const Text("O'chirish"),
          // )),
        ]);
  }

  // Future<void> _updateClient(RentModel updatedElement, int index) async {
  //   await Future.delayed(const Duration(seconds: 2))
  //       .then((value) => context.read<ProductCubit>().updateClient(
  //           id: updatedElement.id.toString(),
  //           rentModel: postClientModel(
  //             tenantName: updatedElement.tenant_name.toString(),
  //             productType: updatedElement.product_type.toString(),
  //             price: PostPrice(
  //                 currency: updatedElement.price!.currency,
  //                 sum: num.tryParse(
  //                         updatedElement.price.toString().pickOnlyNumbers()) ??
  //                     0.0),
  //             paidDept: PostPrice(
  //                 currency: updatedElement.paid_dept!.currency,
  //                 sum: num.tryParse(updatedElement.paid_dept
  //                         .toString()
  //                         .pickOnlyNumbers()) ??
  //                     0.0),
  //             givenDate: updatedElement.given_date.toString(),
  //             phoneNumber: updatedElement.phone_number.toString(),
  //           ),
  //           createdAt: updatedElement.created_at.toString()));
  // }
}
