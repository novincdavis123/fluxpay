import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/beneficiary_model.dart';

abstract class BeneficiaryLocalDataSource {
  Future<List<BeneficiaryModel>> getBeneficiaries();

  Future<void> addBeneficiary(BeneficiaryModel beneficiary);

  Future<void> deleteBeneficiary(String beneficiaryId);

  Future<List<BeneficiaryModel>> searchBeneficiaries(String query);

  Future<void> cacheBeneficiaries(List<BeneficiaryModel> beneficiaries);

  Future<void> clearCache();
}

class BeneficiaryLocalDataSourceImpl implements BeneficiaryLocalDataSource {
  static const String _cacheKey = 'cached_beneficiaries';

  List<BeneficiaryModel> _beneficiaries = [];

  bool _isInitialized = false;

  /// -------------------------------
  /// INITIALIZE CACHE
  /// -------------------------------
  Future<void> _initialize() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();

    final cachedData = prefs.getString(_cacheKey);

    if (cachedData != null && cachedData.isNotEmpty) {
      try {
        final decoded = jsonDecode(cachedData) as List;

        _beneficiaries = decoded
            .map(
              (item) =>
                  BeneficiaryModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();

        if (kDebugMode) {
          debugPrint('✅ Loaded ${_beneficiaries.length} cached beneficiaries');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('❌ Failed to parse cached beneficiaries: $e');
        }

        _beneficiaries = [];
      }
    }

    _isInitialized = true;
  }

  /// -------------------------------
  /// SAVE CACHE
  /// -------------------------------
  Future<void> _saveCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final encoded = jsonEncode(
        _beneficiaries.map((beneficiary) => beneficiary.toJson()).toList(),
      );

      await prefs.setString(_cacheKey, encoded);

      if (kDebugMode) {
        debugPrint('💾 Beneficiaries cached (${_beneficiaries.length})');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to cache beneficiaries: $e');
      }
    }
  }

  /// -------------------------------
  /// GET BENEFICIARIES
  /// -------------------------------
  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    await _initialize();

    return List<BeneficiaryModel>.from(_beneficiaries);
  }

  /// -------------------------------
  /// ADD BENEFICIARY
  /// -------------------------------
  @override
  Future<void> addBeneficiary(BeneficiaryModel beneficiary) async {
    await _initialize();

    _beneficiaries.insert(0, beneficiary);

    await _saveCache();
  }

  /// -------------------------------
  /// DELETE BENEFICIARY
  /// -------------------------------
  @override
  Future<void> deleteBeneficiary(String beneficiaryId) async {
    await _initialize();

    _beneficiaries.removeWhere(
      (beneficiary) => beneficiary.id == beneficiaryId,
    );

    await _saveCache();
  }

  /// -------------------------------
  /// SEARCH BENEFICIARIES
  /// -------------------------------
  @override
  Future<List<BeneficiaryModel>> searchBeneficiaries(String query) async {
    await _initialize();

    if (query.trim().isEmpty) {
      return List<BeneficiaryModel>.from(_beneficiaries);
    }

    final lowerQuery = query.toLowerCase().trim();

    return _beneficiaries.where((beneficiary) {
      return beneficiary.nickname.toLowerCase().contains(lowerQuery) ||
          beneficiary.bankName.toLowerCase().contains(lowerQuery) ||
          beneficiary.country.toLowerCase().contains(lowerQuery) ||
          beneficiary.currencyCode.toLowerCase().contains(lowerQuery) ||
          beneficiary.accountNumber.contains(lowerQuery);
    }).toList();
  }

  /// -------------------------------
  /// CACHE BENEFICIARIES
  /// -------------------------------
  @override
  Future<void> cacheBeneficiaries(List<BeneficiaryModel> beneficiaries) async {
    _beneficiaries = beneficiaries;

    await _saveCache();
  }

  /// -------------------------------
  /// CLEAR CACHE
  /// -------------------------------
  @override
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_cacheKey);

    _beneficiaries.clear();

    if (kDebugMode) {
      debugPrint('🗑️ Beneficiary cache cleared');
    }
  }
}
