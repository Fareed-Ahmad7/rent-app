class Payment {
  final String BillDate;
  final int ActualRent;
  final int AmountPaid;
  final int BalanceAmount;
  final String PaymentMethod;
  final String PaidDate;
  final String TransactionID;

  Payment({
    required this.BillDate,
    required this.ActualRent,
    required this.AmountPaid,
    required this.BalanceAmount,
    required this.PaymentMethod,
    required this.PaidDate,
    required this.TransactionID,
  });

  Map<String, dynamic> toJson() => {
        'BillDate': BillDate,
        'ActualRent': ActualRent,
        'AmountPaid': AmountPaid,
        'BalanceAmount': BalanceAmount,
        'PaymentMethod': PaymentMethod,
        'PaidDate': PaidDate,
        'TransactionID': TransactionID,
      };

  static Payment fromJson(Map<String, dynamic> json) => Payment(
        BillDate: json['BillDate'],
        ActualRent: json['ActualRent'],
        AmountPaid: json['AmountPaid'],
        BalanceAmount: json['BalanceAmount'],
        PaymentMethod: json['PaymentMethod'],
        PaidDate: json['PaidDate'],
        TransactionID: json['TransactionID'],
      );
}
