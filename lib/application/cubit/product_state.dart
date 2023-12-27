part of 'product_cubit.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState.initial() = _Initial;
  const factory ProductState.loading() = _Loading;
  const factory ProductState.error(String err) = _Error;
  const factory ProductState.success(List<ProductModel> data) = _Success;
}
