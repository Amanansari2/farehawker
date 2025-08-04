import 'package:flightbooking/providers/policy_provider.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class RefundPolicy extends StatefulWidget {
  const RefundPolicy({super.key});

  @override
  State<RefundPolicy> createState() => _RefundPolicyState();
}

class _RefundPolicyState extends State<RefundPolicy> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => PolicyProvider().. loadRefundPolicy(),
      child: Scaffold(
        backgroundColor:
        kWhite,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: kBlueColor,
          iconTheme: const IconThemeData(color: kWhite),
          title: Text(
              'Refund Policy',
            style: kTextStyle.copyWith(
              color: kWhite
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<PolicyProvider>(
            builder: (context, provider, child){
              if(provider.isLoading){
                return const Center(child: CircularProgressIndicator(),);
              }
              if(provider.errorMessage != null){
                return Center(child: Text('Error : ${provider.errorMessage}'),);
              }
              if(provider.refund == null || provider.refund!.isEmpty){
                return const Center(child: Text("No Refund Policy Available"),);
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Html(data: provider.refund),
              );
            }),
      ),

    );
  }
}
