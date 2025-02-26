abstract class Failures {
  final String message;
  Failures(this.message);
}

class ServerFailure extends Failures   {
  ServerFailure(super.message);
}
class CacheFailure extends Failures {
  CacheFailure(super.message);
}

class ValidationFailure extends Failures {
  ValidationFailure(super.message);
}