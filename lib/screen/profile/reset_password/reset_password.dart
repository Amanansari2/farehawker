import 'package:flightbooking/routes/route_generator.dart';
import 'package:flightbooking/widgets/button_global.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;


import '../../../providers/reset_password_provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResetPasswordProvider(),
      child: Consumer<ResetPasswordProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: kWhite,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: kBlueColor,
              iconTheme: const IconThemeData(color: kWhite),
              title: Text(
                'Reset Password',
                style: kTextStyle.copyWith(
                  color: kWhite
                ),
              ),
              centerTitle: true,
            ),

            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 25.0, left: 25.0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    )
                  ),
                  child: Column(
                    mainAxisSize:  MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current Password :", style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 20),),

                          const SizedBox(height: 10,),

                          TextFormField(
                            controller: provider.currentPasswordController,
                            obscureText: provider.hideCurrentPassword,
                            decoration: kInputDecoration.copyWith(
                              labelText: "Current Password",
                              suffixIcon: IconButton(
                                  onPressed: provider.toggleCurrentPassword,
                                  icon: Icon(
                                    provider.hideCurrentPassword ? Icons.visibility_off : Icons.visibility
                                  ))
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("New Password :", style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 20),),
                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: provider.newPasswordController,
                            obscureText: provider.hideNewPassword,
                            decoration: kInputDecoration.copyWith(
                              labelText: "New Password",
                              suffixIcon: IconButton(
                                  onPressed: provider.toggleNewPassword,
                                  icon: Icon(
                                    provider.hideNewPassword ? Icons.visibility_off : Icons.visibility
                                  ))
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 25,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Confirm Password :", style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 20),),
                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: provider.confirmPasswordController,
                            obscureText: provider.hideConfirmPassword,
                            decoration: kInputDecoration.copyWith(
                              labelText: "Confirm Password",
                              suffixIcon: IconButton(
                                  onPressed: provider.toggleConfirmPassword,
                                  icon: Icon(
                                    provider.hideConfirmPassword ? Icons.visibility_off : Icons.visibility
                                  ))
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.forgotPassword);
                            },
                            child: Text(
                              lang.S.of(context).forgotPassword,
                              style: kTextStyle.copyWith(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25,),

                      ButtonGlobalWithoutIcon(
                          buttontext: provider.isLoading ? "Please wait..." : "Reset Password",
                          buttonDecoration: kButtonDecoration.copyWith(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          onPressed: provider.isLoading
                            ? null
                            :(){
                               provider.resetPassword(context);
                          },
                          buttonTextColor: kWhite)
                    ],
                  ) ,
                )
              ],
            )

          );
        }
      ),
    );
  }
}
