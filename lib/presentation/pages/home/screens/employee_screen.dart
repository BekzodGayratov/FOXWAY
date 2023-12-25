import 'package:accountant/domain/client_model.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:accountant/presentation/pages/details/employe/employee_product_details_page.dart';
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
  final _formKey = GlobalKey<FormState>();

  //
  late Future<QuerySnapshot<Map<String, dynamic>>>? clientSnapshot;
  late final CollectionReference<Map<String, dynamic>> clientCollection;

  num totalSumUzs = 0.0;
  num totalSumUsd = 0.0;

  @override
  void initState() {
    _tenantNameController = TextEditingController();
    _productTypeController = TextEditingController();
    _phoneController = TextEditingController();

    clientCollection = FirebaseFirestore.instance.collection("clients");
    clientSnapshot = FirebaseFirestore.instance
        .collection("clients")
        .orderBy("created_at")
        .get();

    super.initState();
  }

  @override
  void dispose() {
    _tenantNameController.dispose();
    _productTypeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    setState(() {
      // Reinitialize the future to trigger a rebuild
      clientSnapshot = FirebaseFirestore.instance
          .collection("clients")
          .orderBy("created_at")
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: clientSnapshot,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs
                .map((e) => ClientModel.fromMap(e.data()))
                .toList();
            for (var i = 0; i < snapshot.data!.docs.length; i++) {
              data[i].id = snapshot.data!.docs[i].id.toString();
            }
            totalSumUsd = 0.0;
            totalSumUzs = 0.0;
            for (var i = 0; i < data.length; i++) {
              totalSumUsd += data[i].total_sum_usd ?? 0;
              totalSumUzs += data[i].total_sum_uzs ?? 0;
            }

            return data.isEmpty
                ? RefreshIndicator(
                    onRefresh: refreshData,
                    child: Center(
                      child: ListView(
                        children: [
                          Gap(100.h),
                          const Align(
                              alignment: Alignment.center,
                              child: Text("Mijozlar mavjud emas")),
                        ],
                      ),
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
            subtitle: Text(
              data[index].phone_number.toString(),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
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
                    )),
                // PopupMenuItem(
                //     onTap: () {
                //       _removeMoneyToClientSum(context, data[index]);
                //     },
                //     child: Row(
                //       children: [
                //         const Icon(Icons.remove),
                //         Gap(5.w),
                //         const Text("Aylanma puldan ayirish")
                //       ],
                //     )),
                // PopupMenuItem(
                //     onTap: () {
                //       _addMoneyToClientSum(context, data[index]);
                //     },
                //     child: Row(
                //       children: [
                //         const Icon(Icons.add),
                //         Gap(5.w),
                //         const Text("Aylanma pulga qo'shish")
                //       ],
                //     )),
              ];
            })),
      ),
    );
  }
}
