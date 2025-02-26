import 'package:fpdart/fpdart.dart';
import 'package:todo_me/core/errors/failurs.dart';

abstract class UseCase<Type, Prams> {
  Future<Either<Failures, Type>> call(Prams prams);
}

abstract class  StreamUseCase<Type, Prams> {
  Stream<Either<Failures, Type>> call(Prams prams);
  
}

abstract class Params {}

class NoParms extends Params {}


class LoginOrRegisterParams extends Params {
  final String? email;
  final String? password;
  final String? name;

  LoginOrRegisterParams({this.email, this.password,this.name});
}