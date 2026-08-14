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
  JoinCircleDetailReady(this.detail);
  final CircleDetailModel detail;
}

/// 422 — user is not eligible (missing steps).
class JoinCircleIntentBlocked extends JoinCircleState {
  JoinCircleIntentBlocked({required this.reason, required this.missingSteps});
  final String reason;
  final List<String> missingSteps;
}

/// Network / server error during intent check.
class JoinCircleIntentError extends JoinCircleState {
  JoinCircleIntentError(this.message);
  final String message;
}

// ── Position / turn selection ────────────────────────────────

class JoinCirclePositionsLoading extends JoinCircleState {}

class JoinCirclePositionsReady extends JoinCircleState {
  JoinCirclePositionsReady({required this.positions, this.selected});
  final List<PositionModel> positions;
  final PositionModel? selected;
}

class JoinCirclePositionsError extends JoinCircleState {
  JoinCirclePositionsError(this.message);
  final String message;
}

/// User tapped a turn card — position stored in cubit.
class JoinCirclePositionSelected extends JoinCircleState {
  JoinCirclePositionSelected(this.position);
  final PositionModel position;
}

// ── Join / create reservation ────────────────────────────────

class JoinCircleJoining extends JoinCircleState {}

/// 201 — reservation created successfully.
class JoinCircleJoinSuccess extends JoinCircleState {
  JoinCircleJoinSuccess(this.reservation);
  final JoinReservationModel reservation;
}

/// 409 — selected position was taken; user must pick another.
class JoinCirclePositionTaken extends JoinCircleState {}

/// Network / 5xx error during join.
class JoinCircleJoinFailure extends JoinCircleState {
  JoinCircleJoinFailure(this.message);
  final String message;
}

// ── Contract accept ──────────────────────────────────────────

class JoinCircleAcceptingContract extends JoinCircleState {}

/// 200 — contract accepted, OTP sent by backend.
class JoinCircleContractAccepted extends JoinCircleState {
  JoinCircleContractAccepted(this.expiresIn);
  final int expiresIn;
}

/// 410 — reservation expired; user must restart from join.
class JoinCircleReservationExpired extends JoinCircleState {}

class JoinCircleAcceptContractFailure extends JoinCircleState {
  JoinCircleAcceptContractFailure(this.message);
  final String message;
}

// ── OTP verification ─────────────────────────────────────────

class JoinCircleVerifyingOtp extends JoinCircleState {}

/// 200 — OTP verified, membership now ACTIVE.
class JoinCircleJoinComplete extends JoinCircleState {
  JoinCircleJoinComplete(this.result);
  final VerifyOtpResponseModel result;
}

/// Backend returned reason = "invalid_otp".
class JoinCircleOtpInvalid extends JoinCircleState {
  JoinCircleOtpInvalid(this.message);
  final String message;
}

/// Backend returned reason = "otp_expired" — enable resend immediately.
class JoinCircleOtpExpired extends JoinCircleState {
  JoinCircleOtpExpired(this.message);
  final String message;
}

/// Network / unexpected error during OTP verification.
class JoinCircleVerifyOtpFailure extends JoinCircleState {
  JoinCircleVerifyOtpFailure(this.message);
  final String message;
}
