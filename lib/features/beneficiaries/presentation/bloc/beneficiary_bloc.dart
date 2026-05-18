import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/beneficiary_entity.dart';
import '../../domain/repositories/beneficiary_repository.dart';

import 'beneficiary_event.dart';
import 'beneficiary_state.dart';

class BeneficiaryBloc extends Bloc<BeneficiaryEvent, BeneficiaryState> {
  final BeneficiaryRepository repository;

  final Uuid uuid = const Uuid();

  BeneficiaryBloc({required this.repository})
    : super(BeneficiaryState.initial()) {
    on<LoadBeneficiaries>(_onLoadBeneficiaries);

    on<AddBeneficiary>(_onAddBeneficiary);

    on<DeleteBeneficiary>(_onDeleteBeneficiary);
  }

  Future<void> _onLoadBeneficiaries(
    LoadBeneficiaries event,
    Emitter<BeneficiaryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final beneficiaries = await repository.getBeneficiaries();

      emit(
        state.copyWith(
          isLoading: false,
          hasLoaded: true,
          beneficiaries: beneficiaries,
          clearError: true,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load beneficiaries: $e');
      }

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Unable to load beneficiaries',
        ),
      );
    }
  }

  Future<void> _onAddBeneficiary(
    AddBeneficiary event,
    Emitter<BeneficiaryState> emit,
  ) async {
    emit(state.copyWith(isAdding: true, clearError: true));

    try {
      /// DUPLICATE CHECK
      final duplicateExists = state.beneficiaries.any(
        (beneficiary) =>
            beneficiary.accountNumber.trim() == event.accountNumber.trim(),
      );

      if (duplicateExists) {
        emit(
          state.copyWith(
            isAdding: false,
            errorMessage: 'Beneficiary already exists',
          ),
        );

        return;
      }

      /// CREATE BENEFICIARY
      final beneficiary = BeneficiaryEntity(
        id: uuid.v4(),
        nickname: event.nickname.trim(),
        bankName: event.bankName.trim(),
        country: event.country.trim(),
        currencyCode: event.currencyCode.trim(),
        accountNumber: event.accountNumber.trim(),
        createdAt: DateTime.now(),
        isRecent: true,
      );

      /// SAVE
      await repository.addBeneficiary(beneficiary);

      /// UPDATE LOCAL STATE
      final updatedBeneficiaries = [beneficiary, ...state.beneficiaries];

      emit(
        state.copyWith(
          isAdding: false,
          beneficiaries: updatedBeneficiaries,
          clearError: true,
        ),
      );

      if (kDebugMode) {
        debugPrint('✅ Beneficiary added successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to add beneficiary: $e');
      }

      emit(
        state.copyWith(
          isAdding: false,
          errorMessage: 'Failed to add beneficiary',
        ),
      );
    }
  }

  Future<void> _onDeleteBeneficiary(
    DeleteBeneficiary event,
    Emitter<BeneficiaryState> emit,
  ) async {
    emit(state.copyWith(isDeleting: true, clearError: true));

    try {
      await repository.deleteBeneficiary(event.id);

      final updatedBeneficiaries = state.beneficiaries
          .where((beneficiary) => beneficiary.id != event.id)
          .toList();

      emit(
        state.copyWith(
          isDeleting: false,
          beneficiaries: updatedBeneficiaries,
          clearError: true,
        ),
      );

      if (kDebugMode) {
        debugPrint('✅ Beneficiary deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to delete beneficiary: $e');
      }

      emit(
        state.copyWith(
          isDeleting: false,
          errorMessage: 'Failed to delete beneficiary',
        ),
      );
    }
  }
}
