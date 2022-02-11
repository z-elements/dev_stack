import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyModel  with ChangeNotifier  {

  TextEditingController emailController=  TextEditingController();
  TextEditingController passwordController=  TextEditingController();
  TextEditingController error=  TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  Future<bool> signInWithEmailAndPassword() async {
    bool ret=false;
    if (isEmail(emailController.text)) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if ( userCredential.user!= null)
        {
          ret= true;
        }
      } on FirebaseAuthException catch (e) {

        if (e.code == 'user-not-found') {
          error.text="user-not-found";
        } else if (e.code == 'wrong-password') {
          error.text="Wrong password";
        }
        ret= false;
      }
    } else {
      error.text = "Wrong email";
    }
    return ret;
  }
  void set emailcontroller(String value) {
    emailController.text = value;
    notifyListeners();
  }
  String get emailControllerText {
    return emailController.text;
  }

  void set passcontroller(String value) {
    passwordController.text = value;
    notifyListeners();
  }

  String get passwordControllerText {
    return passwordController.text;
  }

  void set errorcontroller(String value) {
    error.text = value;
    notifyListeners();
  }

  String get errorText {
    return error.text;
  }
}
