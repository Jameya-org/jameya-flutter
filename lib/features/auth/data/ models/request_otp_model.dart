class RequestOtpModel {
  final String email;
  final String purpose;

  RequestOtpModel({
    required this.email,
    this.purpose = 'login',
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'purpose': purpose,
    };
  }
}