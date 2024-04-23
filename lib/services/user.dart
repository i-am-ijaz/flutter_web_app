// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_duplicate_app/models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> getCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw Exception('User is not signed in.');
    }

    final userDoc =
        await _firestore.collection('users').doc(firebaseUser.email).get();

    return UserModel(
      email: userDoc.data()!['email'],
      uid: userDoc.data()!['uid'],
      name: userDoc.data()!['name'],
      role: userDoc.data()!['role'],
    );
  }

  Future<dynamic> register(
      {required String email,
      required String password,
      required String name,
      required String role}) async {
    // This returns a error as str or true
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;

      final userRef = FirebaseFirestore.instance.collection('users').doc(email);

      await userRef.set({
        'email': email,
        'uid': uid,
        'name': name,
        'role': role,
      });

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Weak password, please try again.';
      } else if (e.code == 'email-already-in-use') {
        return 'This account already exists, try login or use new email.';
      } else {
        return 'Unknown error detected in register, chat with us and report it to fix this or try again.';
      }
    }
  }

  Future<dynamic> login(
      {required String email, required String password}) async {
    // This returns a error as str or true
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Check if the user is assigned to any projects
      final assignedProjects = await _firestore
          .collection('projects')
          .where('assignedTo', arrayContains: email)
          .get();

      if (assignedProjects.docs.isEmpty &&
          _auth.currentUser!.email != 'admin@programador123.com') {
        await _auth.signOut();
        return "Your account is not assigned to any projects.";
      } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setString('password', password);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return 'Your credentials are wrong or not exist in our database (try register instead).';
      } else {
        return 'Unknown error detected in login, chat with us and report it to fix this or try again.';
      }
    }
  }

  Future<void> exampleUsage() async {
    UserModel user = UserModel(
      email: 'admin@programador123.com',
      password: 'System616-x64-616',
      name: 'name',
      role: 'role',
      uid: '',
    );

    dynamic registerResponse = await register(
      email: user.email,
      password: user.password!,
      name: user.name,
      role: user.role,
    );
    print('Response of register(): $registerResponse');
    if (registerResponse != true) {
      dynamic loginResponse = await login(
        email: user.email,
        password: user.password!,
      );
      print('Response of loginResponse(): $loginResponse');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
