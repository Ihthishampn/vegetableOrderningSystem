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
    // avoid notifying listeners synchronously during widget build
    // this can cause "setState during build" errors if called from
    // initState of a widget. Schedule the notification for the next
    // frame so that the widget tree has finished building.
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
