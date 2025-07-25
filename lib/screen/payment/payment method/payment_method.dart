import 'dart:convert';
import 'package:flightbooking/api_services/configs/urls.dart';
import 'package:flutter/material.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../api_services/api_request/post_request.dart';
import '../../../api_services/configs/app_configs.dart';
import '../../../widgets/button_global.dart';
import '../../../widgets/constant.dart';
import '../../home/home.dart';
import '../../ticket status/ticket_status.dart';

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
  final PostService _postService = PostService();
  final WebViewController _controller = WebViewController();
  bool isLoading = true;
  String? paymentUrl;

  @override
  void initState() {
    super.initState();
    _generatePaymentUrl();
  }

  Future<void> _generatePaymentUrl() async {

    try {

      final response = await _postService.postRequest(
          endPoint: flightSearch,
          body: {
            "order_id":widget.orderId,
            "amount" : widget.amount
          },
      requireAuth: false,
        customHeaders: {
          'action': 'countries',
          'api-key' :  AppConfigs.apiKey
        }
      );

      if (response["status"] == 200) {
        final data = response;
        paymentUrl = data["payment_url"];

        if (paymentUrl != null) {
          _controller
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onNavigationRequest: (navReq) {
                  if (navReq.url.contains("payment-success")) {
                    Future.microtask(() => showSuccessPopup());
                    return NavigationDecision.prevent;
                  } else if (navReq.url.contains("payment-failure")) {
                    Future.microtask(() {
                      toast('Payment failed, please try again.');
                      Navigator.pop(context);
                    });
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse(paymentUrl!));
        }

        setState(() => isLoading = false);
      } else {
        setState(() => isLoading = false);
        toast("Failed to initialize payment");
      }
    } catch (e) {
      setState(() => isLoading = false);
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
          : WebViewWidget(controller: _controller),
    );
  }

  void showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 118.0,
                  width: 133.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/success.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Payment Succeed!',
                  style: kTextStyle.copyWith(
                    color: kTitleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                Text(
                  'Thank you for purchasing the ticket!',
                  textAlign: TextAlign.center,
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                const SizedBox(height: 10.0),
                ButtonGlobalWithoutIcon(
                  buttontext: 'View Ticket',
                  buttonDecoration:
                  kButtonDecoration.copyWith(color: kPrimaryColor),
                  onPressed: () {
                    finish(context);
                    const TicketStatus().launch(context);
                  },
                  buttonTextColor: kWhite,
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    finish(context);
                    const Home().launch(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FeatherIcons.arrowLeft,
                        color: kSubTitleColor,
                      ),
                      Text(
                        'Back to Home',
                        style: kTextStyle.copyWith(color: kSubTitleColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
