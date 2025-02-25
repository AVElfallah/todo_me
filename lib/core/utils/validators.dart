import 'package:fpdart/fpdart.dart';


class Validators {
  static Either<void, String?> email(String? params) {
    if (params == null) {
      return Right('Email is required');
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(params)) {
      return Right('Email is invalid');
    }
    return Left(null);
  }

  static Either<void, String?> password(String? params) {
    if (params == null) {
      return Right('Password is required');
    }
    if (params.length < 6) {
      return Right('Password must be at least 6 characters');
    }
    return Left(null);
  }

  static Either<void, String?> name(String? params) {
    if (params == null) {
      return Right('Name is required');
    }
    if (params.length < 3) {
      return Right('Name must be at least 3 characters');
    }
    return Left(null);
  }
}
