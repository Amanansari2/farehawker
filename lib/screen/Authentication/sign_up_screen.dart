import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sign_up_provider.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import 'login_screen.dart';




class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
      child: Consumer<SignUpProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                color: kBlueColor,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60,),
                  _buildLogoSection(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20.0),
                          _buildSignUpForm(provider, context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        },
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: Container(
        height: 70,
        width: 78,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/logo/TTT1.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(SignUpProvider provider, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10.0),
          Text(
            "Register Your Account",
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 40.0),
          _buildTextField("First Name", "First Name", TextInputType.name, provider.firstNameController),
          const SizedBox(height: 20.0),
          _buildTextField("Last Name", "Last Name", TextInputType.name, provider.lastNameController),
          const SizedBox(height: 20.0),
          _buildTextField("Email", "Email", TextInputType.emailAddress, provider.emailController),
          const SizedBox(height: 20.0),
          _buildPhoneField(provider),
          const SizedBox(height: 20.0),
          _buildGenderField(provider),
          const SizedBox(height: 20.0),
          _buildDateOfBirthField(provider, context),
          const SizedBox(height: 20.0),
          _buildTextField("Passport Number", "Passport Number", TextInputType.text, provider.passportNumberController),
          const SizedBox(height: 20.0),
          _buildPassportExpiryField(provider, context),
          const SizedBox(height: 20.0),
          _buildPasswordField(provider),
          const SizedBox(height: 20.0),
          _buildConfirmPasswordField(provider),
          const SizedBox(height: 20.0),
          ButtonGlobalWithoutIcon(
            buttontext: "Sign Up",
            buttonDecoration: kButtonDecoration.copyWith(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
               provider.submitSignUpForm(context);
            },
            buttonTextColor: kWhite,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String labelText, String hintText, TextInputType keyboardType, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: kTitleColor,
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

  Widget _buildPhoneField(SignUpProvider provider) {
    return TextFormField(
      controller: provider.phoneController,
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

  Widget _buildPasswordField(SignUpProvider provider) {
    return TextFormField(
      controller: provider.passwordController,
      obscureText: provider.hidePassword,
      decoration: kInputDecoration.copyWith(
        labelText: "Password",
        suffixIcon: IconButton(
          onPressed: provider.togglePasswordVisibility,
          icon: Icon(
            provider.hidePassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }

  Widget _buildDateOfBirthField(SignUpProvider provider, BuildContext context) {
    return GestureDetector(
      onTap: () {
        provider.selectDateOfBirth(context); // Open calendar when tapped
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: provider.formattedDateOfBirth,
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

  Widget _buildConfirmPasswordField(SignUpProvider provider) {
    return TextFormField(
      controller: provider.confirmPasswordController,
      obscureText: provider.hideConfirmPassword,
      decoration: kInputDecoration.copyWith(
        labelText: "Confirm Password",
        suffixIcon: IconButton(
          onPressed: provider.toggleConfirmPasswordVisibility,
          icon: Icon(
            provider.hideConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }

  Widget _buildPassportExpiryField(SignUpProvider provider, BuildContext context) {
    return GestureDetector(
      onTap: () {
        provider.selectExpiryDate(context);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: provider.formattedPassportExpiryDate,
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

  Widget _buildGenderField(SignUpProvider provider) {
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
            provider.genderOptions.entries.map((entry) {
              return Row(
                children: [
                  Radio<String>(
                    value: entry.key,
                    groupValue: provider.selectedGender,
                    onChanged: (value) {
                      provider.setGender(value!);
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


  Widget _buildBottomNavigationBar() {
    return SizedBox(
      height: 50,
      child: Container(
        decoration: const BoxDecoration(color: kWhite),
        child: GestureDetector(
          onTap: () => const LogIn(),
          child: Center(
            child: RichText(
              text: TextSpan(
                text: 'Already have an account? ',
                style: kTextStyle.copyWith(color: kSubTitleColor),
                children: [
                  TextSpan(
                    text: 'Login',
                    style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
