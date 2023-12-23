import 'package:accountant/domain/client_model.dart';
import 'package:accountant/domain/product_model.dart';
import 'package:accountant/helpers/input_formatters.dart';
import 'package:accountant/presentation/extension/ext.dart';
import 'package:accountant/presentation/pages/details/manager_product_details_page.dart';
import 'package:accountant/presentation/widgets/padding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  late final TextEditingController _tenantNameController;
  late final TextEditingController _productTypeController;
  late final TextEditingController _phoneController;
  late final TextEditingController _priceController;
  final _formKey = GlobalKey<FormState>();

  //
  late Stream<QuerySnapshot<Map<String, dynamic>>>? clientSnapshot;
  late final CollectionReference<Map<String, dynamic>> clientCollection;
  late String _currency;
  num totalSumUzs = 0.0;
  num totalSumUsd = 0.0;

  @override
  void initState() {
    _priceController = TextEditingController();
    _tenantNameController = TextEditingController();
    _productTypeController = TextEditingController();
    _phoneController = TextEditingController();
    _currency = "sum";

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
            totalSumUsd = 0.0;
            totalSumUzs = 0.0;
            for (var i = 0; i < data.length; i++) {
              totalSumUsd += data[i].total_sum_usd ?? 0;
              totalSumUzs += data[i].total_sum_uzs ?? 0;
            }

            return data.isEmpty
                ? const Center(
                    child: Text("Mijozlar mavjud emas"),
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
                                        "${totalSumUzs.toString().formatMoney()} UZS",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white)),
                                    Text(
                                        "${totalSumUsd.toString().formatMoney()} USD",
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

  void _deleteClient(String id, String tenant) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: ListTile(
              title: Text("Mijoz: $tenant"),
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
                    clientCollection.doc(id).delete();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ha"))
            ],
          );
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

  Future<dynamic> _addMoneyToClientSum(
      BuildContext context, ClientModel clientModel) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pulni qo'shish",
                  style: TextStyle(fontSize: 18.0),
                ),
                IconButton(
                    onPressed: () {
                      _priceController.clear();

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
                        Text(
                            "${clientModel.client_name} dan siz qancha pul oldingiz?"),
                        Gap(10.h),
                        TextFormField(
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
                      if (_currency == "sum") {
                        final totalSum = clientModel.total_sum_uzs!.toDouble() +
                            (num.tryParse(_priceController.text
                                        .pickOnlyNumbers()) ??
                                    0.0)
                                .toDouble();

                        final updatedClient =
                            clientModel.copyWith(total_sum_uzs: totalSum);
                        clientCollection.doc(clientModel.id).update({
                          "client_name": updatedClient.client_name,
                          "phone_number": updatedClient.phone_number ?? "",
                          "total_sum_uzs": updatedClient.total_sum_uzs,
                          "total_sum_usd": updatedClient.total_sum_usd,
                          "created_at": updatedClient.created_at.toString(),
                          "updated_at": DateTime.now().toString(),
                        });
                        _priceController.clear();
                        Navigator.of(context).pop();
                        return;
                      } else {
                        final totalSum = clientModel.total_sum_usd!.toDouble() +
                            (num.tryParse(_priceController.text
                                        .pickOnlyNumbers()) ??
                                    0.0)
                                .toDouble();

                        final updatedClient =
                            clientModel.copyWith(total_sum_usd: totalSum);
                        clientCollection.doc(clientModel.id).update({
                          "client_name": updatedClient.client_name,
                          "phone_number": updatedClient.phone_number ?? "",
                          "total_sum_uzs": updatedClient.total_sum_uzs,
                          "total_sum_usd": updatedClient.total_sum_usd,
                          "created_at": updatedClient.created_at.toString(),
                          "updated_at": DateTime.now().toString(),
                        });
                        _priceController.clear();
                        Navigator.of(context).pop();
                        return;
                      }
                    }
                  },
                  child: const Text("Yangilash"))
            ],
          );
        });
  }

  Future<dynamic> _removeMoneyToClientSum(
      BuildContext context, ClientModel clientModel) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pulni ayirish",
                  style: TextStyle(fontSize: 18.0),
                ),
                IconButton(
                    onPressed: () {
                      _priceController.clear();

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
                        Text(
                            "${clientModel.client_name} sizga qancha pul berdi?"),
                        Gap(10.h),
                        TextFormField(
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
                      if (_currency == "sum") {
                        final totalSum = clientModel.total_sum_uzs!.toInt() -
                            (int.tryParse(_priceController.text
                                        .pickOnlyNumbers()) ??
                                    0.0)
                                .toInt();

                        final updatedClient =
                            clientModel.copyWith(total_sum_uzs: totalSum);

                        clientCollection.doc(clientModel.id).update({
                          "client_name": updatedClient.client_name,
                          "phone_number": updatedClient.phone_number ?? "",
                          "total_sum_uzs": updatedClient.total_sum_uzs,
                          "total_sum_usd": updatedClient.total_sum_usd,
                          "created_at": updatedClient.created_at.toString(),
                          "updated_at": DateTime.now().toString(),
                        });
                        _priceController.clear();
                        Navigator.of(context).pop();
                        return;
                      } else {
                        final totalSum = clientModel.total_sum_usd!.toInt() -
                            (int.tryParse(_priceController.text
                                        .pickOnlyNumbers()) ??
                                    0.0)
                                .toInt();

                        final updatedClient =
                            clientModel.copyWith(total_sum_usd: totalSum);
                        clientCollection.doc(clientModel.id).update({
                          "client_name": updatedClient.client_name,
                          "phone_number": updatedClient.phone_number ?? "",
                          "total_sum_uzs": updatedClient.total_sum_uzs,
                          "total_sum_usd": updatedClient.total_sum_usd,
                          "created_at": updatedClient.created_at.toString(),
                          "updated_at": DateTime.now().toString(),
                        });
                        _priceController.clear();
                        Navigator.of(context).pop();
                        return;
                      }
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
                  builder: (context) => ManagerProductDetailsPage(
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
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        "${data[index].total_sum_usd.toString().formatMoney()} USD",
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400)),
                    Text(
                        "${data[index].total_sum_uzs.toString().formatMoney()} UZS",
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400)),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                    onTap: () {
                      _deleteClient(data[index].id.toString(),
                          data[index].client_name.toString());
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline),
                        Gap(5.w),
                        const Text("O'chirish")
                      ],
                    )),
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
                PopupMenuItem(
                    onTap: () {
                      _removeMoneyToClientSum(context, data[index]);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.remove),
                        Gap(5.w),
                        const Text("Aylanma puldan ayirish")
                      ],
                    )),
                PopupMenuItem(
                    onTap: () {
                      _addMoneyToClientSum(context, data[index]);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.add),
                        Gap(5.w),
                        const Text("Aylanma pulga qo'shish")
                      ],
                    )),
              ];
            })),
      ),
    );
  }
}
