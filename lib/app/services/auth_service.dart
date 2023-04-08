import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future login(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future signUp(String email, String password) async {
    var user = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    var docId = user.user!.uid;
  }
}
