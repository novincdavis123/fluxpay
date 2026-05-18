import '../entities/beneficiary_entity.dart';

abstract class BeneficiaryRepository {
  /// GET ALL BENEFICIARIES
  Future<List<BeneficiaryEntity>> getBeneficiaries();

  /// ADD BENEFICIARY
  Future<void> addBeneficiary(BeneficiaryEntity beneficiary);

  /// DELETE BENEFICIARY
  Future<void> deleteBeneficiary(String beneficiaryId);

  /// SEARCH BENEFICIARIES
  Future<List<BeneficiaryEntity>> searchBeneficiaries(String query);

  /// FILTER BY CURRENCY
  Future<List<BeneficiaryEntity>> filterByCurrency(String currencyCode);
}
