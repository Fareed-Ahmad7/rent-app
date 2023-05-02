
import 'package:rent_app/model/payment_model.dart';
import 'package:rent_app/model/shop_model.dart';

class Invoice {
  final Shop shop;
  final List<Payment> payment;

  const Invoice({
    required this.shop,
    required this.payment,
  });
}
