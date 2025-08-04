import 'package:flightbooking/providers/policy_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../../widgets/constant.dart';





class TermsConditions extends StatefulWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PolicyProvider()..loadTermsCondition(),
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: kBlueColor,
          iconTheme: const IconThemeData(color: kWhite),
          title: Text(
            'Terms and Conditions',
            style: kTextStyle.copyWith(
              color: kWhite,
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
              if(provider.terms == null || provider.terms!.isEmpty){
                return const Center(child: Text("No Terms & Conditions Available"),);
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Html(data: provider.terms),
              );
            }),
      ),
    );
  }
}
