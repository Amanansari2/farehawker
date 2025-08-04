import 'package:flightbooking/providers/policy_provider.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => PolicyProvider()..loadPrivacyPolicy(),
        child: Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: kBlueColor,
            iconTheme: const IconThemeData(color: kWhite),
            title: Text(
              'Privacy Policy',
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
                if(provider.privacy == null || provider.privacy!.isEmpty){
                  return const Center(child: Text("No Privacy Policy Available"),);
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Html(data: provider.privacy),
                );
              }),
        ),
    );
  }
}
