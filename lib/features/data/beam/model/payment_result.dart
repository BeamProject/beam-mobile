class PaymentResult {
  final bool success;

  PaymentResult(this.success);

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(json['success']);
  }
}
