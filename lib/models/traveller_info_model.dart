class TravellerInfo {
  final String gender;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;

  TravellerInfo({
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });
}

class PassportInfo{
  final String passportNumber;
  final DateTime passportExpiry;

PassportInfo({
   required this.passportNumber,
  required this.passportExpiry
});
}