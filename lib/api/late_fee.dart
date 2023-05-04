import 'package:calc/calc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CalcLateFee extends StatefulWidget {

  CalcLateFee({Key? key, @required this.shopName}) : super(key: key);
  var shopName;
  var lateFee = 0;

  @override
  State<CalcLateFee> createState() => CalcLlateFeeState();
}

class CalcLlateFeeState extends State<CalcLateFee> {
  @override
  Widget build(BuildContext context) {
    var shop = widget.shopName;
    FirebaseFirestore.instance
        .collection('visanka_complex')
        .doc(shop)
        .collection('PaymentHistory')
        .where('AmountPaid', isEqualTo: 0)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var monthsDue = querySnapshot.docs.length;
          setState(() {
          widget.lateFee = factorial(monthsDue) * 1000;
          });
        }
      },
    );
    return Text(widget.lateFee.toString());
  }
}
