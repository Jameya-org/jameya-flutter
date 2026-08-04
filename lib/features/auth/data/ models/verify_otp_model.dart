class VerifyOtpModel {
  final String email;
  final String otp;
  final String purpose;

  VerifyOtpModel({
    required this.email,
    required this.otp,
    this.purpose = 'login',
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'purpose': purpose,
    };
  }
}