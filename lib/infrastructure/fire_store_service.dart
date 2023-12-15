import 'package:accountant/domain/post_rent_model.dart';
import 'package:accountant/helpers/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RentsFireStoreService {
  final CollectionReference rentsCollection =
      FirebaseFirestore.instance.collection("rents");

  ///
  Future<void> writeData(PostRentModel rentModel) async {
    try {
      await rentsCollection.add({
        "tenant_name": rentModel.tenantName,
        "product_type": rentModel.productType,
        "price": rentModel.price,
        "paid_dept": rentModel.paidDept,
        "give_date": rentModel.givenDate,
        "received_date": rentModel.receivedDate,
        "phone_number": rentModel.phoneNumber,
        "is_delivered": rentModel.isDelivered,
        "created_at": Timestamp.now().toDate().toLocal().toString(),
        "updated_at": Timestamp.now().toDate().toLocal().toString()
      });
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
    }
  }

  ///
  Future<bool> updateData(
      {required String id, required PostRentModel rentModel}) async {
    try {
      await rentsCollection.doc(id).update({
        "tenant_ame": rentModel.tenantName,
        "product_type": rentModel.productType,
        "price": rentModel.price,
        "paid_dept": rentModel.paidDept,
        "give_date": rentModel.givenDate,
        "received_date": rentModel.receivedDate,
        "phone_number": rentModel.phoneNumber,
        "is_delivered": rentModel.isDelivered,
        "created_at": Timestamp.now().toDate().toLocal().toString(),
        "updated_at": Timestamp.now().toDate().toLocal().toString()
      });
      return true;
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
      return false;
    }
  }

  ///

  Future<void> deleteData(String id) async {
    await rentsCollection.doc(id).delete();
  }
}
