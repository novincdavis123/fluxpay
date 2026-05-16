import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/beneficiary_entity.dart';
import '../../domain/repositories/beneficiary_repository.dart';

import 'beneficiary_event.dart';
import 'beneficiary_state.dart';

class BeneficiaryBloc extends Bloc<BeneficiaryEvent, BeneficiaryState> {
  final BeneficiaryRepository repository;

  final uuid = const Uuid();

  BeneficiaryBloc({required this.repository})
    : super(BeneficiaryState.initial()) {
    on<LoadBeneficiaries>(_onLoadBeneficiaries);

    on<AddBeneficiary>(_onAddBeneficiary);
  }

  Future<void> _onLoadBeneficiaries(
    LoadBeneficiaries event,
    Emitter<BeneficiaryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final beneficiaries = await repository.getBeneficiaries();

    emit(state.copyWith(isLoading: false, beneficiaries: beneficiaries));
  }

  Future<void> _onAddBeneficiary(
    AddBeneficiary event,
    Emitter<BeneficiaryState> emit,
  ) async {
    final duplicateExists = state.beneficiaries.any(
      (beneficiary) => beneficiary.accountNumber == event.accountNumber,
    );

    if (duplicateExists) {
      emit(state.copyWith(error: 'Beneficiary already exists'));

      return;
    }

    final beneficiary = BeneficiaryEntity(
      id: uuid.v4(),
      nickname: event.nickname,
      bankName: event.bankName,
      country: event.country,
      currencyCode: event.currencyCode,
      accountNumber: event.accountNumber,
      createdAt: DateTime.now(),
      isRecent: true,
    );

    await repository.addBeneficiary(beneficiary);

    add(LoadBeneficiaries());
  }
}
