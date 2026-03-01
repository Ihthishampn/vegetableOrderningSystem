import 'package:flutter/material.dart';
import '../../domain/entities/store_profile.dart';
import '../../domain/usecases/store_profile_use_case.dart';

class StoreProfileProvider with ChangeNotifier {
  final StoreProfileUseCase _useCase;

  StoreProfileProvider(this._useCase);

  StoreProfile? _storeProfile;
  bool _isLoading = false;
  String? _error;

  StoreProfile? get storeProfile => _storeProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStoreProfile(String userId) async {
    _isLoading = true;
    _error = null;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      _storeProfile = await _useCase.getStoreProfileByUserId(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStoreProfile(StoreProfile storeProfile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _useCase.updateStoreProfile(storeProfile);
      _storeProfile = storeProfile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createStoreProfile(StoreProfile storeProfile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _useCase.createStoreProfile(storeProfile);
      _storeProfile = storeProfile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
