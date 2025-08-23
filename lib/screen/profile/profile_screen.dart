import 'package:community_material_icon/community_material_icon.dart';
import 'package:flightbooking/providers/logout_provider.dart';
import 'package:flightbooking/routes/route_generator.dart';
import 'package:flightbooking/screen/Authentication/login_screen.dart';
import 'package:flightbooking/screen/profile/terms_condition/terms_condition.dart';
import 'package:flightbooking/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../providers/login_provider.dart';
import '../../widgets/constant.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final token = box.read('token');

    final user = loginProvider.user;
    final userName = user != null && user['name'] != null ? user['name'] : 'Guest';
    final userLastName = user != null && user['lname'] != null ? user['lname'] : '';
    final email = user != null && user['email'] != null ? user['email'] : 'Unknown';

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kBlueColor,
        iconTheme: const IconThemeData(color: kWhite),
        title: Text(
          lang.S.of(context).profileTitle,
          style: kTextStyle.copyWith(
            color: kWhite,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics:  const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        'images/logo/applogo.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Center(
                child: Text(
                  "$userName $userLastName ",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  email,
                  style: kTextStyle.copyWith(fontSize: 14, color: kSubTitleColor),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Card(
                elevation: 1.3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: kBorderColorTextField, width: 0.5),
                ),
                child: ListTile(
                  onTap: () {

                    if(token == null){
                      showDialog(
                          context: context,
                          builder: (context){
                            return CustomDialogBox(
                              title: 'Login Required',
                              descriptions: 'Please login first to view your profile.',
                              text: 'ok',
                              img: "images/dialog_error.png" ,
                              titleColor: kRedColor,
                              functionCall: (){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const LogIn()));
                              },
                            );
                          });
                    }else {
                      Navigator.pushNamed(context, AppRoutes.myProfile);
                    }
                  },
                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  leading: Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor.withOpacity(0.2)),
                    child: const Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                  ),
                  title: const Text('My Profile'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: kSubTitleColor,
                  ),
                ),
              ),
              if(token!= null)
              Card(
                elevation: 1.3,
                shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: kBorderColorTextField, width: 0.5),
                ),
                child: ListTile(
                  onTap: (){
                    Navigator.pushNamed(context, AppRoutes.resetPassword);
                  },
                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  leading: Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xff009F5E).withOpacity(0.1)),
                    child: const Icon(
                      CommunityMaterialIcons.key_change,
                      color: kPrimaryColor,
                    ),
                  ),
                  title: const Text('Reset Password'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color : kSubTitleColor
                  ),
                ),
              ).paddingOnly(top: 10),
              
              const SizedBox(height: 10),

              Card(
                elevation: 1.3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: kBorderColorTextField, width: 0.5),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.termsCondition);
                  },
                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  leading: Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xff009F5E).withOpacity(0.1)),
                    child: const Icon(
                      CommunityMaterialIcons.shield_account,
                      color: Color(0xff00CD46),
                    ),
                  ),
                  title: const Text('Terms and Conditions'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: kSubTitleColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Card(
                elevation: 1.3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: kBorderColorTextField, width: 0.5),
                ),
                child: ListTile(
                  onTap: (){
                    Navigator.pushNamed(context, AppRoutes.privacyPolicy);
                  },
                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  leading: Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xff009F5E).withOpacity(0.1)),
                    child: const Icon(
                      CommunityMaterialIcons.file_document_outline ,
                      color: Color(0xff00CD46),
                    ),
                  ),
                  title: const Text('Privacy Policy'),
                  trailing:  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: kSubTitleColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 1.3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: kBorderColorTextField, width: 0.5),
                ),
                child: ListTile(
                  onTap: (){
                    Navigator.pushNamed(context, AppRoutes.refundPolicy);
                  },
                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  leading: Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xff009F5E).withOpacity(0.1)),
                    child: const Icon(
                      CommunityMaterialIcons.cash_refund,
                      color: Color(0xff00CD46),
                    ),
                  ),
                  title: const Text('Refund Policy'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: kSubTitleColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Card(
              //   elevation: 1.3,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(8),
              //     side: const BorderSide(color: kBorderColorTextField, width: 0.5),
              //   ),
              //   child: ListTile(
              //     contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
              //     leading: Container(
              //       height: 34,
              //       width: 34,
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: const Color(0xffFF3B30).withOpacity(0.1),
              //       ),
              //       child: const Icon(
              //         Icons.share,
              //         color: Color(0xffFF3B30),
              //       ),
              //     ),
              //     title: Text(
              //       'Share App',
              //       style: kTextStyle.copyWith(color: kTitleColor),
              //     ),
              //     trailing: const Icon(
              //       Icons.arrow_forward_ios,
              //       size: 18,
              //       color: kSubTitleColor,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),


              if(token!= null)
                Card(
                  elevation: 1.3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: kBorderColorTextField, width: 0.5),
                  ),
                  child: ListTile(
                    onTap: (){
                      // const WelcomeScreen().launch(context,isNewTask: true);
                      _showLogoutOptions();
                    },
                    contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    leading: Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryColor.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: kPrimaryColor,
                      ),
                    ),
                    title: const Text('Log Out'),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: kSubTitleColor,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildLogoutDialogContent(context),
        );
      },
    );
  }

  Widget _buildLogoutDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.logout, color: kPrimaryColor, size: 50),
          const SizedBox(height: 15),
          const Text(
            'Logout From',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ElevatedButton.icon(
            icon: const Icon(Icons.phone_android, color: kWhite,),
            label:  Text('Current Device' , style: kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold,),),
            style: ElevatedButton.styleFrom(
              backgroundColor: kBlueColor,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context.read<LogoutProvider>().logoutCurrentDevice(context);
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.devices, color: kWhite,),
            label:  Text('All Devices', style: kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold,), ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context.read<LogoutProvider>().logoutAllDevices(context);
              // _logoutAllDevices();
            },
          ),

          const SizedBox(height: 10),


          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kTitleColor,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }, child: Text('Cancel', style: kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold,fontSize: 22), ),
          ).paddingOnly(right: 50, left: 50),

        ],
      ),
    );
  }


}
