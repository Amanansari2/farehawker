import 'package:flightbooking/models/pricing_rules_model/pricing_response_model.dart';

class TravellerInfo {
  final String gender;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String? passportNumber;
  final DateTime? passportExpiry;
  final String type;

  List<Bagg>? selectedBagg = [];
  List<Meal>? selectedMeal = [];
  List<OtherService>? selectedOther = [];


  TravellerInfo({
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
     this.passportNumber,
     this.passportExpiry,
    required this.type,
    this.selectedBagg,
    this.selectedMeal,
    this.selectedOther,
  }){
    selectedBagg ??= [];
    selectedMeal ??= [];
    selectedOther ??= [];
  }
}

