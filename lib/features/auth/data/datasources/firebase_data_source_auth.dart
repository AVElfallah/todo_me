import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_me/features/auth/data/datasources/auth_data_source.dart';



class FirebaseAuthDataSource extends AuthDataSource {
  final FirebaseAuth _firebaseAuth;
  FirebaseAuthDataSource(this._firebaseAuth);

  // sign in with google
  @override
  Future<UserCredential> signInWithGoogle() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    return await _firebaseAuth.signInWithProvider(googleProvider);
  }

  // sign in with email and password
  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // sign up with email and password
  @override
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  )
  async {
    var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user!.updateDisplayName(name);
    return userCredential;
  }

  // sign up with google
  @override
  Future<UserCredential> signUpWithGoogle() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    return await _firebaseAuth.signInWithProvider(googleProvider);
  }

  // sign out
  @override
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // check user authentication
  @override
  Future<bool> checkUserAuthentication() async {
    return _firebaseAuth.currentUser != null;
  }
}
