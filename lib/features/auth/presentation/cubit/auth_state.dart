abstract class AuthState {}

class AuthInitial extends AuthState {}

/// Request OTP

class RequestOtpLoading extends AuthState {}

class RequestOtpSuccess extends AuthState {}

class RequestOtpFailure extends AuthState {
  final String message;

  RequestOtpFailure(this.message);
}

/// Verify OTP

class VerifyOtpLoading extends AuthState {}

class VerifyOtpSuccess extends AuthState {}

class VerifyOtpFailure extends AuthState {
  final String message;

  VerifyOtpFailure(this.message);
}


class CreateAccountLoading extends AuthState {}

class CreateAccountSuccess extends AuthState {}

class CreateAccountFailure extends AuthState {
  final String message;

  CreateAccountFailure(this.message);
}