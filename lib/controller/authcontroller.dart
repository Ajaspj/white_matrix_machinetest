import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:whitematrix/model/loginusermodel.dart';

class Authcontroller extends ChangeNotifier {
  LoginUser? _user;
  String? _verificationId;

  LoginUser? get user => _user;

  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  Future<void> sendOtp(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted:
          (firebase_auth.PhoneAuthCredential credential) async {
        try {
          await _firebaseAuth.signInWithCredential(credential);
          _user = LoginUser(
            id: _firebaseAuth.currentUser!.uid,
            phoneNumber: _firebaseAuth.currentUser!.phoneNumber!,
          );
          notifyListeners();
        } catch (e) {
          print('Sign-in failed: $e');
        }
      },
      verificationFailed: (firebase_auth.FirebaseAuthException e) {
        print('Verification failed: ${e.message}');

        _showError('Verification failed. Please try again.');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> verifyOtp(String otp) async {
    if (_verificationId == null) {
      print('Verification ID is not available.');
      _showError('Verification ID is not available. Please try again.');
      return;
    }

    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credential);
      _user = LoginUser(
        id: _firebaseAuth.currentUser!.uid,
        phoneNumber: _firebaseAuth.currentUser!.phoneNumber!,
      );
      notifyListeners();
    } catch (e) {
      print('OTP verification failed: $e');
      _showError('OTP verification failed. Please try again.');
    }
  }

  void logout() async {
    try {
      await _firebaseAuth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Logout failed: $e');
    }
  }

  void _showError(String message) {
    print(message);
  }
}
