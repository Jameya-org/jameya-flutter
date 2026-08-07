class RequestOtpModel {
  RequestOtpModel({required this.email, this.purpose = 'login'});
  final String email;
  final String purpose;

  Map<String, dynamic> toJson() {
    return {'email': email, 'purpose': purpose};
  }
}
