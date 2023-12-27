import 'package:accountant/domain/product_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_state.dart';
part 'product_cubit.freezed.dart';

class ProductCubit extends Cubit<ProductState> {
  final String id;
  ProductCubit(this.id) : super(const ProductState.initial()) {
    sumSnapshot = FirebaseFirestore.instance
        .collection("clients")
        .doc(id)
        .collection('sums')
        .orderBy('created_at')
        .get();

    productsCollection = FirebaseFirestore.instance
        .collection("clients")
        .doc(id)
        .collection('products');
  }
  late final Future<QuerySnapshot<Map<String, dynamic>>> sumSnapshot;
  late final CollectionReference<Map<String, dynamic>> productsCollection;

  Future<void> getProductsAndCalculate() async {}



  
}
