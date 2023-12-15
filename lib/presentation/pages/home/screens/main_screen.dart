import 'package:accountant/application/rent/rent_cubit.dart';
import 'package:accountant/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final RentState state;

  const MainScreen({super.key, required this.state});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabController.length,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [Tab(text: "Arendalar"), Tab(text: "Qarzlar")],
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                widget.state.when(
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
                              border: TableBorder.all(
                                  color: const Color(0xffF2F4F7)),
                              columns: const [
                                DataColumn(label: Text("Ijarachi ismi")),
                                DataColumn(label: Text("Mahsulot turi")),
                                DataColumn(label: Text("Narxi")),
                                DataColumn(label: Text("To'langan summa")),
                                DataColumn(label: Text("Ijarachining qarzi")),
                                DataColumn(label: Text("Umumiy hisob"))
                              ],
                              rows: List.generate(
                                  data.length,
                                  (index) => DataRow(cells: [
                                        DataCell(
                                          TextFormField(
                                            initialValue: data[index]
                                                .tenant_name
                                                .toString(),
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .transparent)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red)),
                                                hintText: "Ijarachi ismi"),
                                          ),
                                        ),
                                        DataCell(
                                          TextFormField(
                                            initialValue:
                                                data[index].product_type,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .transparent)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red)),
                                                hintText: "Mahsulot turi"),
                                          ),
                                        ),
                                        DataCell(
                                          TextFormField(
                                            initialValue: data[index].price,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .transparent)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red)),
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
                                                        color: Colors
                                                            .transparent)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red)),
                                                hintText:
                                                    "Ijarachi to'lagan summa"),
                                          ),
                                        ),
                                        DataCell(
                                          TextFormField(
                                            initialValue: "100,000",
                                            decoration: const InputDecoration(
                                                suffix: Text("SO'M"),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .transparent)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red)),
                                                hintText:
                                                    "Ijarachining qolgan qarzi"),
                                          ),
                                        ),
                                        DataCell(
                                          TextFormField(
                                            initialValue: "100,000",
                                            decoration: const InputDecoration(
                                                suffix: Text("SO'M"),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .transparent)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red)),
                                                hintText: "Umumiy hisob"),
                                          ),
                                        ),
                                      ]))),
                        )),
                const Center(child: Text("Qarz"))
              ]),
            )
          ],
        ));
  }
}
