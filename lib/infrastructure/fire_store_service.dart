import 'package:accountant/domain/post_client_model.dart';
import 'package:accountant/helpers/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:accountant/domain/client_model.dart' as client;

class ProductsFireStoreService {
  final CollectionReference clientCollection =
      FirebaseFirestore.instance.collection("clients");

  final uuid = const Uuid();

  ///
  Future<void> writeClient(PostClientModel clientModel) async {
    try {
      await clientCollection.add({
        "client_name": clientModel.clientName,
        "phone_number": clientModel.phoneNumber ?? "",
        "created_at": DateTime.now().toString(),
        "updated_at": DateTime.now().toString(),
        "total_sum_uzs": "0.0",
        "total_sum_usd": "0.0"
      });
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
    }
  }

  ///
  Future<bool> updateClient(
      {required String id, required client.ClientModel clientModel}) async {
    try {
      await clientCollection.doc(id).update({
        "client_name": clientModel.client_name,
        "phone_number": clientModel.phone_number ?? "",
        "total_sum_uzs": clientModel.total_sum_uzs,
        "total_sum_usd": clientModel.total_sum_usd,
        "created_at": clientModel.created_at.toString(),
        "updated_at": DateTime.now().toString(),
      });
      return true;
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
      return false;
    }
  }

  ///
  Future<void> deleteClient(String clientId) async {
    await clientCollection.doc(clientId).delete();
  }
}
