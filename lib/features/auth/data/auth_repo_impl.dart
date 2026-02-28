import 'package:firebase_auth/firebase_auth.dart';
import 'package:vegetable_ordering_system/features/auth/domain/auth_repository.dart';

class AuthRepoImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> sendOtp(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(e.message);
      },
      codeSent: (verificationId, resendToken) {
        // Store verificationId somewhere (provider)
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  @override
  Future<void> verifyOtp(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await _auth.signInWithCredential(credential);
  }
  

}