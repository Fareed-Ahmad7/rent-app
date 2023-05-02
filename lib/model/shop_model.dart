class Shop {
  final String ShopName;
  final String TenantName;
  final String TenantAddress;
  final int PhoneNumber;
  final int TotalRent;
  final int RentPaid;
  final int RentPerMonth;
  final int RentBalance;

  Shop({
    required this.ShopName,
    required this.TenantName,
    required this.TenantAddress,
    required this.PhoneNumber,
    required this.TotalRent,
    required this.RentPaid,
    required this.RentPerMonth,
    required this.RentBalance,
  });

  Map<String, dynamic> toJson() => {
        'ShopName': ShopName,
        'TenantName': TenantName,
        'TenantAddress': TenantAddress,
        'PhoneNumber': PhoneNumber,
        'TotalRent': TotalRent,
        'RentPaid': RentPaid,
        'RentPerMonth': RentPerMonth,
        'RentBalance': RentBalance,
      };

  static Shop fromJson(Map<String, dynamic> json) => Shop(
        ShopName: json['ShopName'],
        TenantName: json['TenantName'],
        TenantAddress: json['TenantAddress'],
        PhoneNumber: json['PhoneNumber'],
        TotalRent: json['TotalRent'],
        RentPaid: json['RentPaid'],
        RentPerMonth: json['RentPerMonth'],
        RentBalance: json['RentBalance'],
      );
}
