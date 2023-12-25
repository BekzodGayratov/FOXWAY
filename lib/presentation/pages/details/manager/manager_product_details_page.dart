import 'package:accountant/domain/client_model.dart';
import 'package:accountant/presentation/pages/details/manager/tabs/products_tab.dart';
import 'package:accountant/presentation/pages/details/manager/tabs/sum_tab.dart';
import 'package:flutter/material.dart';

class ManagerProductDetailsPage extends StatefulWidget {
  final ClientModel element;
  const ManagerProductDetailsPage({super.key, required this.element});

  @override
  State<ManagerProductDetailsPage> createState() =>
      _ManagerProductDetailsPageState();
}

class _ManagerProductDetailsPageState extends State<ManagerProductDetailsPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  //
  double totalPriceUzs = 0.0;
  double totalPriceUsd = 0.0;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.amber,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mijoz: ${widget.element.client_name.toString()}",
              style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
            Text("Telefon: ${widget.element.phone_number}",
                style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white))
          ],
        ),
        bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            controller: _tabController,
            tabs: const [
              Tab(text: "Tovarlar"),
              Tab(text: "Aylanma pullar"),
            ]),
      ),
      body: TabBarView(controller: _tabController, children: [
        ManagerProductTab(element: widget.element),
        ManagerSumTab(element: widget.element),
      ]),
    );
  }
}
