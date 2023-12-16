import 'dart:async';
import 'package:accountant/domain/post_rent_model.dart';
import 'package:accountant/domain/rent_model.dart';
import 'package:accountant/helpers/show_message.dart';
import 'package:accountant/infrastructure/fire_store_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'rent_state.dart';
part 'rent_cubit.freezed.dart';

class RentCubit extends Cubit<RentState> {
  RentCubit() : super(const RentState.initial()) {
    getRents();
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

  List<RentModel>? rents;

  ///
  Future<void> getRents() async {
    emit(const RentState.loading());

    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> rentSnapshot =
          _rentsFireStoreService.rentsCollection
              .orderBy("created_at")
              .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;

      myStreamSubscription = rentSnapshot.listen((event) async {
        rents = event.docs.map((e) => RentModel.fromMap(e.data())).toList();
        for (var i = 0; i < event.docs.length; i++) {
          rents![i].id = event.docs[i].id;
        }

        if (rents!.isEmpty) {
          emit(const RentState.empty());
        } else {
          calculateTotalPrice();
          calculateTotalPaidDept();
          calculateTotalDept();

          emit(RentState.success(rents!));
        }
      });
    } on FirebaseException catch (e) {
      emit(RentState.error(e.message.toString()));
    }
  }

  ///

  Future<void> postRent(PostRentModel rentModel) async {
    await _rentsFireStoreService.writeRent(rentModel);
    calculateTotalPrice();
    calculateTotalPaidDept();
    calculateTotalDept();
  }

  ///
  Future<void> updateRent(
      {required String id,
      required PostRentModel rentModel,
      required String createdAt}) async {
    await _rentsFireStoreService.updateRent(
        id: id, rentModel: rentModel, createdAt: createdAt);
    calculateTotalPrice();
    calculateTotalPaidDept();
    calculateTotalDept();
  }

  ///
  Future<void> deleteRent({required String id}) async {
    await _rentsFireStoreService.deleteRent(id);
    calculateTotalPrice();
    calculateTotalPaidDept();
    calculateTotalDept();
  }

  void calculateTotalDept() {
    totalDeptSom = 0.0;
    totalDeptUsd = 0.0;
    for (var element in rents!) {
      if (element.paid_dept!.currency == "sum") {
        totalDeptSom += element.price!.sum! - element.paid_dept!.sum!;
      } else {
        totalDeptUsd += element.price!.sum! - element.paid_dept!.sum!;
      }
    }
  }

  void calculateTotalPaidDept() {
    totalPaidDeptSom = 0.0;
    totalPaidDeptUsd = 0.0;
    for (var element in rents!) {
      if (element.paid_dept!.currency == "sum") {
        totalPaidDeptSom += element.paid_dept!.sum!;
      } else {
        totalPaidDeptUsd += element.paid_dept!.sum!;
      }
    }
  }

  void calculateTotalPrice() {
    totalPriceSom = 0.0;
    totalPriceUsd = 0.0;

    for (var element in rents!) {
      if (element.paid_dept!.currency == "sum") {
        totalPriceSom += element.price!.sum!;
      } else {
        totalPriceUsd += element.price!.sum!;
      }
    }
  }
}
