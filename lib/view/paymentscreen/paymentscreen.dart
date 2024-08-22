import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whitematrix/constants/colorconstants.dart/colorconstants.dart';
import 'package:whitematrix/controller/cartcontroller.dart';
import 'package:whitematrix/model/productmodel.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    double amount = context.read<Cartcontroller>().totalPrice();
    List<ProductModel> products = context.read<Cartcontroller>().cartlist;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.primaryBlack,
                    ),
                  ),
                  Text(
                    "\₹${amount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (amount <= 0) {
                    showAlertDialog(context, "Invalid Amount",
                        "Please add items to your cart to proceed with payment.");
                    return;
                  }

                  var options = {
                    'key': 'rzp_test_OZLq5TZcJ6rhwg',
                    'amount': (amount * 100).toInt(),
                    'name': 'crypteddata Corp.',
                    'description': 'Purchase of spices',
                    'retry': {'enabled': true, 'max_count': 1},
                    'send_sms_hash': true,
                    'prefill': {
                      'contact': '919562106384',
                      'email': 'test@razorpay.com'
                    },
                    'external': {
                      'wallets': ['paytm']
                    }
                  };
                  _razorpay.open(options);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryGreen,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "Proceed to Pay",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String transactionId =
                      "TXN${DateTime.now().millisecondsSinceEpoch}";
                  String filePath =
                      await generateBillPdf(amount, products, transactionId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewScreen(filePath: filePath),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryBlack,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "View Bill",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> generateBillPdf(
      double amount, List<ProductModel> products, String transactionId) async {
    final pdf = pw.Document();
    final dateOfPurchase = DateTime.now();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Invoice',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Transaction ID: $transactionId'),
              pw.Text(
                  'Date of Purchase: ${dateOfPurchase.toLocal().toString().split(' ')[0]}'),
              pw.SizedBox(height: 20),
              pw.Text('Products:'),
              pw.SizedBox(height: 10),
              ...products.map((product) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(product.title),
                    pw.Text('Qty: ${product.quantity}'),
                    pw.Text(
                        'Price: ₹${(product.price * product.quantity).toStringAsFixed(2)}'),
                  ],
                );
              }).toList(),
              pw.SizedBox(height: 20),
              pw.Text('Total Amount: ₹${amount.toStringAsFixed(2)}'),
            ],
          );
        },
      ),
    );

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/Invoice.pdf');
    await file.writeAsBytes(await pdf.save());

    print("PDF saved at: ${file.path}");
    return file.path;
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata: ${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    showAlertDialog(context, "Order Placed Successfully",
        "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    AlertDialog alert = AlertDialog(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class PdfViewScreen extends StatelessWidget {
  final String filePath;

  const PdfViewScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              await _savePdfToDownloads(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              final XFile pdfFile = XFile(filePath);
              Share.shareXFiles([pdfFile], text: 'Here is your invoice.');
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }

  Future<void> _savePdfToDownloads(BuildContext context) async {
    try {
      final Directory? downloadsDirectory = await getDownloadsDirectory();

      if (downloadsDirectory != null) {
        final File newFile = File(
            '${downloadsDirectory.path}/Invoice_${DateTime.now().millisecondsSinceEpoch}.pdf');

        await File(filePath).copy(newFile.path);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invoice saved to Downloads')),
        );
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save invoice: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}
