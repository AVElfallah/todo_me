// abstract auth repository 
// it's a contract that the auth repository should implement
import 'package:fpdart/fpdart.dart';
import 'package:todo_me/core/errors/failurs.dart';
import 'package:todo_me/features/auth/data/datasources/auth_data_source.dart';

abstract class AuthRepository {
  final AuthDataSource dataSource;
  AuthRepository(this.dataSource);
  Future<Either<Failures,void>> signInWithGoogle();
  Future<Either<Failures,void>> signInWithEmailAndPassword(String email, String password);

  Future<Either<Failures,void>> signUpWithEmailAndPassword(String email, String password ,String name);
  Future<Either<Failures,void>> signUpWithGoogle();

  Future<Either<Failures,void>> signOut();

  Future<Either<Failures,bool>> checkUserAuthentication();
}