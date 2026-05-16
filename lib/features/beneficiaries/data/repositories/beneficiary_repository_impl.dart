import '../../domain/entities/beneficiary_entity.dart';
import '../../domain/repositories/beneficiary_repository.dart';

import '../datasource/beneficiary_local_datasource.dart';
import '../models/beneficiary_model.dart';

class BeneficiaryRepositoryImpl implements BeneficiaryRepository {
  final BeneficiaryLocalDataSource localDataSource;

  BeneficiaryRepositoryImpl({required this.localDataSource});

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
  Future<List<BeneficiaryEntity>> getBeneficiaries() async {
    return localDataSource.getBeneficiaries();
  }
}
