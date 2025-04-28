
class ExceptionTimeout implements Exception{}
class ExceptionSocket implements Exception{}
class ExceptionFormat implements Exception{}
class ExceptionHandshake implements Exception{}
class ExceptionOther implements Exception{}
class CustomException implements Exception {
  final String message;
  CustomException({
    required this.message,
  });
}
