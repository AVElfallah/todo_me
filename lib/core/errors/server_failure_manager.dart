import 'package:firebase_core/firebase_core.dart';
import 'package:todo_me/core/errors/failurs.dart';

ServerFailure serverFailure(FirebaseException e) {
  switch (e.code) {
    case 'user-not-found':
      return ServerFailure('User not found');
    case 'wrong-password':
      return ServerFailure('Wrong password');
    case 'email-already-in-use':
      return ServerFailure('Email already in use');
    case 'invalid-email':
      return ServerFailure('Invalid email');
    case 'weak-password':
      return ServerFailure('Weak password');
    default:
      return ServerFailure('Unknown error');
  }
}
