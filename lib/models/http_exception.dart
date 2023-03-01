// Exception is a abstract class that means
// it can't be directly instantiates
class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
