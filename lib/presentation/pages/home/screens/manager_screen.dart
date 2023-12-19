import 'package:accountant/application/product/product_cubit.dart';
import 'package:accountant/domain/client_model.dart';
import 'package:accountant/helpers/show_message.dart';
import 'package:accountant/presentation/pages/product_details_page.dart';
import 'package:accountant/presentation/widgets/loading.dart';
import 'package:accountant/presentation/widgets/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManagerScreen extends StatefulWidget {
  final ProductState state;

  const ManagerScreen({super.key, required this.state});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  GlobalKey<_ManagerScreenState> _dataTableKey = GlobalKey();
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

          return Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return FoxWayPadding(
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                element: data[index],
                              ),
                            ),
                          );
                        },
                        leading: Text(
                          "${index + 1}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        title: Text(data[index].client_name.toString(),
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500)),
                        subtitle: Text(
                            "Tovarlar soni: ${data[index].products.length.toString()}",
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w400)),
                      ),
                    ),
                  );
                }),
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProductDetailsPage(data: data[index]),
          //   ),
          // );
        },
        cells: [
          DataCell(
            Text("${index + 1}"),
          ),
          DataCell(
            Text(data[index].client_name.toString()),
          ),
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
