part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();  

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {
}

class AuthLoadingState extends AuthState {
}

class AuthLoginSuccessState extends AuthState {
 
}

class AuthSignOutSuccessState extends AuthState {
  
}

class AuthRegisterSuccessState extends AuthState {

}

class AuthFailureState extends AuthState {
  final String message;
  AuthFailureState(this.message);
}

