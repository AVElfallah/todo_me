import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';
import 'package:todo_me/core/errors/failurs.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

// create account with email and password usecase
// it's a contract that the auth repository should implement
class CreateAccountWithEmailAndPasswordUseCase extends UseCase<void, LoginOrRegisterParams> {
  final AuthRepository _authRepository;
  CreateAccountWithEmailAndPasswordUseCase(this._authRepository);
  @override
  Future<Either<Failures,void>> call(LoginOrRegisterParams prams) async {
    return await _authRepository.signUpWithEmailAndPassword(prams.email!, prams.password!, prams.name!);
  }
}

// create account with google usecase
// it's a contract that the auth repository should implement
class CreateAccountWithGoogleUseCase extends UseCase<void, NoParms> {
  final AuthRepository _authRepository;
  CreateAccountWithGoogleUseCase(this._authRepository);

  @override
  Future<Either<Failures,void>> call(NoParms prams) async {
    return await _authRepository.signUpWithGoogle();
  }
}

// sign in with email and password usecase
// it's a contract that the auth repository should implement
class SignInWithEmailAndPasswordUseCase extends UseCase<void, LoginOrRegisterParams> {
  final AuthRepository _authRepository;
  SignInWithEmailAndPasswordUseCase(this._authRepository);

@override
  Future<Either<Failures,void>> call(LoginOrRegisterParams prams) async {
    return await _authRepository.signInWithEmailAndPassword(prams.email!, prams.password!);
  }
}

// sign in with google usecase
// it's a contract that the auth repository should implement
class SignInWithGoogleUseCase extends UseCase<void, NoParms> {
  final AuthRepository _authRepository;
  SignInWithGoogleUseCase(this._authRepository);
  @override
  Future<Either<Failures,void>> call(NoParms parms) async {
    return await _authRepository.signInWithGoogle();
  } 
}


// sign out usecase
// it's a contract that the auth repository should implement
class SignOutUseCase extends UseCase<void, NoParms> {
  final AuthRepository _authRepository;
  SignOutUseCase(this._authRepository);
  @override
  Future<Either<Failures,void>> call
  (NoParms parms) async {
    try {
      // sign out
      await _authRepository.signOut();
      // free hive box
      
      final tasks= await Hive.openBox('tasks');
      await tasks.clear();

      final lastDataUpdated= await Hive.openBox('lastDataUpdate');
      await lastDataUpdated.clear();

      final deletedTasks =await Hive.openBox('deletedTasks');
      await deletedTasks.clear();

      

      
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }

  
  }
}

// checkUserAuthentication usecase
// it 's a contract that the auth repository should implement
class CheckUserAuthenticationUseCase extends UseCase<bool, NoParms> {
  final AuthRepository _authRepository;
  CheckUserAuthenticationUseCase(this._authRepository);
  @override
  Future<Either<Failures,bool>> call(NoParms parms) async {
    return await _authRepository.checkUserAuthentication();
  }
}