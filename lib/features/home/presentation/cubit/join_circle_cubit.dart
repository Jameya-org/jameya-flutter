import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/home_dashboard_model.dart';
import '../../data/models/join_circle_models.dart';
import '../../data/repos/home_repo.dart';
import 'join_circle_state.dart';

/// Manages the entire join circle wizard state.
///
/// One instance is created per flow entry (registered as factory in GetIt)
/// and passed as GoRouter `extra` between all join screens so state is
/// preserved across Back navigation without reloading from the API.
class JoinCircleCubit extends Cubit<JoinCircleState> {
  JoinCircleCubit(this.homeRepo) : super(JoinCircleInitial());

  final HomeRepo homeRepo;

  // ── Persistent flow state ────────────────────────────────────
  // These fields survive navigation between steps. They are only
  // reset if explicitly needed (e.g. after a 410 reservation expiry).

  String circleId = '';
  CircleDetailModel? circleDetail;

  List<PositionModel> positions = [];
  PositionModel? selectedPosition;
  bool _positionsLoaded = false;

  JoinReservationModel? reservation;
  String? membershipId;
  EmbeddedContractModel? contract;

  int otpExpiresIn = 60;

  // ── Intent check + circle detail ────────────────────────────

  /// Checks join-intent and loads circle details in one shot.
  /// Emits [JoinCircleIntentBlocked] (422) or [JoinCircleDetailReady].
  /// Re-uses cached detail if already loaded for the same circleId.
  Future<void> checkIntentAndLoadDetail(String id) async {
    // If we already have the detail for this circle (Back nav), re-emit.
    if (circleDetail != null && circleId == id) {
      emit(JoinCircleDetailReady(circleDetail!));
      return;
    }

    circleId = id;
    emit(JoinCircleIntentLoading());

    try {
      // 1. Check eligibility
      final intent = await homeRepo.checkJoinIntent(id);
      if (!intent.canJoin) {
        // canJoin=false with no 422 — treat as generic block.
        emit(JoinCircleIntentBlocked(
          reason: intent.message,
          missingSteps: [],
        ));
        return;
      }

      // 2. Load circle detail
      circleDetail = await homeRepo.getCircleDetail(id);
      emit(JoinCircleDetailReady(circleDetail!));
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = _responseData(e);
      debugPrint('[JoinCircleCubit] intent DioException $statusCode: $data');

      if (statusCode == 422) {
        final reason = data?['reason']?.toString() ?? 'eligibility_incomplete';
        final steps = (data?['missingSteps'] as List<dynamic>? ?? [])
            .map((s) => s.toString())
            .toList();
        emit(JoinCircleIntentBlocked(reason: reason, missingSteps: steps));
      } else {
        emit(JoinCircleIntentError(
          data?['message']?.toString() ?? e.message ?? 'حدث خطأ',
        ));
      }
    } catch (e, st) {
      debugPrint('[JoinCircleCubit] intent error: $e\n$st');
      emit(JoinCircleIntentError(e.toString()));
    }
  }

  // ── Position loading ─────────────────────────────────────────

  /// Loads positions. Skips the API call if already loaded.
  /// Pass [forceRefresh: true] after a 409 position-taken error.
  Future<void> loadPositions({bool forceRefresh = false}) async {
    if (_positionsLoaded && !forceRefresh && positions.isNotEmpty) {
      emit(JoinCirclePositionsReady(
        positions: positions,
        selected: selectedPosition,
      ));
      return;
    }

    emit(JoinCirclePositionsLoading());
    try {
      final model = await homeRepo.getCirclePositions(circleId);
      positions = model.positions;
      _positionsLoaded = true;
      emit(JoinCirclePositionsReady(
        positions: positions,
        selected: selectedPosition,
      ));
    } on DioException catch (e) {
      final data = _responseData(e);
      emit(JoinCirclePositionsError(
        data?['message']?.toString() ?? e.message ?? 'حدث خطأ',
      ));
    } catch (e, st) {
      debugPrint('[JoinCircleCubit] loadPositions error: $e\n$st');
      emit(JoinCirclePositionsError(e.toString()));
    }
  }

  /// Selects a turn card. Stored in cubit — survives Back navigation.
  void selectPosition(PositionModel position) {
    selectedPosition = position;
    emit(JoinCirclePositionSelected(position));
  }

  // ── Join / create reservation ────────────────────────────────

  /// Calls POST /customer/circles/{id}/join with the selected position.
  /// • 201 → [JoinCircleJoinSuccess]
  /// • 409 → [JoinCirclePositionTaken] + auto-refresh positions
  /// • 422 → [JoinCircleIntentBlocked]
  Future<void> submitJoin({
    String? paymentMethodId,
    String? cardToken,
  }) async {
    if (selectedPosition == null) return;

    emit(JoinCircleJoining());
    try {
      reservation = await homeRepo.joinCircle(
        circleId,
        selectedPosition!.position,
        paymentMethodId: paymentMethodId,
        cardToken: cardToken,
      );
      membershipId = reservation!.membershipId;
      contract = reservation!.contract;
      emit(JoinCircleJoinSuccess(reservation!));
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = _responseData(e);
      debugPrint('[JoinCircleCubit] submitJoin DioException $statusCode: $data');

      if (statusCode == 409) {
        // Position was taken — force-reload positions on next visit.
        _positionsLoaded = false;
        selectedPosition = null;
        emit(JoinCirclePositionTaken());
      } else if (statusCode == 422) {
        final reason = data?['reason']?.toString() ?? 'eligibility_incomplete';
        final steps = (data?['missingSteps'] as List<dynamic>? ?? [])
            .map((s) => s.toString())
            .toList();
        emit(JoinCircleIntentBlocked(reason: reason, missingSteps: steps));
      } else {
        emit(JoinCircleJoinFailure(
          data?['message']?.toString() ?? e.message ?? 'حدث خطأ',
        ));
      }
    } catch (e, st) {
      debugPrint('[JoinCircleCubit] submitJoin error: $e\n$st');
      emit(JoinCircleJoinFailure(e.toString()));
    }
  }

  // ── Contract accept ──────────────────────────────────────────

  /// Calls POST /customer/join/{membershipId}/contract/accept.
  /// On success, the backend sends the OTP automatically.
  /// • 200 → [JoinCircleContractAccepted]
  /// • 410 → [JoinCircleReservationExpired]
  Future<void> acceptContract({
    required bool agreedToTerms,
    required bool agreedToInstallmentSchedule,
    required bool agreedToLateFees,
  }) async {
    if (membershipId == null) return;

    emit(JoinCircleAcceptingContract());
    try {
      final result = await homeRepo.acceptContract(
        membershipId!,
        agreedToTerms: agreedToTerms,
        agreedToInstallmentSchedule: agreedToInstallmentSchedule,
        agreedToLateFees: agreedToLateFees,
      );
      otpExpiresIn = result.expiresIn;
      emit(JoinCircleContractAccepted(result.expiresIn));
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = _responseData(e);
      debugPrint('[JoinCircleCubit] acceptContract DioException $statusCode: $data');

      if (statusCode == 410) {
        // Reservation expired — clear reservation so user can re-join.
        reservation = null;
        membershipId = null;
        contract = null;
        emit(JoinCircleReservationExpired());
      } else {
        emit(JoinCircleAcceptContractFailure(
          data?['message']?.toString() ?? e.message ?? 'حدث خطأ',
        ));
      }
    } catch (e, st) {
      debugPrint('[JoinCircleCubit] acceptContract error: $e\n$st');
      emit(JoinCircleAcceptContractFailure(e.toString()));
    }
  }

  // ── OTP verification ─────────────────────────────────────────

  /// Calls POST /customer/join/{membershipId}/contract/verify-otp.
  /// • 200        → [JoinCircleJoinComplete]
  /// • invalid_otp → [JoinCircleOtpInvalid] (keep on OTP screen)
  /// • otp_expired → [JoinCircleOtpExpired] (enable resend)
  Future<void> verifyOtp(String otp) async {
    if (membershipId == null) return;

    emit(JoinCircleVerifyingOtp());
    try {
      final result = await homeRepo.verifyJoinOtp(membershipId!, otp);
      emit(JoinCircleJoinComplete(result));
    } on DioException catch (e) {
      final data = _responseData(e);
      final reason = data?['reason']?.toString() ?? '';
      final message = data?['message']?.toString() ?? e.message ?? 'حدث خطأ';
      debugPrint('[JoinCircleCubit] verifyOtp reason=$reason');

      if (reason == 'invalid_otp') {
        emit(JoinCircleOtpInvalid(message));
      } else if (reason == 'otp_expired') {
        emit(JoinCircleOtpExpired(message));
      } else {
        emit(JoinCircleVerifyOtpFailure(message));
      }
    } catch (e, st) {
      debugPrint('[JoinCircleCubit] verifyOtp error: $e\n$st');
      emit(JoinCircleVerifyOtpFailure(e.toString()));
    }
  }

  // ── Helpers ──────────────────────────────────────────────────

  Map<String, dynamic>? _responseData(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  /// Computes the expected payout date for a given position number
  /// by offsetting the circle's start date by (position - 1) months.
  String computePayoutDate(int position) {
    final startDate = circleDetail?.startDate ?? '';
    if (startDate.isEmpty) return '—';
    try {
      final date = DateTime.parse(startDate);
      int month = date.month + (position - 1);
      final year = date.year + (month - 1) ~/ 12;
      month = ((month - 1) % 12) + 1;
      final payout = DateTime(year, month, date.day);
      return '${payout.day} ${_arabicMonth(payout.month)}';
    } catch (_) {
      return '—';
    }
  }

  static String _arabicMonth(int month) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return months[(month - 1).clamp(0, 11)];
  }
}
