class AppException implements Exception {
  // ignore: prefer_typing_uninitialized_variables
  final _message;
  // ignore: prefer_typing_uninitialized_variables
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");

  get message => null;
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, "Invalid Request: ");

  get message => null;
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message]) : super(message, "Unauthorized: ");

  get message => null;
}

class UnprocessableEntityException extends AppException {
  UnprocessableEntityException([String? message])
      : super(message, "Unprocessable Entity: ");

  get message => null;
}

class InvalidInputException extends AppException {
  // ignore: prefer_typing_uninitialized_variables
  var message;

  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
