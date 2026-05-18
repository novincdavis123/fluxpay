import '../../domain/entities/beneficiary_entity.dart';
import '../../domain/repositories/beneficiary_repository.dart';

import '../datasource/beneficiary_local_datasource.dart';
import '../models/beneficiary_model.dart';

class BeneficiaryRepositoryImpl implements BeneficiaryRepository {
  final BeneficiaryLocalDataSource localDataSource;

  BeneficiaryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<BeneficiaryEntity>> getBeneficiaries() async {
    final beneficiaries = await localDataSource.getBeneficiaries();

    beneficiaries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return beneficiaries;
  }

  @override
  Future<void> addBeneficiary(BeneficiaryEntity beneficiary) async {
    final model = BeneficiaryModel(
      id: beneficiary.id,
      nickname: beneficiary.nickname,
      bankName: beneficiary.bankName,
      country: beneficiary.country,
      currencyCode: beneficiary.currencyCode,
      accountNumber: beneficiary.accountNumber,
      createdAt: beneficiary.createdAt,
      isRecent: beneficiary.isRecent,
    );

    await localDataSource.addBeneficiary(model);
  }

  @override
  Future<void> deleteBeneficiary(String beneficiaryId) async {
    await localDataSource.deleteBeneficiary(beneficiaryId);
  }

  @override
  Future<List<BeneficiaryEntity>> searchBeneficiaries(String query) async {
    final beneficiaries = await localDataSource.searchBeneficiaries(query);

    return beneficiaries;
  }

  @override
  Future<List<BeneficiaryEntity>> filterByCurrency(String currencyCode) async {
    final beneficiaries = await localDataSource.getBeneficiaries();

    return beneficiaries.where((beneficiary) {
      return beneficiary.currencyCode.toLowerCase() ==
          currencyCode.toLowerCase();
    }).toList();
  }
}
