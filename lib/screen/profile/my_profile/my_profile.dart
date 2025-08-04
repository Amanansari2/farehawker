import 'package:country_code_picker/country_code_picker.dart';
import 'package:flightbooking/providers/update_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../providers/login_provider.dart';
import '../../../widgets/constant.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final box = GetStorage();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final updateProvider = Provider.of<UpdateProfileProvider>(context, listen: false);

      if (loginProvider.user != null) {
        updateProvider.prefillProfileData(loginProvider.user!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final updateProfileProvider = Provider.of<UpdateProfileProvider>(context);
    return Scaffold(
      backgroundColor: kWhite,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        height: 90,
        decoration: const BoxDecoration(
          color: kWhite,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 0.0,
                  backgroundColor: kPrimaryColor,
                ),
                onPressed: () {
                 updateProfileProvider.submitUpdateSignUpForm(context);
                },
                child: Text(
                  'Update Profile',
                  style: kTextStyle.copyWith(color: kWhite),
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBlueColor,
        iconTheme: const IconThemeData(color: kWhite),
        title: Text(
          'My Profile',
          style: kTextStyle.copyWith(
            color: kWhite,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildInformationSection(loginProvider, context),
            const Divider(),
            _buildUpdateForm(updateProfileProvider, context),
          ],
        ),
      ),
    );
  }

  Widget _buildInformationSection(LoginProvider loginProvider, BuildContext context) {
    final user = loginProvider.user;
    final userName = user != null && user['name'] != null ? user['name'] : 'Guest';
    final userLastName = user != null && user['lname'] != null ? user['lname'] : '';
    final email = user != null && user['email'] != null ? user['email'] : 'Unknown';
    return  Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 25,
          ),

          Text(
            "$userName $userLastName ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            email,
            style: kTextStyle.copyWith(fontSize: 14, color: kSubTitleColor),
          ),
          const SizedBox(
            height: 20,
          ),

        ],
      ),
    );
  }

  Widget _buildUpdateForm(UpdateProfileProvider updateProfileProvider, BuildContext context){
    return  Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      decoration:  const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),

        color: kWhite,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Update Your Account",
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const Divider().paddingOnly(right: 110, left: 110),

          const SizedBox(height: 20.0),
          _buildTextField("First Name", "First Name", TextInputType.name, updateProfileProvider.updateFirstNameController),
          const SizedBox(height: 20.0),
          _buildTextField("Last Name", "Last Name", TextInputType.name, updateProfileProvider.updateLastNameController),
          const SizedBox(height: 20.0),
          _buildTextField("Email", "Email", TextInputType.emailAddress, updateProfileProvider.updateEmailController),
          const SizedBox(height: 20.0),
          _buildPhoneField(updateProfileProvider),
          const SizedBox(height: 20.0),
          _buildGenderField(updateProfileProvider),
          const SizedBox(height: 20.0),
          _buildDateOfBirthField(updateProfileProvider, context),
          const SizedBox(height: 20.0),
          _buildTextField("Passport Number", "Passport Number", TextInputType.text, updateProfileProvider.updatePassportNumberController),
          const SizedBox(height: 20.0),
          _buildPassportExpiryField(updateProfileProvider, context),
          const SizedBox(height: 20.0),
          const SizedBox(height: 20.0),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _buildTextField(String labelText, String hintText, TextInputType keyboardType, TextEditingController controller){
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: kInputDecoration.copyWith(
        labelText: labelText,
        labelStyle: kTextStyle.copyWith(color: kTitleColor),
        hintText: hintText,
        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
        focusColor: kTitleColor,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPhoneField(UpdateProfileProvider provider) {
    return TextFormField(
      controller: provider.updatePhoneController,
      keyboardType: TextInputType.phone,
      cursorColor: kTitleColor,
      textInputAction: TextInputAction.next,
      decoration: kInputDecoration.copyWith(
          hintText: 'Phone number',
          hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
          focusColor: kTitleColor,
          border: const OutlineInputBorder(),
          prefixIcon: const CountryCodePicker(
            padding: EdgeInsets.zero,
            onChanged: print,
            initialSelection: 'IN',
            showFlag: true,
            showDropDownButton: true,
            alignLeft: false,
          )
      ),
    );
  }





  Widget _buildPassportExpiryField(UpdateProfileProvider provider, BuildContext context) {
    return GestureDetector(
      onTap: () {
        provider.updateSelectExpiryDate(context);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: provider.updateFormattedPassportExpiryDate,
          ),
          decoration: kInputDecoration.copyWith(
              labelText: 'Passport Expiry Date',
              hintText: 'Select Expiry Date',
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.calendar_month_outlined)
          ),
        ),
      ),
    );
  }

  Widget _buildGenderField(UpdateProfileProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: kTextStyle.copyWith(
            color: kTitleColor,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 10,),
        Row(
          children:
          provider.updateGenderOptions.entries.map((entry) {
            return Row(
              children: [
                Radio<String>(
                  value: entry.key,
                  groupValue: provider.updateSelectedGender,
                  onChanged: (value) {
                    provider.setUpdateGender(value!);
                  },
                  activeColor: kPrimaryColor,
                ),
                Text(entry.value, style: kTextStyle.copyWith(color: kSubTitleColor)),
              ],
            );
          }).toList(),

        )

      ],
    );
  }


  Widget _buildDateOfBirthField(UpdateProfileProvider provider, BuildContext context) {
    return GestureDetector(
      onTap: () {
        provider.selectUpdateDateOfBirth(context); // Open calendar when tapped
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: provider.updateFormattedDateOfBirth,
          ),
          decoration: kInputDecoration.copyWith(
            labelText: 'Date of Birth',
            hintText: 'Select Date of Birth',
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }


}
