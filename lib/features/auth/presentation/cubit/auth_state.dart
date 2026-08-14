abstract class AuthState {}

class AuthInitial extends AuthState {}

/// Request OTP

class RequestOtpLoading extends AuthState {}

class RequestOtpSuccess extends AuthState {}

class RequestOtpFailure extends AuthState {
  RequestOtpFailure(this.message);
  final String message;
}

/// Verify OTP

class VerifyOtpLoading extends AuthState {}

class VerifyOtpSuccess extends AuthState {}

class VerifyOtpFailure extends AuthState {
  VerifyOtpFailure(this.message);
  final String message;
}

class CreateAccountLoading extends AuthState {}

class CreateAccountSuccess extends AuthState {}

class CreateAccountFailure extends AuthState {
  CreateAccountFailure(this.message);
  final String message;
}
