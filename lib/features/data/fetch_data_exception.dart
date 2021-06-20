class FetchDataException implements Exception {
  final String message;

  FetchDataException(this.message);

  @override
  String toString() {
    return "Error fetching data: $message";
  }
}
