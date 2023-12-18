import 'package:accountant/domain/post_client_model.dart';
import 'package:accountant/helpers/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class RentsFireStoreService {
  final CollectionReference rentsCollection =
      FirebaseFirestore.instance.collection("clients");

  final uuid = const Uuid();

  ///
  Future<void> writeClient(PostClientModel clientModel) async {
    try {
      await rentsCollection.add({
        "client_name": clientModel.clientName,
        "products": [
          {
            "id": uuid.v4(),
            "product_type": clientModel.product!.productType ?? "",
            "price": clientModel.product!.price!.toMap(),
            "paid_money": clientModel.product!.paidMoney!.toMap(),
            "phone_number": clientModel.product!.phoneNumber ?? "",
            "given_date": clientModel.product!.givenDate ?? "",
          }
        ],
        "given_date": clientModel.givenDate,
        "created_at": DateTime.now().toLocal().toString(),
        "updated_at": DateTime.now().toLocal().toString()
      });
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
    }
  }

  ///
  Future<bool> updateClient(
      {required String id,
      required PostClientModel clientModel,
      required String createdAt}) async {
    try {
      await rentsCollection.doc(id).update({
        "tenant_name": clientModel.clientName,
        "products": [
          {
            "id": uuid.v4(),
            "product_type": clientModel.product!.productType ?? "",
            "price": clientModel.product!.price!.toMap(),
            "paid_money": clientModel.product!.paidMoney!.toMap(),
            "phone_number": clientModel.product!.phoneNumber ?? "",
            "given_date": clientModel.product!.givenDate ?? "",
          }
        ],
        "given_date": clientModel.givenDate,
        "created_at": DateTime.now().toLocal().toString(),
        "updated_at": DateTime.now().toLocal().toString()
      });
      return true;
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
      return false;
    }
  }

  ///
  Future<void> deleteClient(String clientId) async {
    await rentsCollection.doc(clientId).delete();
  }

  ///
  Future<void> deleteProduct(String priductId) async {
    await rentsCollection.doc(priductId).delete();
  }
}
