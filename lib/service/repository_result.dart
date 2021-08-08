class RepositoryResult<T> {
  RepositoryResult({this.data, this.error})
      : assert(data != null || error != null);

  final T? data;
  final Object? error;

  bool get isSuccess => error == null && data != null;

  String get errorDescription => error?.toString() ?? 'no data';
}
