import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSource {
Future<UserCredential>  signInWithGoogle();
 Future<UserCredential> signInWithEmailAndPassword(String email, String password);
 Future<UserCredential> signUpWithEmailAndPassword(String email, String password, String name);
 Future<UserCredential> signUpWithGoogle();
 Future<void> signOut();
 Future<bool> checkUserAuthentication();
}