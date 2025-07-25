import 'package:flightbooking/screen/Authentication/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;

import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../home/home.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () {
                        const Home().launch(context);
                      },
                      child: Text(
                        lang.S.of(context).skipButton,
                        style: kTextStyle.copyWith(color: kTitleColor),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
             Center(
               child:
                Container(
                  height: 142,
                  width: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/logo/farehawker_logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
             ),
              const SizedBox(height: 40.0),
              Container(
                width: context.width(),
                height: context.height(),
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 5.0,
                        width: 60.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kBorderColorTextField),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        lang.S.of(context).wcTitle,
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        lang.S.of(context).wcSubTitle,
                        style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        lang.S.of(context).wcDescription,
                        textAlign: TextAlign.center,
                        style: kTextStyle.copyWith(color: kSubTitleColor),
                      ),
                      const SizedBox(height: 50.0),
                      ButtonGlobalWithoutIcon(
                        buttontext: lang.S.of(context).createAccButton,
                        buttonDecoration: kButtonDecoration.copyWith(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          const SignUp().launch(context);
                        },
                        buttonTextColor: kWhite,
                      ),
                      ButtonGlobalWithoutIcon(
                        buttontext: lang.S.of(context).loginButton,
                        buttonDecoration: kButtonDecoration.copyWith(
                          color: kWhite,
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          const LogIn().launch(context);
                        },
                        buttonTextColor: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
