import 'package:flightbooking/providers/forgot_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:provider/provider.dart';

import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordProvider(),
      child: Consumer<ForgotPasswordProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: kBlueColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kBlueColor,
              centerTitle: true,
              title: Text(lang.S.of(context).fpAppBarTitle, style: kTextStyle.copyWith(color: kWhite, fontSize: 25, fontWeight: FontWeight.bold),),
            ),
            body: Container(
              height: context.height(),
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [



                      const SizedBox(height: 50.0),
                      Text(
                        'Please provide your email address below, and we will send you a link to reset your password.',
                        textAlign: TextAlign.center,
                        style: kTextStyle.copyWith(color: kSubTitleColor, fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        controller: provider.emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: kTitleColor,
                        textInputAction: TextInputAction.next,
                        decoration: kInputDecoration.copyWith(
                          labelText: lang.S.of(context).emailLabel,
                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: lang.S.of(context).emailHint,
                          hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                          focusColor: kTitleColor,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      ButtonGlobalWithoutIcon(
                        buttontext: provider.isLoading ? " Please wait ..." : "Send Reset Link",
                        buttonDecoration: kButtonDecoration.copyWith(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: provider.isLoading
                          ?null
                            :() {
                           provider.forgotPassword(context);

                        },
                        buttonTextColor: kWhite,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
