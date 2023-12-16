import 'package:accountant/domain/post_rent_model.dart';
import 'package:accountant/helpers/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RentsFireStoreService {
  final CollectionReference rentsCollection =
      FirebaseFirestore.instance.collection("rents");

  ///
  Future<void> writeRent(PostRentModel rentModel) async {
    try {
      await rentsCollection.add({
        "tenant_name": rentModel.tenantName,
        "product_type": rentModel.productType,
        "price": rentModel.price!.toMap(),
        "paid_dept": rentModel.paidDept!.toMap(),
        "given_date": rentModel.givenDate,
        "received_date": rentModel.receivedDate,
        "phone_number": rentModel.phoneNumber,
        "is_delivered": rentModel.isDelivered,
        "created_at": DateTime.now().toLocal().toString(),
        "updated_at": DateTime.now().toLocal().toString()
      });
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
    }
  }

  ///
  Future<bool> updateRent(
      {required String id,
      required PostRentModel rentModel,
      required String createdAt}) async {
    try {
      await rentsCollection.doc(id).update({
        "tenant_name": rentModel.tenantName,
        "product_type": rentModel.productType,
        "price": rentModel.price!.toMap(),
        "paid_dept": rentModel.paidDept!.toMap(),
        "given_date": rentModel.givenDate,
        "received_date": rentModel.receivedDate.toString(),
        "phone_number": rentModel.phoneNumber,
        "is_delivered": rentModel.isDelivered,
        "created_at": createdAt,
        "updated_at": Timestamp.now().toDate().toLocal().toString()
      });
      return true;
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
      return false;
    }
  }

  ///

  Future<QuerySnapshot<Map<String, dynamic>>?> getRentWithId(String id) async {
    try {
      return await rentsCollection.doc(id).get()
          as QuerySnapshot<Map<String, dynamic>>;
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
      return null;
    }
  }

  ///

  Future<void> deleteRent(String id) async {
    await rentsCollection.doc(id).delete();
  }
}
