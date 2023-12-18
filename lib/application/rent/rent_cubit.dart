import 'dart:async';
import 'package:accountant/domain/client_model.dart';
import 'package:accountant/domain/post_client_model.dart';
import 'package:accountant/infrastructure/fire_store_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'rent_state.dart';
part 'rent_cubit.freezed.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductState.initial()) {
    getProducts();
  }

  //UZS
  double totalDeptSom = 0.0;
  double totalPaidDeptSom = 0.0;
  double totalPriceSom = 0.0;
  //USD
  double totalDeptUsd = 0.0;
  double totalPaidDeptUsd = 0.0;
  double totalPriceUsd = 0.0;

  final RentsFireStoreService _rentsFireStoreService = RentsFireStoreService();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? myStreamSubscription;

  List<ClientModel>? clients;

  ///
  Future<void> getProducts() async {
    emit(const ProductState.loading());

    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> rentSnapshot =
          _rentsFireStoreService.rentsCollection
              .orderBy("created_at")
              .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;

      myStreamSubscription = rentSnapshot.listen((event) async {
        clients = event.docs.map((e) => ClientModel.fromMap(e.data())).toList();
        for (var i = 0; i < event.docs.length; i++) {
          clients![i].id = event.docs[i].id;
        }

        if (clients!.isEmpty) {
          emit(const ProductState.empty());
        } else {
          // calculateTotalPrice();
          // calculateTotalPaidDept();
          // calculateTotalDept();

          emit(ProductState.success(clients!));
        }
      });
    } on FirebaseException catch (e) {
      emit(ProductState.error(e.message.toString()));
    }
  }

  ///

  Future<void> postClient(PostClientModel rentModel) async {
    await _rentsFireStoreService.writeClient(rentModel);
    // calculateTotalPrice();
    // calculateTotalPaidDept();
    // calculateTotalDept();
  }

  ///
  Future<void> updateClient(
      {required String id,
      required PostClientModel rentModel,
      required String createdAt}) async {
    await _rentsFireStoreService.updateClient(
        id: id, clientModel: rentModel, createdAt: createdAt);
    // calculateTotalPrice();
    // calculateTotalPaidDept();
    // calculateTotalDept();
  }

  ///
  Future<void> deleteClient({required String id}) async {
    await _rentsFireStoreService.deleteClient(id);
    // calculateTotalPrice();
    // calculateTotalPaidDept();
    // calculateTotalDept();
  }

  void calculateTotalDept() {
    totalDeptSom = 0.0;
    totalDeptUsd = 0.0;
    for (var e in clients!) {
      for (var element in e.products) {
        if (element!.paid_money!.currency == "sum") {
          totalDeptSom += element.price!.sum! - element.paid_money!.sum!;
        } else {
          totalDeptUsd += element.price!.sum! - element.paid_money!.sum!;
        }
      }
    }
  }

  void calculateTotalPaidDept() {
    totalPaidDeptSom = 0.0;
    totalPaidDeptUsd = 0.0;
    for (var e in clients!) {
      for (var element in e.products) {
        if (element!.paid_money!.currency == "sum") {
          totalPaidDeptSom += element.paid_money!.sum ?? 0.0;
        } else {
          totalPaidDeptUsd += element.paid_money!.sum ?? 0.0;
        }
      }
    }
  }

  void calculateTotalPrice() {
    totalPriceSom = 0.0;
    totalPriceUsd = 0.0;
    for (var e in clients!) {
      for (var element in e.products) {
        if (element!.price!.currency == "sum") {
          totalPriceSom += element.price!.sum ?? 0.0;
        } else {
          totalPriceUsd += element.price!.sum ?? 0.0;
        }
      }
    }
  }
}
