import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_me/app/service_locator.dart';
import 'package:todo_me/core/usecases/usecase.dart';

import '../../domain/usecases/auth_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

// i will use this bloc above all the application to check if the user is authenticated or not
// and handle the authentication process
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthEvent>((event, emit)async {
      switch (event) {
        
        case AuthLoginEvent():
        emit(AuthLoadingState());
        
        emit(await _loginWithEmailAndPassword(event.email, event.password));
        event.onCompleted?.call(state);

          break;
        case AuthLoginWithGoogleEvent():
          emit(AuthLoadingState());
         emit(await _loginWithGoogle());
         event.onCompleted?.call(state);
          break;
        case AuthSignUpEvent():
          emit(AuthLoadingState());
       emit( await  _signUpWithEmailAndPassword(event.email, event.password,event.name));
       event.onCompleted?.call(state);
          break;
        case AuthSignUpWithGoogleEvent():
          emit(AuthLoadingState());
         emit (await _signUpWithGoogle());
         event.onCompleted?.call(state);
          break;
        case AuthSignOutEvent():
          emit(AuthLoadingState());
          emit(await _signOut());
          event.onCompleted?.call(state);
          break;
        case AuthCheckUserAuthenticationEvent():
          emit(AuthLoadingState());
          emit(await _checkUserAuthentication());
          event.onCompleted?.call(state);
          break;
      }
    });


  }

// handle login with email and password
  Future<AuthState> _loginWithEmailAndPassword(String email, String password ,)async {
   var result=await ServiceLocator.I.getIt<SignInWithEmailAndPasswordUseCase>().call(LoginOrRegisterParams(email: email, password: password));
 return   result.fold(
      (l) {
        
        return AuthFailureState(l.message);
      },
      (r) => AuthLoginSuccessState()
    );
  }

// handle login with google
  Future<AuthState> _loginWithGoogle()async{
  final result=  await ServiceLocator.I.getIt<SignInWithGoogleUseCase>().call(NoParms());
    
    
   return  result.fold(
        (l) =>AuthFailureState(l.message),
        (r) => AuthLoginSuccessState()
      );
   
  }

  // handle sign up with email and password
  Future<AuthState> _signUpWithEmailAndPassword(String email, String password, String name)async {
    var result=await ServiceLocator.I.getIt<CreateAccountWithEmailAndPasswordUseCase>().call(LoginOrRegisterParams(email: email, password: password,name: name));
return   result.fold(
      (l) => AuthFailureState(l.message),
      (r) => AuthRegisterSuccessState()
    );
  }

  // handle sign up with google
  Future<AuthState> _signUpWithGoogle()async {
    var result=await ServiceLocator.I.getIt<CreateAccountWithGoogleUseCase>().call(NoParms());
  
 return   result.fold(
      (l) => AuthFailureState(l.message),
      (r) => AuthRegisterSuccessState()
    );
  }

  // handle sign out
  Future<AuthState> _signOut() async{
final result=  await   ServiceLocator.I.getIt<SignOutUseCase>().call(NoParms());
return result.fold(
      (l) => AuthFailureState(l.message),
      (r) => AuthSignOutSuccessState()
    );
    
  }


  // handle check user authentication
  Future<AuthState> _checkUserAuthentication()async {
    var result=await ServiceLocator.I.getIt<CheckUserAuthenticationUseCase>().call(NoParms());
 return   result.fold(
      (l) => AuthFailureState(l.message),
      (r)
      =>AuthInitialState()
    );
  }
}
