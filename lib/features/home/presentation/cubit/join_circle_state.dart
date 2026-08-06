import '../../data/models/home_dashboard_model.dart';
import '../../data/models/join_circle_models.dart';

abstract class JoinCircleState {}

/// Initial state — cubit just created.
class JoinCircleInitial extends JoinCircleState {}

// ── Intent check + circle detail ────────────────────────────

/// Checking join-intent and loading circle detail.
class JoinCircleIntentLoading extends JoinCircleState {}

/// Circle details loaded and user is eligible to join.
class JoinCircleDetailReady extends JoinCircleState {
  final CircleDetailModel detail;
  JoinCircleDetailReady(this.detail);
}

/// 422 — user is not eligible (missing steps).
class JoinCircleIntentBlocked extends JoinCircleState {
  final String reason;
  final List<String> missingSteps;
  JoinCircleIntentBlocked({required this.reason, required this.missingSteps});
}

/// Network / server error during intent check.
class JoinCircleIntentError extends JoinCircleState {
  final String message;
  JoinCircleIntentError(this.message);
}

// ── Position / turn selection ────────────────────────────────

class JoinCirclePositionsLoading extends JoinCircleState {}

class JoinCirclePositionsReady extends JoinCircleState {
  final List<PositionModel> positions;
  final PositionModel? selected;
  JoinCirclePositionsReady({required this.positions, this.selected});
}

class JoinCirclePositionsError extends JoinCircleState {
  final String message;
  JoinCirclePositionsError(this.message);
}

/// User tapped a turn card — position stored in cubit.
class JoinCirclePositionSelected extends JoinCircleState {
  final PositionModel position;
  JoinCirclePositionSelected(this.position);
}

// ── Join / create reservation ────────────────────────────────

class JoinCircleJoining extends JoinCircleState {}

/// 201 — reservation created successfully.
class JoinCircleJoinSuccess extends JoinCircleState {
  final JoinReservationModel reservation;
  JoinCircleJoinSuccess(this.reservation);
}

/// 409 — selected position was taken; user must pick another.
class JoinCirclePositionTaken extends JoinCircleState {}

/// Network / 5xx error during join.
class JoinCircleJoinFailure extends JoinCircleState {
  final String message;
  JoinCircleJoinFailure(this.message);
}

// ── Contract accept ──────────────────────────────────────────

class JoinCircleAcceptingContract extends JoinCircleState {}

/// 200 — contract accepted, OTP sent by backend.
class JoinCircleContractAccepted extends JoinCircleState {
  final int expiresIn;
  JoinCircleContractAccepted(this.expiresIn);
}

/// 410 — reservation expired; user must restart from join.
class JoinCircleReservationExpired extends JoinCircleState {}

class JoinCircleAcceptContractFailure extends JoinCircleState {
  final String message;
  JoinCircleAcceptContractFailure(this.message);
}

// ── OTP verification ─────────────────────────────────────────

class JoinCircleVerifyingOtp extends JoinCircleState {}

/// 200 — OTP verified, membership now ACTIVE.
class JoinCircleJoinComplete extends JoinCircleState {
  final VerifyOtpResponseModel result;
  JoinCircleJoinComplete(this.result);
}

/// Backend returned reason = "invalid_otp".
class JoinCircleOtpInvalid extends JoinCircleState {
  final String message;
  JoinCircleOtpInvalid(this.message);
}

/// Backend returned reason = "otp_expired" — enable resend immediately.
class JoinCircleOtpExpired extends JoinCircleState {
  final String message;
  JoinCircleOtpExpired(this.message);
}

/// Network / unexpected error during OTP verification.
class JoinCircleVerifyOtpFailure extends JoinCircleState {
  final String message;
  JoinCircleVerifyOtpFailure(this.message);
}
