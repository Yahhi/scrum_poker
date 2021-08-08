import 'dart:async';

class DisposableState {
  final StreamController<StateStatus> _stateStatusController = StreamController<StateStatus>();
  Stream<StateStatus> get stateStatus => _stateStatusController.stream;
  bool _isAlreadyDisposed = false;

  void dispose() {
    if (!_isAlreadyDisposed) {
      _stateStatusController.close();
    }
    _isAlreadyDisposed = true;
  }

  void setStateActionDone() => _stateStatusController.add(StateStatus.actionDone);

  void setReadyToDispose() {
    if (!_isAlreadyDisposed) {
      _stateStatusController.add(StateStatus.canBeDisposed);
    }
  }
}

enum StateStatus { actionDone, canBeDisposed }
