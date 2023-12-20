import 'package:accountant/application/client/client_cubit.dart';
import 'package:accountant/domain/client_model.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:accountant/presentation/pages/details/emp_product_details_page.dart';
import 'package:accountant/presentation/pages/details/manager_product_details_page.dart';
import 'package:accountant/presentation/widgets/loading.dart';
import 'package:accountant/presentation/widgets/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeScreen extends StatefulWidget {
  final ClientState state;

  const EmployeeScreen({super.key, required this.state});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  late final TextEditingController _tenantNameController;
  late final TextEditingController _productTypeController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _tenantNameController = TextEditingController();
    _productTypeController = TextEditingController();

    _phoneController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(
              child: FoxLoadingWidget(),
            ),
        empty: () => const Center(
              child: Text("Sizda mijozlar mavjud emas"),
            ),
        error: (err) => Center(child: Text(err)),
        success: (data) {
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
                                builder: (context) =>
                                    EmployeeProductDetailsPage(
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
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Qoldiq: ",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                      "${data[index].total_sum_usd.toString().pickOnlyNumbers().formatMoney()} USD",
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400)),
                                  Text(
                                      "${data[index].total_sum_uzs.toString().pickOnlyNumbers().formatMoney()} UZS",
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(itemBuilder: (context) {
                            return [
                              // PopupMenuItem(
                              //     onTap: () {
                              //       _deleteClient(data[index].id.toString(),
                              //           data[index].client_name.toString());
                              //     },
                              //     child: Row(
                              //       children: [
                              //         const Icon(Icons.delete_outline),
                              //         Gap(5.w),
                              //         const Text("O'chirish")
                              //       ],
                              //     )),
                              PopupMenuItem(
                                  onTap: () {
                                    _updateClient(context, data[index]);
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.edit_outlined),
                                      Gap(5.w),
                                      const Text("Tahrirlash")
                                    ],
                                  ))
                            ];
                          })),
                    ),
                  );
                }),
          );
        });
  }

  // void _deleteClient(String id, String tenant) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: ListTile(
  //             title: Text("Mijoz: $tenant"),
  //           ),
  //           content: const Text("haqiqatdan o'chirmoqchimisiz?"),
  //           actions: [
  //             ElevatedButton
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text("Yo'q")),
  //             ElevatedButton(
  //                 onPressed: () {
  //                   context.read<ClientCubit>().deleteClient(id: id);
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text("Ha"))
  //           ],
  //         );
  //       });
  // }

  Future<dynamic> _updateClient(BuildContext context, ClientModel clientModel) {
    _tenantNameController.text = clientModel.client_name ?? "";
    _phoneController.text = clientModel.phone_number ?? "";

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Ma'lumotlarni yangilash",
                  style: TextStyle(fontSize: 18.0),
                ),
                IconButton(
                    onPressed: () {
                      _productTypeController.clear();

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
                      final updatedClient = clientModel.copyWith(
                          client_name: _tenantNameController.text,
                          phone_number: _tenantNameController.text);
                      context.read<ClientCubit>().updateClient(
                          id: clientModel.id.toString(),
                          rentModel: updatedClient);

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Yangilash"))
            ],
          );
        });
  }
}
