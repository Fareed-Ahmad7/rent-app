import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_app/api/pdf_api.dart';
import 'package:rent_app/api/pdf_invoice_api.dart';
import 'package:rent_app/model/invoice.dart';
import 'package:rent_app/model/payment_model.dart';
import 'package:rent_app/model/shop_model.dart';
import 'package:rent_app/pages/signature.dart';

class ShopDetails extends StatefulWidget {
  ShopDetails({Key? key, required this.shop_details}) : super(key: key);

  final Shop shop_details;

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  final List<Payment> payment_details = [];

  final headerStyle = const TextStyle(
      fontFamily: 'Nunito', fontWeight: FontWeight.bold, letterSpacing: 0.5);

  final textStyle = const TextStyle(fontFamily: 'Nunito', letterSpacing: 0.5);

  @override
  Widget build(BuildContext context) {
    Stream<List<Payment>> readPaymentDetails() => FirebaseFirestore.instance
        .collection('visanka_complex')
        .doc(widget.shop_details.ShopName)
        .collection('PaymentHistory')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Payment.fromJson(doc.data())).toList());

    Widget buildPaymentsList(Payment payment) {
      payment_details.add(payment);
      return paymentsHistoryContainer(payment);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.shop_details.ShopName,
          style: const TextStyle(
              fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: generatePdf,
                child: const Icon(
                  Icons.picture_as_pdf,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          shopDetailsHeader(),
          shopDetailsContainer(),
          paymentHistoryHeader(),
          Expanded(
            child: StreamBuilder<List<Payment>>(
                stream: readPaymentDetails(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final payments = snapshot.data!;
                    return ListView(
                      shrinkWrap: true,
                      children: payments.map(buildPaymentsList).toList(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  void generatePdf() async {
    final invoice = Invoice(
        shop: Shop(
            ShopName: widget.shop_details.ShopName,
            TenantName: widget.shop_details.TenantName,
            TenantAddress: widget.shop_details.TenantAddress,
            PhoneNumber: widget.shop_details.PhoneNumber,
            TotalRent: widget.shop_details.TotalRent,
            RentPaid: widget.shop_details.RentPaid,
            RentPerMonth: widget.shop_details.RentPerMonth,
            RentBalance: widget.shop_details.RentBalance),
        payment: payment_details);

    final pdfFile = await PdfInvoiceApi.generate(invoice);
    PdfApi.openFile(pdfFile);
  }

  Container paymentHistoryHeader() {
    return Container(
      child: const Text(
        'Payment History',
        style: TextStyle(
            fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 24),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(24, 12, 0, 12),
    );
  }

  Container shopDetailsHeader() {
    return Container(
      child: const Text(
        'Shop Details',
        style: TextStyle(
            fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 24),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(24, 24, 0, 0),
    );
  }

  Container shopDetailsContainer() {
    return Container(
        margin: const EdgeInsets.fromLTRB(
          0,
          24,
          0,
          24,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TENANT NAME', style: headerStyle),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(widget.shop_details.TenantName, style: textStyle),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PHONE NUMBER', style: headerStyle),
                        const SizedBox(
                          height: 3,
                        ),
                        Text((widget.shop_details.PhoneNumber).toString(),
                            style: textStyle),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RENT BALANCE', style: headerStyle),
                        const SizedBox(
                          height: 3,
                        ),
                        Text((widget.shop_details.RentBalance).toString(),
                            style: textStyle),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TENANT ADDRESS', style: headerStyle),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(widget.shop_details.TenantAddress,
                            style: textStyle),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL RENT', style: headerStyle),
                        const SizedBox(
                          height: 3,
                        ),
                        Text((widget.shop_details.TotalRent.toString()),
                            style: textStyle),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RENT PAID', style: headerStyle),
                        const SizedBox(
                          height: 3,
                        ),
                        Text((widget.shop_details.RentPaid).toString(),
                            style: textStyle),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ));
  }

  loadSignature(sign, month) {
    if (sign == '') {
      return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignaturePage(collection: widget.shop_details.ShopName, document: month,)));
        },
        child: const Text('Tap to add', style: TextStyle(color: Colors.blue)),
      );
    } else {
      return Container(
        width: 50.0,
        height: 20.0,
        decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image:  DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(sign),),
      ));
    }
  }

  Padding paymentsHistoryContainer(Payment payment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
              margin: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('BILL DATE', style: headerStyle),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(payment.BillDate, style: textStyle),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ACTUAL RENT', style: headerStyle),
                              const SizedBox(
                                height: 3,
                              ),
                              Text((payment.ActualRent).toString(),
                                  style: textStyle),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('BALANCE', style: headerStyle),
                              const SizedBox(
                                height: 3,
                              ),
                              Text((payment.BalanceAmount).toString(),
                                  style: textStyle),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('TRANSC ID', style: headerStyle),
                              const SizedBox(
                                height: 3,
                              ),
                              Text((payment.TransactionID).toString(),
                                  style: textStyle),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PAID DATE', style: headerStyle),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(payment.PaidDate, style: textStyle),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('RENT PAID', style: headerStyle),
                              const SizedBox(
                                height: 3,
                              ),
                              Text((payment.AmountPaid).toString(),
                                  style: textStyle),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('METHOD', style: headerStyle),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(payment.PaymentMethod, style: textStyle),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SIGNATURE', style: headerStyle),
                              const SizedBox(
                                height: 3,
                              ),
                              loadSignature(payment.Sign, payment.BillDate)
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ))),
    );
  }
}
