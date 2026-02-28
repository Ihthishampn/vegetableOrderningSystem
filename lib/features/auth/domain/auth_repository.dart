abstract class AuthRepository {
  Future<void> sendOtp(String phone);
  Future<void> verifyOtp(String verificationId, String smsCode);
}