import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpVerificationController extends ChangeNotifier {
  final TextEditingController otpController = TextEditingController();
  String _errorMessage = '';
  String? _verificationId;

  String get errorMessage => _errorMessage;

  void setVerificationId(String verificationId) {
    _verificationId = verificationId;
  }

  void updateOtp(String value) {
    otpController.text = value;

    _errorMessage = '';
    notifyListeners();
  }

  Future<void> verifyOtp() async {
    if (_verificationId == null) {
      _errorMessage = 'Verification ID not set.';
      notifyListeners();
      return;
    }

    try {
      print('Verification ID: $_verificationId');
      print('Entered OTP: ${otpController.text}');

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpController.text,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      _errorMessage = '';
      notifyListeners();
    } catch (e) {
      print('Verification failed: $e');
      _errorMessage = 'Verification failed. Please try again.';
      notifyListeners();
    }
  }

  Future<void> resendOtp(String phoneNumber) async {
    try {
      final PhoneVerificationCompleted verificationCompleted =
          (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      };

      final PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException e) {
        print('Verification failed: ${e.message}');
        _errorMessage = 'Verification failed: ${e.message}';
        notifyListeners();
      };

      final PhoneCodeSent codeSent = (String verificationId, int? resendToken) {
        setVerificationId(verificationId);
        _errorMessage = 'OTP sent to $phoneNumber';
        notifyListeners();
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        setVerificationId(verificationId);
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

      _errorMessage = '';
    } catch (e) {
      print('Failed to resend OTP: $e');
      _errorMessage = 'Failed to resend OTP. Please try again.';
      notifyListeners();
    }
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class OtpVerificationController extends ChangeNotifier {
//   final TextEditingController otpController = TextEditingController();
//   String _errorMessage = '';
//   String? _verificationId;

//   String get errorMessage => _errorMessage;

//   void setVerificationId(String verificationId) {
//     _verificationId = verificationId;
//   }

//   void updateOtp(String value) {
//     otpController.text = value;

//     _errorMessage = '';
//     notifyListeners();
//   }

//   Future<void> verifyOtp(String pin, String verificationId) async {
//     if (_verificationId == null) {
//       _errorMessage = 'Verification ID not set.';
//       notifyListeners();
//       return;
//     }

//     if (otpController.text.isEmpty) {
//       _errorMessage = 'Please enter the OTP.';
//       notifyListeners();
//       return;
//     }

//     try {
//       print('Verification ID: $_verificationId');
//       print('Entered OTP: ${otpController.text}');

//       final credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: otpController.text,
//       );

//       await FirebaseAuth.instance.signInWithCredential(credential);

//       _errorMessage = '';
//       notifyListeners();
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'invalid-verification-code') {
//         _errorMessage = 'Invalid OTP. Please try again.';
//       } else {
//         _errorMessage = 'Verification failed. Please try again.';
//       }
//       notifyListeners();
//     } catch (e) {
//       print('Verification failed: $e');
//       _errorMessage = 'Verification failed. Please try again.';
//       notifyListeners();
//     }
//   }

//   Future<void> resendOtp(String phoneNumber) async {
//     if (phoneNumber.isEmpty) {
//       _errorMessage = 'Please enter your phone number.';
//       notifyListeners();
//       return;
//     }

//     try {
//       final PhoneVerificationCompleted verificationCompleted =
//           (PhoneAuthCredential credential) async {
//         await FirebaseAuth.instance.signInWithCredential(credential);
//       };

//       final PhoneVerificationFailed verificationFailed =
//           (FirebaseAuthException e) {
//         print('Verification failed: ${e.message}');
//         _errorMessage = 'Verification failed: ${e.message}';
//         notifyListeners();
//       };

//       final PhoneCodeSent codeSent = (String verificationId, int? resendToken) {
//         setVerificationId(verificationId);
//         _errorMessage = 'OTP sent to $phoneNumber';
//         notifyListeners();
//       };

//       final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
//           (String verificationId) {
//         setVerificationId(verificationId);
//       };

//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: verificationCompleted,
//         verificationFailed: verificationFailed,
//         codeSent: codeSent,
//         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//       );

//       _errorMessage = '';
//     } catch (e) {
//       print('Failed to resend OTP: $e');
//       _errorMessage = 'Failed to resend OTP. Please try again.';
//       notifyListeners();
//     }
//   }

//   void dispose() {
//     otpController.dispose();
//     super.dispose();
//   }

//   void setErrorMessage(String string) {}
// }
