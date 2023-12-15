part of 'rent_cubit.dart';

@freezed
class RentState with _$RentState {
  const factory RentState.initial() = _Initial;
  const factory RentState.loading() = _Loading;
  const factory RentState.empty() = _Empty;
  const factory RentState.error(String err) = _Error;
  const factory RentState.success(List<RentModel> data) = _Succeess;
}
