import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../api_services/configs/app_configs.dart';
import '../../../widgets/constant.dart';

class PaymentMethod extends StatefulWidget {
  final String orderId;
  final String amount;

  const PaymentMethod({
    Key? key,
    required this.orderId,
    required this.amount,
  }) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  late WebViewController _controller;
  bool isLoading = true;
  String? paymentUrl;


   @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            AppLogger.log("Page started loading: $url");
          },
          onWebResourceError: (error) {
            AppLogger.log("Error loading web resource: ${error.description}");
            setState(() {
              isLoading = false;
            });
             toast("Failed to load payment page.");
          },
          onPageFinished: (url) {
            AppLogger.log("Finished loading: $url");

            if (url.contains("paymentResponse.php")) {
              _controller.runJavaScriptReturningResult("document.body.innerText").then((result) {
                final raw = result?.toString().trim() ?? '';
                AppLogger.log("Raw JS result: $raw");

                dynamic decoded;
                try {
                  final unescaped = jsonDecode(raw);
                  decoded = jsonDecode(unescaped);
                } catch (e) {
                  AppLogger.log("Double jsonDecode failed: $e");
                  Future.microtask(() {
                    showDialog(
                      context: context,
                      builder: (_) => CustomDialogBox(
                        title: 'Payment Failed',
                        descriptions: "Something went Wrong while processing Payment",
                        text: 'Ok',
                        img: 'images/dialog_error.png',
                        titleColor: kRedColor,
                        functionCall: () => Navigator.of(context).pop(),
                      ),
                    );
                  });
                  return;
                }
                AppLogger.log("Decoded JSON: $decoded");

                final message = decoded['message'];
                final paymentStatus = message?['payment_status'] ?? 'Unknown';

                if (paymentStatus == 'Success') {
                  Navigator.of(context).pop({'status': 'success',});
                } else {
                  Navigator.of(context).pop({'status': 'failure', 'message': decoded});
                }


              });
            }

            setState(() {
              isLoading = false;
            });
          },
        ),
      );

    _generatePaymentUrl();
  }





  Future<void> _generatePaymentUrl() async {
    try {
      Dio dio = Dio();

      final formData = FormData.fromMap({
        'trace_id': widget.orderId,
         'total_fare': widget.amount,
        // 'total_fare': "1",
      });

      final response = await dio.post(
        'https://farehawker.com/ff/phone_api/paymentRequest.php',
        data: formData,
        options: Options(
          headers: {
            'action': 'Payment',
            'api-key': AppConfigs.apiKey,
          },
        ),
      );

      final data = response.data;

      if (response.statusCode == 200 && data['status'] == 'success') {
        paymentUrl = data['paymentURL']?.replaceAll(r'\/', '/');
        AppLogger.log("Final Payment URL: $paymentUrl");

        setState(() => isLoading = false);

        if (paymentUrl != null) {
          _controller.loadRequest(Uri.parse(paymentUrl!));
        } else {
          toast("Payment URL missing in response");
        }
      } else {
        setState(() => isLoading = false);
        toast("Payment failed: ${data['status']}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      AppLogger.log("Error: $e");
      toast("Something went wrong");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: kBlueColor,
        title: Text(lang.S.of(context).paymentMethod),
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : paymentUrl == null
          ? const Center(child: Text("Unable to load payment page"))
          : WebViewWidget(controller: _controller), // WebView
    );
  }

  // Payment success popup

}
