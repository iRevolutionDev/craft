abstract class RequestBase<T> {
  final String type;
  final T data;

  RequestBase({
    required this.type,
    required this.data,
  });
}
