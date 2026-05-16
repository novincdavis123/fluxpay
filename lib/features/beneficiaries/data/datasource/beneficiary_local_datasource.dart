import '../models/beneficiary_model.dart';

abstract class BeneficiaryLocalDataSource {
  Future<List<BeneficiaryModel>> getBeneficiaries();

  Future<void> addBeneficiary(BeneficiaryModel beneficiary);
}

class BeneficiaryLocalDataSourceImpl implements BeneficiaryLocalDataSource {
  final List<BeneficiaryModel> _beneficiaries = [];

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    return _beneficiaries;
  }

  @override
  Future<void> addBeneficiary(BeneficiaryModel beneficiary) async {
    _beneficiaries.add(beneficiary);
  }
}
