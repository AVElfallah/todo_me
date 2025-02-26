import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/src/either.dart';

import 'package:todo_me/core/errors/failurs.dart';
import 'package:todo_me/core/errors/server_failure_manager.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository{
  AuthRepositoryImpl(super.dataSource) ;
  


  @override
  Future<Either<Failures, bool>> checkUserAuthentication() async{
    try {
      final result =await dataSource.checkUserAuthentication();
      return Right(result);
    }on FirebaseException catch (e) {
      return Left(
        serverFailure(e)
      );
    }
  }

  @override
  Future<Either<Failures, void>> signInWithEmailAndPassword(String email, String password)async {
   try {
       await dataSource.signInWithEmailAndPassword(email, password);
      return Right(null);
    }on FirebaseException catch (e) {
      return Left(
        serverFailure(e)
      );
    }
  }

  @override
  Future<Either<Failures, void>> signInWithGoogle()async {
    try {
    await  dataSource.signInWithGoogle();
      return Right(null);
    }on FirebaseException catch (e) {
      return Left(
        serverFailure(e)
      );
    }

  }

  @override
  Future<Either<Failures, void>> signOut()async {
    try {
     await dataSource.signOut();
      return Right(null);
    }on FirebaseException catch (e) {
      return Left(
        serverFailure(e)
      );
    }
  }

  @override
  Future<Either<Failures, void>> signUpWithEmailAndPassword(String email, String password, String name)async {
  try {
  await    dataSource.signUpWithEmailAndPassword(email, password, name);
      return Right(null);
    }on FirebaseException catch (e) {
      return Left(
        serverFailure(e)
      );
    }
  }

  @override
  Future<Either<Failures, void>> signUpWithGoogle()async {
   try {
   await   dataSource.signUpWithGoogle();
      return Right(null);
    }on FirebaseException catch (e) {
      return Left(
        serverFailure(e)
      );
    }
  }

}