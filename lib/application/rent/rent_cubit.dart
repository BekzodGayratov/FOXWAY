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

  final RentsFireStoreService _rentsFireStoreService = RentsFireStoreService();

  ///
  Future<void> getRents() async {
    emit(const RentState.loading());

    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> rentSnapshot =
          _rentsFireStoreService.rentsCollection
              .orderBy("created_at")
              .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;

      rentSnapshot.listen((event) async {
        List<RentModel> remoteData =
            event.docs.map((e) => RentModel.fromMap(e.data())).toList();
        for (var i = 0; i < event.docs.length; i++) {
          remoteData[i].id = event.docs[i].id;
        }

        if (remoteData.isEmpty) {
          emit(const RentState.empty());
        } else {
          emit(RentState.success(remoteData));
        }
      });
    } on FirebaseException catch (e) {
      emit(RentState.error(e.message.toString()));
    }
  }

  ///

  Future<void> postRent(PostRentModel rentModel) async {
    await _rentsFireStoreService.writeData(rentModel);
  }
}
