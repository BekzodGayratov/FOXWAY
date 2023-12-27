import 'package:accountant/domain/client_model.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:accountant/presentation/pages/details/employee/employee_product_details_page.dart';
import 'package:accountant/presentation/widgets/padding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  late final TextEditingController _tenantNameController;
  late final TextEditingController _productTypeController;
  late final TextEditingController _phoneController;
  late final TextEditingController _priceController;
  final _formKey = GlobalKey<FormState>();

  //
  late Stream<QuerySnapshot<Map<String, dynamic>>>? clientSnapshot;
  late final CollectionReference<Map<String, dynamic>> clientCollection;
  num totalSumUzs = 0.0;
  num totalSumUsd = 0.0;

  @override
  void initState() {
    _priceController = TextEditingController();
    _tenantNameController = TextEditingController();
    _productTypeController = TextEditingController();
    _phoneController = TextEditingController();

    clientCollection = FirebaseFirestore.instance.collection("clients");
    clientSnapshot = FirebaseFirestore.instance
        .collection("clients")
        .orderBy("created_at")
        .snapshots();

    super.initState();
  }

  @override
  void dispose() {
    _tenantNameController.dispose();
    _productTypeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: clientSnapshot,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs
                .map((e) => ClientModel.fromMap(e.data()))
                .toList();
            for (var i = 0; i < snapshot.data!.docs.length; i++) {
              data[i].id = snapshot.data!.docs[i].id.toString();
            }

            _calculateTotalSum(data);

            return data.isEmpty
                ? Center(
                    child: ListView(
                      children: [
                        Gap(100.h),
                        const Align(
                            alignment: Alignment.center,
                            child: Text("Mijozlar mavjud emas")),
                      ],
                    ),
                  )
                : Scaffold(
                    body: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            bool showDate = index == 0 ||
                                _isMonthChanged(data[index - 1], data[index]);
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (showDate)
                                  _buildDateHeader(
                                      data[index].created_at.toString()),
                                _buildProductItem(data, index)
                              ],
                            );
                          }),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.endFloat,
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      onPressed: () async {
                        await _showAddClientDialog(context);
                        setState(() {});
                      },
                      child: const Icon(Icons.add),
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
                                        "${(totalSumUzs.abs()).toString().formatMoney()} UZS",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white)),
                                    Text(
                                        "${(totalSumUsd.abs()).toString().formatMoney()} USD",
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
        });
  }

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
                          phone_number: _phoneController.text);
                      clientCollection.doc(clientModel.id).update({
                        "client_name": updatedClient.client_name,
                        "phone_number": updatedClient.phone_number ?? "",
                        "total_sum_uzs": updatedClient.total_sum_uzs,
                        "total_sum_usd": updatedClient.total_sum_usd,
                        "created_at": updatedClient.created_at.toString(),
                        "updated_at": DateTime.now().toString(),
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Yangilash"))
            ],
          );
        });
  }

  bool _isMonthChanged(ClientModel prevProduct, ClientModel currentProduct) {
    // Compare the months of the previous and current products
    return DateTime.parse(prevProduct.created_at.toString()).month !=
        DateTime.parse(currentProduct.created_at.toString()).month;
  }

  Widget _buildDateHeader(String data) {
    // Format the date header as needed
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        DateFormat('MMMM yyyy').format(DateTime.parse(data)),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProductItem(List<ClientModel> data, int index) {
    final theme = Theme.of(context);
    return FoxWayPadding(
      child: Card(
        child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeProductDetailsPage(
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
                const Text("Qoldiq:"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        "${(data[index].total_sum_usd!.abs()).toString().formatMoney()} USD",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                    Text(
                        "${(data[index].total_sum_uzs!.abs()).toString().formatMoney()} UZS",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                  ],
                )
              ],
            ),
            trailing: PopupMenuButton(itemBuilder: (context) {
              return [
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
                    )),
              ];
            })),
      ),
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
                      clientCollection.add({
                        "client_name": _tenantNameController.text,
                        "phone_number": _phoneController.text,
                        "created_at": DateTime.now().toString(),
                        "updated_at": DateTime.now().toString(),
                        "total_sum_uzs": 0.0,
                        "total_sum_usd": 0.0,
                      }).then((value) {
                        _productTypeController.clear();
                        _priceController.clear();
                        _phoneController.clear();
                        _tenantNameController.clear();
                      });

                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text("Qo'shish"))
            ],
          );
        });
  }

  Future<void> _calculateTotalSum(List<ClientModel> clients) async {
    if (clients.isNotEmpty) {
      totalSumUzs = 0.0;
      totalSumUsd = 0.0;
      for (var element in clients) {
        totalSumUzs += element.total_sum_uzs!.abs();
        totalSumUsd += element.total_sum_usd!.abs();
      }
    }
  }
}
