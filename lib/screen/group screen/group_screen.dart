import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:flightbooking/providers/group_booking_provider.dart';
import 'package:flightbooking/widgets/button_global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../models/country_list_model.dart';
import '../../providers/country_provider.dart';
import '../../providers/login_provider.dart';
import '../../routes/route_generator.dart';
import '../../widgets/constant.dart';
import '../../widgets/custom_dialog.dart';

class GroupBookingScreen extends StatefulWidget {
  const GroupBookingScreen({super.key});

  @override
  State<GroupBookingScreen> createState() => _GroupBookingScreenState();
}

class _GroupBookingScreenState extends State<GroupBookingScreen>  with TickerProviderStateMixin {

  final box = GetStorage();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<GroupBookingProvider>();
      provider.setFromCity(
        City(
          cityCode: 'DEL',
          city: 'Delhi',
          country: 'India',
        ),
      );
      provider.setToCity(
        City(
          cityCode: 'BOM',
          city: 'Mumbai',
          country: 'India',
        ),
      );

      provider.setTripIndex(0);
      tabController.animateTo(0);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroupBookingProvider>();

    return SafeArea(
      top: false,
        child: Scaffold(
          backgroundColor: kDarkWhite,
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                      child: Material(
                        borderRadius: BorderRadius.circular(30),
                        elevation: 1,
                        shadowColor: kDarkWhite,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: const Offset(0, 2)
                              )
                            ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFromToTabs(provider, context),
                              const SizedBox(height: 20,),
                              _buildFromToInput(provider, context),
                              const SizedBox(height: 20),

                              _buildDateInput(provider, context),

                              if (provider.selectedGroupTripIndex == 1) ...[
                                const SizedBox(height: 20),
                                _buildReturnDateInput(provider, context),
                              ],
                              const SizedBox(height: 20),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: _textField("Adult Count", "00" , provider.adultCountController, inputType: TextInputType.number )),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                      child: _textField("Child Count", "00", provider.childCountController, inputType: TextInputType.number  )),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                      child: _textField("Infant Count", "00", provider.infantCountController, inputType: TextInputType.number  )),
                                  
                                ],
                              ),
                              const SizedBox(height: 20),
                              _textField("Full Name", "Please enter your name...", provider.fullNameController),

                              const SizedBox(height: 20),
                              _textField("Contact Number", "Please enter your Contact Number", provider.contactController, inputType: TextInputType.number),

                              const SizedBox(height: 20),
                              _textField("Email Id", "Please enter your email id...", provider.emailController, inputType: TextInputType.emailAddress),

                              const SizedBox(height: 20),
                              _buildSubmitQuery(context, provider),


                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),
        ));
  }

  Widget _buildHeader(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final user = loginProvider.user;

    final userName = user?['name'] ?? 'Guest';
    final userLastName = user?['lname'] ?? '';

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          height: 210,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
            image: DecorationImage(
                image: AssetImage('images/bg.png'), fit: BoxFit.cover),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('images/logo/applogo.png'),
                  ),
                ),
                title: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                  child: Text(lang.S
                      .of(context)
                      .welcome,
                      style: kTextStyle.copyWith(color: kWhite, fontSize: 14)),
                ),
                subtitle: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                  child: Text(
                    "$userName $userLastName",
                    style: kTextStyle.copyWith(
                        color: kWhite, fontWeight: FontWeight.bold),),
                ),
                // trailing: GestureDetector(
                //   onTap: () =>
                //       Navigator.pushNamed(context, AppRoutes.notification),
                //   child: const CircleAvatar(
                //     backgroundColor: Colors.transparent,
                //     child: Icon(
                //       FeatherIcons.bell,
                //       color: kWhite,
                //     ),
                //   ),
                // ),
              ),
              Text(
                lang.S
                    .of(context)
                    .bookFlightTitle,
                style: kTextStyle.copyWith(
                    color: kWhite, fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
            ],
          ),
        ).paddingOnly(top: 25)
      ],
    );
  }

  Widget _buildFromToTabs(GroupBookingProvider provider, BuildContext ctx) {
    return IgnorePointer(
      ignoring: provider.isLoading,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEDF0FF),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TabBar(
            controller: tabController,
            labelStyle: kTextStyle.copyWith(color: Colors.white),
            unselectedLabelColor: kPrimaryColor,
            indicatorColor: kPrimaryColor,
            labelColor: kWhite,
            indicator:
            const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              shape: BoxShape.rectangle,
              color: kBlueColor,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (index) {
              provider.setTripIndex(index);
            },
            tabs: [
              Tab(text: lang.S
                  .of(context)
                  .tab1),
              Tab(text: lang.S
                  .of(context)
                  .tab2),
            ]),
      ),
    );
  }

  Widget _buildFromToInput(GroupBookingProvider provider,
      BuildContext context) {
    final countryProvider = context.watch<CountryProvider>();
    return Row(
      children: [
        Expanded(child: _cityField(
            context, countryProvider, provider.fromCity, provider.setFromCity,
            lang.S
                .of(context)
                .fromTitle, provider)),
        const SizedBox(width: 10),
        Expanded(child: _cityField(
            context, countryProvider, provider.toCity, provider.setToCity,
            lang.S
                .of(context)
                .toTitle, provider)),
      ],
    );
  }

  Widget _cityField(BuildContext context,
      CountryProvider cp,
      City? city,
      Function(City) onSelected,
      String label,
      GroupBookingProvider provider,
      ) {
    return InputDecorator(
      decoration: kInputDecoration.copyWith(
        contentPadding: const EdgeInsets.only(left: 10.0),
        labelText: label,
        labelStyle: kTextStyle.copyWith(color: kTitleColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: ListTile(
        onTap: provider.isLoading ? null :() async {
          final response = await Navigator.pushNamed(
            context, AppRoutes.search,);

          if (response is City) onSelected(response);
        },
        title: Text(city?.cityCode != null ? '(${city!.cityCode})' : '---',
          style: kTextStyle.copyWith(
              color: kTitleColor, fontWeight: FontWeight.bold),),
        subtitle: Text(
          city != null ? '${city.city}, ${city.country}' : 'Select $label',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: kTextStyle.copyWith(color: kSubTitleColor),
        ),

      ),
    );
  }


  Widget _buildDateInput(GroupBookingProvider provider, BuildContext context) {
    return TextFormField(
      readOnly: true,
      keyboardType: TextInputType.name,
      cursorColor: kTitleColor,
      showCursor: false,
      textInputAction: TextInputAction.next,
      decoration: kInputDecoration.copyWith(
        labelText: lang.S
            .of(context)
            .dateTitle,
        labelStyle: kTextStyle.copyWith(color: kTitleColor),
        hintText: provider.departureDateTitle,
        hintStyle: kTextStyle.copyWith(color: kTitleColor),
        focusColor: kTitleColor,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const Icon(IconlyLight.calendar,
          color: kSubTitleColor,),
      ),
      onTap: provider.isLoading ? null : () async {
        final dt = await showDatePicker(
          context: context,
          initialDate:provider.selectedDate.isBefore(DateTime.now())
              ? DateTime.now()
              : provider.selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2040),
        );
        if (dt != null) {
          final isValid = provider.setDate(dt);
          if (!isValid) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: "Invalid Date",
                    descriptions: provider.validationMessage,
                    text: "OK",
                    titleColor: Colors.red,
                    img: 'images/dialog_error.png',
                    functionCall: () => Navigator.pop(context),
                  );
                });
          }
        }
      },
    );
  }

  Widget _buildReturnDateInput(GroupBookingProvider provider, BuildContext context) {
    return TextFormField(
      readOnly: true,
      keyboardType: TextInputType.name,
      cursorColor: kTitleColor,
      showCursor: false,
      textInputAction: TextInputAction.next,
      decoration: kInputDecoration.copyWith(
        labelText: lang.S.of(context).returnDate,
        labelStyle: kTextStyle.copyWith(color: kTitleColor),
        hintText: provider.returnDateTitle,
        hintStyle: kTextStyle.copyWith(color: kTitleColor),
        focusColor: kTitleColor,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const Icon(IconlyLight.calendar, color: kSubTitleColor),
      ),
      onTap: provider.isLoading ? null :  () async {
        final dt = await showDatePicker(
          context: context,
          initialDate: provider.returnDate ?? provider.selectedDate.add(const Duration(days: 1)),
          firstDate: provider.selectedDate,
          lastDate: DateTime(2040),
        );
        if (dt != null) {
          final isValid = provider.setReturnDate(dt);
          if (!isValid) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: "Invalid Return Date",
                  descriptions: provider.validationMessage,
                  text: "OK",
                  titleColor: Colors.red,
                  img: 'images/dialog_error.png',
                  functionCall: () => Navigator.pop(context),
                );
              },
            );
          }
        }
      },
    );
  }


  static Widget _textField(
      String label,
      String hint,
      TextEditingController controller,{
  TextInputType inputType = TextInputType.text,
}
      ) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: kInputDecoration.copyWith(
        labelText: label,
        hintText: hint,
        labelStyle: kTextStyle.copyWith(color: kTitleColor),
        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
        border: const OutlineInputBorder(),
      ),
    );
  }


  Widget _buildSubmitQuery(BuildContext context, GroupBookingProvider provider){
    return ButtonGlobal(
        buttontext: "Submit Query",
        buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor),
         onPressed: () async {
          final response = await provider.submitGroupBooking();

          if(response['status'] == 'success'){
            provider.resetForm();
            showDialog(
              context: context,
              builder: (_) => CustomDialogBox(
                title: "Success",
                titleColor: Colors.green,
                descriptions: response['message'] ?? "Query submitted successfully!",
                text: "OK",
                img: 'images/dialog_success.png',
                functionCall: () {
                  Navigator.pop(context); // Close dialog
                },
              ),
            );

          }else{
            final errorMessage = response['message'];
            final String combinedErrors;

            if (errorMessage is List) {
              combinedErrors = errorMessage.join("\n");
            } else if (errorMessage is String) {
              combinedErrors = errorMessage;
            } else {
              combinedErrors = "An unexpected error occurred.";
            }
            showDialog(
              context: context,
              builder: (_) => CustomDialogBox(
                title: "Submission Failed",
                titleColor: Colors.red,
                descriptions: combinedErrors,
                text: "OK",
                img: 'images/dialog_error.png',
                functionCall: () => Navigator.pop(context),
              ),
            );


          }
         }
    );
  }


}
