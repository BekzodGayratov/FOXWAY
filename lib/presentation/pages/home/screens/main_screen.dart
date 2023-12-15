import 'package:accountant/application/rent/rent_cubit.dart';
import 'package:accountant/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatefulWidget {
  final RentState state;

  const MainScreen({super.key, required this.state});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
        success: (data) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  showCheckboxColumn: false,
                  border: TableBorder.all(color: const Color(0xffF2F4F7)),
                  columns: const [
                    DataColumn(label: Text("Ijarachi ismi")),
                    DataColumn(label: Text("Mahsulot turi")),
                    DataColumn(label: Text("Narxi")),
                    DataColumn(label: Text("To'langan summa")),
                    DataColumn(label: Text("Ijarachining qarzi")),
                    DataColumn(label: Text("Holati")),
                    DataColumn(label: Text("Umumiy hisob"))
                  ],
                  rows: List.generate(
                      data.length,
                      (index) => DataRow(cells: [
                            DataCell(
                              TextFormField(
                                initialValue:
                                    data[index].tenant_name.toString(),
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
                                    hintText: "Ijarachi ismi"),
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                initialValue: data[index].product_type,
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
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                initialValue: data[index].price,
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
                                    hintText: "Mahsulot narxi"),
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                initialValue: data[index].paid_dept,
                                decoration: const InputDecoration(
                                    suffix: Text("SO'M"),
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
                                    hintText: "Ijarachi to'lagan summa"),
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                initialValue: "100,000",
                                decoration: const InputDecoration(
                                    suffix: Text("SO'M"),
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
                                    hintText: "Ijarachining qolgan qarzi"),
                              ),
                            ),
                            DataCell(SizedBox(
                              width: 200.w,
                              child: Visibility(
                                visible: data[index].is_delivered != null,
                                child: CheckboxListTile.adaptive(
                                    title: Text(data[index].is_delivered!
                                        ? "Yetkazilgan"
                                        : "Yetkazilmagan"),
                                    value: data[index].is_delivered,
                                    onChanged: (v) {
                                      setState(() {
                                        data[index].is_delivered = v;
                                      });
                                    }),
                              ),
                            )),
                            DataCell(
                              TextFormField(
                                initialValue: "100,000",
                                decoration: const InputDecoration(
                                    suffix: Text("SO'M"),
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
                                    hintText: "Umumiy hisob"),
                              ),
                            ),
                          ]))),
            ));
  }
}
