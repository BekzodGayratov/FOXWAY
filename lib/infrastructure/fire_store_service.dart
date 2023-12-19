import 'package:accountant/domain/client_model.dart';
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
        "given_date": clientModel.givenDate,
        "created_at": FieldValue.serverTimestamp(),
        "updated_at": FieldValue.serverTimestamp(),
        "products": [
          {
            "id": uuid.v4(),
            "product_type": clientModel.product!.productType ?? "",
            "price": clientModel.product!.price!.toMap(),
            "paid_money": clientModel.product!.paidMoney!.toMap(),
            "given_date": clientModel.product!.givenDate ?? "",
          }
        ],
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
      await clientCollection.doc(id).update({
        "client_name": clientModel.clientName,
        "phone_number": clientModel.phoneNumber ?? "",
        "given_date": clientModel.givenDate,
        "created_at": createdAt,
        "updated_at": FieldValue.serverTimestamp(),
        "products": [
          {
            "id": uuid.v4(),
            "product_type": clientModel.product!.productType ?? "",
            "price": clientModel.product!.price!.toMap(),
            "paid_money": clientModel.product!.paidMoney!.toMap(),
            "given_date": clientModel.product!.givenDate ?? "",
          }
        ],
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

  //////

  ///
  Future<bool> postProduct({
    required ClientModel clientModel,
    required client.ProductModel productModel,
  }) async {
    try {
      await clientCollection.doc(clientModel.id.toString()).update({
        "client_name": clientModel.client_name,
        "phone_number": clientModel.phone_number ?? "",
        "given_date": clientModel.given_date,
        "created_at": clientModel.created_at.toString(),
        "updated_at": DateTime.now().toLocal().toString(),
        "products": FieldValue.arrayUnion([
          {
            "id": productModel.id.toString(),
            "product_type": productModel.product_type ?? "",
            "price": productModel.price!.toMap(),
            "paid_money": productModel.paid_money!.toMap(),
            "given_date": productModel.given_date ?? "",
          }
        ]),
      });
      return true;
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
      return false;
    }
  }

  ///
  Future<void> updateProduct({
    required ClientModel clientModel,
    required List<client.ProductModel?> productModels,
  }) async {
    try {
      await clientCollection.doc(clientModel.id).update({
        "client_name": clientModel.client_name,
        "phone_number": clientModel.phone_number ?? "",
        "given_date": clientModel.given_date,
        "created_at": clientModel.created_at.toString(),
        "updated_at": DateTime.now().toLocal().toString(),
        "products": productModels.map((e) => e!.toMap()),
      });
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
    }
  }

  ///
  Future<void> deleteProduct(
      {required ClientModel clientModel,
      required client.ProductModel product}) async {
    try {
      await clientCollection.doc(clientModel.id).update({
        "client_name": clientModel.client_name,
        "phone_number": clientModel.phone_number ?? "",
        "given_date": clientModel.given_date,
        "created_at": clientModel.created_at.toString(),
        "updated_at": DateTime.now().toLocal().toString(),
        "products": FieldValue.arrayRemove([product.toMap()]),
      });
    } on FirebaseException catch (e) {
      showFoxMessage(e.message.toString());
    }
  }
}
