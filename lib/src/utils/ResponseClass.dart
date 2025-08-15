class ResponseClass<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final int? statusCode;

  const ResponseClass._({
    required this.isSuccess,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ResponseClass.success(T data, {String? message, int? statusCode}) {
    return ResponseClass._(
      isSuccess: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ResponseClass.error(String message, {int? statusCode}) {
    return ResponseClass._(
      isSuccess: false,
      message: message,
      statusCode: statusCode,
    );
  }

  bool get isError => !isSuccess;
}