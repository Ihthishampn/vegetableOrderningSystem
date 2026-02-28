import '../../domain/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<void> sendOtp(String phone) async {
    await repository.sendOtp(phone);
  }

  Future<void> verifyOtp(String verificationId, String code) async {
    await repository.verifyOtp(verificationId, code);
  }
}