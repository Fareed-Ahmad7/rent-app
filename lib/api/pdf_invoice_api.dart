import 'dart:io';
import 'package:rent_app/api/pdf_api.dart';
import 'package:rent_app/model/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(invoice, "Shop Details"),
        buildDetails(invoice),
        SizedBox(height: 20),
        buildTitle(invoice, "Payment History"),
        buildInvoice(invoice),
      ],
      // footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: '${invoice.shop.ShopName}.pdf', pdf: pdf);
  }

  static Widget buildTitle(Invoice invoice, String title) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildDetails(Invoice invoice) {
    final titles = <String>[
      'Shop Name',
      'Tenant Name',
      'Tenant Address',
      'Phone Number',
      'Rent Per Month',
      'Total Rent',
      'Rent Balance',
      'Rent Paid',
    ];
    final data = <String>[
      invoice.shop.ShopName,
      invoice.shop.TenantName,
      invoice.shop.TenantAddress,
      (invoice.shop.PhoneNumber).toString(),
      (invoice.shop.RentPerMonth).toString(),
      (invoice.shop.TotalRent).toString(),
      (invoice.shop.RentBalance).toString(),
      (invoice.shop.RentPaid).toString(),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Bill Date',
      'Actual Rent',
      'Amount Paid',
      'Balance',
      'Method',
      'Paid Date',
      'Transaction ID',
    ];
    final data = invoice.payment.map((item) {
      return [
        item.BillDate,
        item.ActualRent,
        item.AmountPaid,
        item.BalanceAmount,
        item.PaymentMethod,
        item.PaidDate,
        item.TransactionID,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      headerAlignment: Alignment.centerLeft,
      headerPadding: EdgeInsets.all(16),
      cellAlignment: Alignment.center,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
