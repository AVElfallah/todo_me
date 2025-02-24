import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_me/app/routers/router_manager.dart';
import 'package:todo_me/assets/assets_manager.dart';
import 'package:todo_me/features/auth/data/datasources/firebase_data_source_auth.dart';
import 'package:todo_me/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:todo_me/features/auth/domain/usecases/auth_usecase.dart';

import '../features/auth/data/datasources/auth_data_source.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

class ServiceLocator {
ServiceLocator._();
static final ServiceLocator _instance = ServiceLocator._();
static ServiceLocator get I => _instance;
  
static final GetIt _getIt = GetIt.instance;
GetIt get getIt => _getIt;
// setup services
static void setup() {
  // setup managers
  _getIt.registerSingleton<RouterManager>(RouterManager());
  _getIt.registerSingleton<AssetsManager>( AssetsManager());
  // setup firebase
  _getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  // setup data sources
  _getIt.registerSingleton<AuthDataSource>(FirebaseAuthDataSource(_getIt()));

  // setup repositories
  _getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(_getIt())
  );

  // setup use cases

  // [AuthUseCases] -START
  _getIt.registerSingleton<SignInWithGoogleUseCase>(
    SignInWithGoogleUseCase(_getIt())
  );
  _getIt.registerSingleton<SignInWithEmailAndPasswordUseCase>(
    SignInWithEmailAndPasswordUseCase(_getIt())
  );
  _getIt.registerSingleton<CreateAccountWithEmailAndPasswordUseCase>(
    CreateAccountWithEmailAndPasswordUseCase(_getIt())
  );
  _getIt.registerSingleton<CreateAccountWithGoogleUseCase>(
    CreateAccountWithGoogleUseCase(_getIt())
  );
  _getIt.registerSingleton<SignOutUseCase>(
    SignOutUseCase(_getIt())
  );
  _getIt.registerSingleton<CheckUserAuthenticationUseCase>(
    CheckUserAuthenticationUseCase(_getIt())
  );
  //[AuthUseCases] -END


// blocs locators
  _getIt.registerSingleton<AuthBloc>( AuthBloc());

}

}