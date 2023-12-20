part of 'client_cubit.dart';

@freezed
class ClientState with _$ClientState {
  const factory ClientState.initial() = _Initial;
  const factory ClientState.loading() = _Loading;
  const factory ClientState.empty() = _Empty;
  const factory ClientState.error(String err) = _Error;
  const factory ClientState.success(List<ClientModel> data) = _Succeess;
}
