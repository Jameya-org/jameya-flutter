class VerifyOtpModel {
  VerifyOtpModel({
    required this.email,
    required this.otp,
    this.purpose = 'login',
  });
  final String email;
  final String otp;
  final String purpose;

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': otp, 'purpose': purpose};
  }
}
