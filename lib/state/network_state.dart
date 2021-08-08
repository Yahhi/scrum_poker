import 'package:mobx/mobx.dart';

part 'network_state.g.dart';

class NetworkState = _NetworkState with _$NetworkState;

abstract class _NetworkState with Store {
  @observable
  bool isLoading = false;

  @observable
  String? error;

  @computed
  bool get hasNetworkError => error != null;

  @action
  void clearError() => error = null;
}
