import 'package:flutter/material.dart';

const kPrimaryColor = /*Color(0xFFDE5D31)*/ Color(0xFFFC5119);
const kBlueColor = /*Color(0xFF1A0CF0)*/  Color(0xFF0265FB);
const kSubSubTitleColor=Color(0xffCAC2F5);
const kTitleColor = Color(0xFF030508);
const kSecondaryColor = Color(0xFFEDF0FF);
const kSubTitleColor = Color(0xFF6F7B8C);
const kLightNeutralColor = Color(0xFF96BCFF);
const kDarkWhite = Color(0xFFF9F9F9);
const kWhite = Color(0xFFFFFFFF);
const kBorderColorTextField = Color(0xFFE3E7EA);
const ratingBarColor = Color(0xFFFFB33E);
const kRedColor = Color(0xFF750000);

const kTextStyle =TextStyle(
  color: kTitleColor,
);

final kTextStyleBoldTitleColor = kTextStyle.copyWith(
  fontWeight: FontWeight.bold,
  color: kTitleColor,
);

const kTextStyleSubtitle = TextStyle(
  color: kSubTitleColor,
);


const kButtonDecoration = BoxDecoration(
  color: kPrimaryColor,
  borderRadius: BorderRadius.all(
    Radius.circular(40.0),
  ),
);

InputDecoration kInputDecoration = const InputDecoration(
  hintStyle: TextStyle(color: kSubTitleColor),
  labelStyle: TextStyle(color: kTitleColor),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(6.0),
    ),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(
      color: kBorderColorTextField,
    ),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

const String currencySign = '₹';

bool isReturn = false;
int selectedIndex = 0;

List<String> titleList = [
  'Saver',
  'Flexi Plus',
  'Super 6E',
];
String gValue = 'Saver';


