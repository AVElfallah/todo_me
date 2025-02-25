part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent(this.onCompleted);

  final Function(AuthState)? onCompleted;

  @override
  List<Object> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;
  AuthLoginEvent(this.email, this.password,{Function(AuthState)? onCompleted}):super(onCompleted);
}
class AuthLoginWithGoogleEvent extends AuthEvent {
  AuthLoginWithGoogleEvent(super.onCompleted);
}

class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignUpEvent(this.email, this.password, this.name,{Function(AuthState)? onCompleted}):super(onCompleted);
}

class AuthSignUpWithGoogleEvent extends AuthEvent {
  AuthSignUpWithGoogleEvent(super.onCompleted);
}

class AuthSignOutEvent extends AuthEvent {
  AuthSignOutEvent(super.onCompleted);
}

class AuthCheckUserAuthenticationEvent extends AuthEvent {
  AuthCheckUserAuthenticationEvent(super.onCompleted);
}