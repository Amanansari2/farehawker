import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../models/group_booking_model.dart';
import '../../providers/group_booking_provider.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/custom_dialog.dart';
import '../search/search.dart';

class GroupBookingScreen extends StatefulWidget {
  const GroupBookingScreen({super.key});

  @override
  State<GroupBookingScreen> createState() => _GroupBookingScreenState();
}

class _GroupBookingScreenState extends State<GroupBookingScreen> with TickerProviderStateMixin {
  TabController? tabController;
  final TextEditingController adultController = TextEditingController();
  final TextEditingController childController = TextEditingController();
  final TextEditingController infantController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  String departureDateTitle = 'Departure Date';
  String returnDateTitle = 'Return Date';

  int selectedIndex = 0; //for One Way, 1 for Round Trip



  @override
  void initState() {

    super.initState();
    tabController = TabController(length: 2, vsync: this, );

  }

  // String firstName = '';
  // String lastName = '';
  // String email = '';
  // String phone = '';
  // List<Widget> flights = [];
  // List<Map<String, String>> travellers = [
  //
  // ];

  // List<String> genderList = ['Male', 'Female', 'Others'];
  //
  // String selectedGender = 'Male';
  //
  // int adultCount = 1;
  // int childCount = 0;
  // int infantCount = 0;
  // int flightNumber = 0;
  // bool showCounter = false;

  // String validationMessage = '';

  List<String> classList = [
    'Economy',
    'Business',
  ];
  String selectedClass = 'Economy';


  DropdownButton<String> getClass() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in classList) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(
        IconlyLight.arrowDown2,
        color: kSubTitleColor,
      ),
      items: dropDownItems,
      value: selectedClass,
      onChanged: (value) {
        setState(() {
          selectedClass = value!;
        });
      },
    );
  }

  //DateTimeRange? _selectedDateRange;



  DateTime selectedDate = DateTime.now();

  // void _showDepartureDate() async {
  //   final DateTimeRange? result = await showDateRangePicker(
  //     context: context,
  //     firstDate: selectedDate,
  //     lastDate: DateTime(2030, 12, 31),
  //     currentDate: DateTime.now(),
  //     saveText: 'Done',
  //   );
  //   if (result != null && result != _selectedDateRange) {
  //     setState(() {
  //       _selectedDateRange = result;
  //       returnDateTitle = _selectedDateRange.toString().substring(26, 36);
  //
  //       departureDateTitle = _selectedDateRange.toString().substring(0, 10);
  //     });
  //   }
  // }

  void _showDepartureDate1() async {
    final DateTime? result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030, 12, 31),
    );
    if (result != null) {
      setState(() {
        departureDateTitle = result.toString().substring(0, 10);
      });
    }
  }
  void _showReturnDate() async {
    final DateTime? result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030, 12, 31),
    );
    if (result != null) {
      setState(() {
        returnDateTitle = result.toString().substring(0, 10);
      });
    }
  }


  // void showEditTravelerDialog(BuildContext context, int index) {
  //   final travelersProvider = Provider.of<Travelers>(context, listen: false);
  //
  //   var traveler = travelersProvider.travellers[index];
  //
  //   String firstName = traveler['name']?.split(' ').first ?? '';
  //   String lastName = traveler['name']?.split(' ').last ?? '';
  //   String email = traveler['email'] ?? '';
  //   String phone = traveler['phone'] ?? '';
  //   String selectedGender = traveler['gender'] ?? '';
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topRight: Radius.circular(30.0),
  //         topLeft: Radius.circular(30.0),
  //       ),
  //     ),
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return  DraggableScrollableSheet(
  //               initialChildSize: 1.0,
  //               expand: true,
  //               maxChildSize: 1.0,
  //               minChildSize: 0.70,
  //               builder: (BuildContext context, ScrollController controller){
  //                 return SingleChildScrollView(
  //                   controller: controller,
  //                   child: Column(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(20),
  //                         child: Row(
  //                           children: [
  //                             Text("Edit Travellers Details",
  //                               style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
  //                             ),
  //                             const Spacer(),
  //                             GestureDetector(
  //                               onTap: (){
  //                                 setState ((){
  //                                   Navigator.pop(context);
  //                                 });
  //                               },
  //                               child: const Icon(
  //                                 FeatherIcons.x,
  //                                 color: kSubTitleColor,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                         width: context.width(),
  //                         decoration: const BoxDecoration(
  //                             color: kWhite,
  //                             borderRadius: BorderRadius.only(
  //                               topRight: Radius.circular(30),
  //                               topLeft: Radius.circular(30),
  //                             ),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: kDarkWhite,
  //                                 blurRadius: 7.0,
  //                                 spreadRadius: 2.0,
  //                                 offset: Offset(0, -2),
  //                               )
  //                             ]
  //                         ),
  //                         padding: const EdgeInsets.all(20),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               lang.S.of(context).selectGenderTitle,
  //                               style: kTextStyle.copyWith(color: kSubTitleColor),
  //                             ),
  //                             HorizontalList(
  //                                 physics: const NeverScrollableScrollPhysics(),
  //                                 itemCount: genderList.length,
  //                                 itemBuilder: (_, i){
  //                                   return Row(
  //                                     children: [
  //                                       Radio(
  //                                           value: genderList[i],
  //                                           groupValue: selectedGender,
  //                                           onChanged: (value){
  //                                             setState ((){
  //                                               selectedGender = value.toString();
  //                                             });
  //                                           }
  //                                       ),
  //                                       Text(
  //                                         genderList[i],
  //                                         style: kTextStyle.copyWith(
  //                                           color: kTitleColor,
  //                                           fontWeight: FontWeight.bold,
  //                                         ),
  //                                       )
  //                                     ],
  //                                   );
  //                                 }
  //                             ),
  //                             const SizedBox(height: 10,),
  //                             TextFormField(
  //                               keyboardType: TextInputType.text,
  //                               cursorColor: kTitleColor,
  //                               textInputAction: TextInputAction.next,
  //                               decoration: kInputDecoration.copyWith(
  //                                 labelText: lang.S.of(context).nameTitle,
  //                                 labelStyle: kTextStyle.copyWith(color: kTitleColor),
  //                                 hintText: lang.S.of(context).nameHint,
  //                                 hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
  //                                 focusColor: kTitleColor,
  //
  //                                 border: const OutlineInputBorder(),
  //                               ),
  //                               initialValue: firstName,
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   firstName = value;
  //
  //                                 });
  //                               },
  //                             ),
  //                             const SizedBox(height: 20,),
  //                             TextFormField(
  //                               keyboardType: TextInputType.text,
  //                               cursorColor: kTitleColor,
  //                               textInputAction: TextInputAction.next,
  //                               decoration: kInputDecoration.copyWith(
  //                                 labelText: lang.S.of(context).lastNameTitle,
  //                                 labelStyle: kTextStyle.copyWith(color: kTitleColor),
  //                                 hintText: lang.S.of(context).lastNameHint,
  //                                 hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
  //                                 focusColor: kTitleColor,
  //                                 border: const OutlineInputBorder(),
  //                               ),
  //                               initialValue: lastName,
  //                               onChanged: (value){
  //                                 setState((){
  //                                   lastName = value;
  //                                 });
  //
  //                               },
  //                             ),
  //                             const SizedBox(height: 20.0),
  //                             TextFormField(
  //                               keyboardType: TextInputType.emailAddress,
  //                               cursorColor: kTitleColor,
  //                               textInputAction: TextInputAction.next,
  //                               decoration: kInputDecoration.copyWith(
  //                                 labelText: lang.S.of(context).emailLabel,
  //                                 labelStyle: kTextStyle.copyWith(color: kTitleColor),
  //                                 hintText: lang.S.of(context).emailHint,
  //                                 hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
  //                                 focusColor: kTitleColor,
  //                                 border: const OutlineInputBorder(),
  //                               ),
  //                               initialValue: email,
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   email = value;
  //                                 });
  //
  //                               },
  //                             ),
  //                             const SizedBox(height: 20.0),
  //                             TextFormField(
  //                               keyboardType: TextInputType.phone,
  //                               cursorColor: kTitleColor,
  //                               textInputAction: TextInputAction.next,
  //                               decoration: kInputDecoration.copyWith(
  //                                 labelText: lang.S.of(context).phoneLabel,
  //                                 labelStyle: kTextStyle.copyWith(color: kTitleColor),
  //                                 hintText: lang.S.of(context).phoneHint,
  //                                 hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
  //                                 focusColor: kTitleColor,
  //                                 border: const OutlineInputBorder(),
  //                               ),
  //                               initialValue: phone,
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   phone = value;
  //                                 });
  //
  //                               },
  //                             ),
  //                             const SizedBox(height: 20.0),
  //                             ButtonGlobalWithoutIcon(
  //                               buttontext: 'Done',
  //                               buttonDecoration: kButtonDecoration.copyWith(
  //                                 color: kPrimaryColor,
  //                                 borderRadius: BorderRadius.circular(30.0),
  //                               ),
  //                               onPressed: () {
  //                                 FocusScope.of(context).unfocus();
  //
  //                                 final updatedTraveler = {
  //                                   'name': '$firstName $lastName',
  //                                   'gender': selectedGender,
  //                                   'email': email,
  //                                   'phone': phone,
  //                                 };
  //                                 travelersProvider.editTraveler(index, updatedTraveler);
  //
  //
  //                                 Navigator.pop(context);
  //
  //                               },
  //                               buttonTextColor: kWhite,
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 );
  //               }
  //           );
  //       });
  //     },
  //   );
  // }



  void _submitForm() async {

    String adultText = adultController.text;
    String emailText = emailController.text;
    String phoneText = phoneController.text;


    bool isValidAdultCount =
        (adultText.length == 2) || // Accept any two-digit number (including 01-09)
            (adultText.length == 3 && int.parse(adultText) <= 999); // Accept three-digit numbers (100-999)

    bool isValidEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailText);

    bool isValidPhone = RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phoneText);

    if (departureDateTitle == 'Departure Date') {



      showDialog(
          context: context,
          builder: (BuildContext context){
            return CustomDialogBox(
              title: "Failed",
              descriptions: "Please enter Departure date.",
              text: "Retry",
              img: "images/dialog_error.png",
              titleColor: Colors.red,
              functionCall: (){
                Navigator.of(context).pop();
              },
            );
          });

      return; // Exit the function if validation fails
    }


    if (selectedIndex== 1 && returnDateTitle == 'Return Date') {



      showDialog(
          context: context,
          builder: (BuildContext context){
            return CustomDialogBox(
              title: "Failed",
              descriptions: "Please enter Return date.",
              text: "Retry",
              img: "images/dialog_error.png",
              titleColor: Colors.red,
              functionCall: (){
                Navigator.of(context).pop();
              },
            );
          });

      return; // Exit the function if validation fails
    }


    if (adultText.isEmpty || !isValidAdultCount ) {



      showDialog(
          context: context,
          builder: (BuildContext context){
            return CustomDialogBox(
              title: "Failed",
              descriptions: "Please enter a valid two-digit number such as (01, 02, 03... 10, 11, 12, and it must not exceed 999).",
              text: "Retry",
              img: "images/dialog_error.png",
              titleColor: Colors.red,
              functionCall: (){
                Navigator.of(context).pop();
              },
            );
          });

      return; // Exit the function if validation fails
    }

    if (emailText.isEmpty || !isValidEmail ) {



      showDialog(
          context: context,
          builder: (BuildContext context){
            return CustomDialogBox(
              title: "Failed",
              descriptions: "Please enter your valid email.",
              text: "Retry",
              img: "images/dialog_error.png",
              titleColor: Colors.red,
              functionCall: (){
                Navigator.of(context).pop();
              },
            );
          });

      return; // Exit the function if validation fails
    }

    if (phoneText.isEmpty || !isValidPhone ) {



      showDialog(
          context: context,
          builder: (BuildContext context){
            return CustomDialogBox(
              title: "Failed",
              descriptions: "Please enter a valid phone number (10 to 15 digits).",
              text: "Retry",
              img: "images/dialog_error.png",
              titleColor: Colors.red,
              functionCall: (){
                Navigator.of(context).pop();
              },
            );
          });

      return; // Exit the function if validation fails
    }



    final int adultCount = int.parse(adultText) ;
    final int childCount = childController.text.isNotEmpty ? int.parse(childController.text) : 0;
    final int infantCount = infantController.text.isNotEmpty ? int.parse(infantController.text) : 0 ;





    final booking = GroupBooking(
      direction: selectedIndex + 1, // 1 for One Way, 2 for Round Trip
      groupBooking: 'group-booking.html', // Ensure this is set correctly
      origin: fromController.text,
      destination: toController.text,
      depDate: departureDateTitle,
      retDate: returnDateTitle,
      adult: adultCount.toString(),
      child: childCount.toString(),
      infant: infantCount.toString(),
      contactNumber: phoneController.text,
      contactEmail: emailController.text,
    );


    await Provider.of<GroupBookingController>(context, listen: false).submitForm(context, booking);
  }







  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: kBlueColor,
        iconTheme: const IconThemeData(color: kWhite),
        centerTitle: true,
        title:
    Text(
          lang.S.of(context).GroupBookingTitle,
          style: kTextStyle.copyWith(
            color: kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:
       Container(
         decoration: const BoxDecoration(
           color: kWhite,
           borderRadius: BorderRadius.only(
             topRight: Radius.circular(30),
             topLeft: Radius.circular(30),
           ),
         ),

         child: DefaultTabController(
           initialIndex: 0,
             length: 2,
             child: SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   Padding(
                       padding: const EdgeInsets.only(top: 1, right: 10, left: 10),
                     child: Material(
                       borderRadius: BorderRadius.circular(30),
                       elevation: 2,
                       shadowColor: kDarkWhite,
                       child: Container(
                         padding: const EdgeInsets.all(10),
                         decoration: BoxDecoration(
                           color: kWhite,
                           borderRadius: BorderRadius.circular(30.0),
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(30.0),
                                 color: const Color(0xFFEDF0FF),
                               ),
                               child: TabBar(
                                   labelStyle: kTextStyle.copyWith(color: Colors.white),
                                   unselectedLabelColor: kPrimaryColor,
                                   indicatorColor: kPrimaryColor,
                                   labelColor: kWhite,
                                   indicator: const BoxDecoration(
                                     borderRadius: BorderRadius.all(Radius.circular(20)),
                                     shape: BoxShape.rectangle,
                                     color: kBlueColor,
                                   ),
                                   indicatorSize: TabBarIndicatorSize.tab,
                                   onTap: (index) {
                                     setState(() {
                                       selectedIndex = index;
                                     });
                                   },

                                   tabs:[ Tab(
                                     text: lang.S.of(context).tab1,
                                   ),
                                 Tab(
                                   text: lang.S.of(context).tab2,
                                 ),
                              ]
                               ),
                             ),
                             const SizedBox(height: 30,),
                             Column(
                               children: [
                                 Stack(
                                   alignment: Alignment.center,
                                   children: [
                                     Row(
                                       children: [
                                         Expanded(
                                             child: SizedBox(
                                               height: 90,
                                             child: InputDecorator(
                                               decoration: kInputDecoration.copyWith(
                                                 contentPadding: const EdgeInsets.only(left: 10.0),
                                                 labelText: lang.S.of(context).fromTitle,
                                                 labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                 floatingLabelBehavior: FloatingLabelBehavior.always,
                                                 border: OutlineInputBorder(
                                                   borderRadius: BorderRadius.circular(8.0),
                                                 ),
                                               ),
                                               child: ListTile(
                                                 // onTap: ()=>const Search().launch(context),
                                                 title: Text(
                                                   '(DAC)',
                                                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                 ),
                                                 subtitle: Text(
                                                   'Dhaka, Bangladesh',
                                                   maxLines: 1,
                                                   overflow: TextOverflow.ellipsis,
                                                   style: kTextStyle.copyWith(color: kSubTitleColor),
                                                 ),
                                                 horizontalTitleGap: 0,
                                                 contentPadding: const EdgeInsets.only(left: 5.0),
                                                 minVerticalPadding: 0.0,
                                               ),
                                             ),
                                             ),
                                         ),
                                         const SizedBox(width: 10),
                                         Expanded(
                                           child: SizedBox(
                                             height: 90,
                                             child: InputDecorator(
                                               decoration: kInputDecoration.copyWith(
                                                 contentPadding: const EdgeInsets.only(left: 10.0),
                                                 labelText: lang.S.of(context).toTitle,
                                                 labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                 floatingLabelBehavior: FloatingLabelBehavior.always,
                                                 border: OutlineInputBorder(
                                                   borderRadius: BorderRadius.circular(8.0),
                                                 ),
                                               ),
                                               child: ListTile(

                                                 title: Text(
                                                   '(NYC)',
                                                   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                 ),
                                                 subtitle: Text(
                                                   'New Your, United State',
                                                   maxLines: 1,
                                                   overflow: TextOverflow.ellipsis,
                                                   style: kTextStyle.copyWith(color: kSubTitleColor),
                                                 ),
                                                 horizontalTitleGap: 0,
                                                 contentPadding: const EdgeInsets.only(left: 5.0),
                                                 minVerticalPadding: 0.0,
                                               ),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(bottom: 20.0),
                                       child: Container(
                                         decoration: BoxDecoration(
                                           shape: BoxShape.circle,
                                           color: kWhite,
                                           border: Border.all(
                                             color: kPrimaryColor.withOpacity(0.3),
                                           ),
                                         ),
                                         child: const Icon(
                                           Icons.swap_horiz_outlined,
                                           color: kPrimaryColor,
                                         ),
                                       ),
                                     ),

                                   ],
                                 ),
                                 TextFormField(
                                   readOnly: true,
                                   keyboardType: TextInputType.name,
                                   cursorColor: kTitleColor,
                                   showCursor: false,
                                   textInputAction: TextInputAction.next,
                                   decoration: kInputDecoration.copyWith(
                                     labelText: lang.S.of(context).dateTitle,
                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                     hintText: departureDateTitle,
                                     hintStyle: kTextStyle.copyWith(color: kTitleColor),
                                     focusColor: kTitleColor,
                                     border: const OutlineInputBorder(),
                                     floatingLabelBehavior: FloatingLabelBehavior.always,
                                     suffixIcon: GestureDetector(
                                       onTap: () {
                                         setState(() {
                                           _showDepartureDate1();
                                         });
                                       },
                                       child: const Icon(
                                         IconlyLight.calendar,
                                         color: kSubTitleColor,
                                       ),
                                     ),
                                   ),
                                 ),
                                 const SizedBox(height: 20.0).visible(selectedIndex == 1),
                                 TextFormField(
                                   readOnly: true,
                                   keyboardType: TextInputType.name,
                                   cursorColor: kTitleColor,
                                   showCursor: false,
                                   textInputAction: TextInputAction.next,
                                   decoration: kInputDecoration.copyWith(
                                     labelText: lang.S.of(context).returnDate,
                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                     hintText: returnDateTitle,
                                     hintStyle: kTextStyle.copyWith(color: kTitleColor),
                                     focusColor: kTitleColor,
                                     border: const OutlineInputBorder(),
                                     floatingLabelBehavior: FloatingLabelBehavior.always,
                                     suffixIcon: GestureDetector(
                                       onTap: () {
                                         setState(() {
                                           _showReturnDate();
                                           });
                                       },
                                       child: const Icon(
                                         IconlyLight.calendar,
                                         color: kSubTitleColor,
                                       ),
                                     ),
                                   ),
                                 ).visible(selectedIndex == 1),
                                 const SizedBox(height: 20.0),
                                 // TextFormField(
                                 //   readOnly: true,
                                 //   keyboardType: TextInputType.name,
                                 //   cursorColor: kTitleColor,
                                 //   showCursor: false,
                                 //   textInputAction: TextInputAction.next,
                                 //   decoration: kInputDecoration.copyWith(
                                 //     labelText: lang.S.of(context).travellerTitle,
                                 //     labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                 //     hintText: '$adultCount Adult,$childCount child,$infantCount Infants',
                                 //     hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                 //     border: const OutlineInputBorder(),
                                 //     floatingLabelBehavior: FloatingLabelBehavior.always,
                                 //     suffixIcon: GestureDetector(
                                 //       onTap: (() => showModalBottomSheet(
                                 //         shape: RoundedRectangleBorder(
                                 //           borderRadius: BorderRadius.circular(30.0),
                                 //         ),
                                 //         context: context,
                                 //         builder: (BuildContext context) {
                                 //           return StatefulBuilder(builder: (BuildContext context, setStated) {
                                 //             return Column(
                                 //               mainAxisSize: MainAxisSize.min,
                                 //               crossAxisAlignment: CrossAxisAlignment.start,
                                 //               children: [
                                 //                 Padding(
                                 //                   padding: const EdgeInsets.all(20.0),
                                 //                   child: Column(
                                 //                     crossAxisAlignment: CrossAxisAlignment.start,
                                 //                     children: [
                                 //                       Row(
                                 //                         children: [
                                 //                           Text(
                                 //                             lang.S.of(context).travellerTitle,
                                 //                             style: kTextStyle.copyWith(
                                 //                               color: kTitleColor,
                                 //                               fontSize: 18.0,
                                 //                               fontWeight: FontWeight.bold,
                                 //                             ),
                                 //                           ),
                                 //                           const Spacer(),
                                 //                           const Icon(FeatherIcons.x, size: 18.0, color: kTitleColor).onTap(
                                 //                                 () => finish(context),
                                 //                           ),
                                 //                         ],
                                 //                       ),
                                 //                       Text(
                                 //                         'Dhaka to New York, Thu 6 Jan 2023',
                                 //                         style: kTextStyle.copyWith(color: kSubTitleColor),
                                 //                       ),
                                 //                     ],
                                 //                   ),
                                 //                 ),
                                 //                 Container(
                                 //                   padding: const EdgeInsets.all(20.0),
                                 //                   decoration: const BoxDecoration(
                                 //                     borderRadius: BorderRadius.only(
                                 //                       topRight: Radius.circular(30.0),
                                 //                       topLeft: Radius.circular(30.0),
                                 //                     ),
                                 //                     color: kWhite,
                                 //                     boxShadow: [
                                 //                       BoxShadow(
                                 //                         color: kDarkWhite,
                                 //                         spreadRadius: 5.0,
                                 //                         blurRadius: 7.0,
                                 //                         offset: Offset(0, -5),
                                 //                       ),
                                 //                     ],
                                 //                   ),
                                 //                   child: Column(
                                 //                     children: [
                                 //                     //  Validation error message when total exceeds 9
                                 //                       if (validationMessage.isNotEmpty)
                                 //                         Padding(
                                 //                           padding: const EdgeInsets.only(bottom: 8.0),
                                 //                           child: Text(
                                 //                             validationMessage,
                                 //                             style: kTextStyle.copyWith(color: Colors.red),
                                 //                           ),
                                 //                         ),
                                 //                       Row(
                                 //                         mainAxisAlignment: MainAxisAlignment.start,
                                 //                         children: [
                                 //                           Column(
                                 //                             crossAxisAlignment: CrossAxisAlignment.start,
                                 //                             children: [
                                 //                               Text(
                                 //                                 lang.S.of(context).adults,
                                 //                                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                 //                               ),
                                 //                               Text(
                                 //                                 '12+ years',
                                 //                                 style: kTextStyle.copyWith(color: kSubTitleColor),
                                 //                               ),
                                 //                             ],
                                 //                           ),
                                 //                           const Spacer(),
                                 //                           Container(
                                 //                             padding: const EdgeInsets.all(
                                 //                               5.0,
                                 //                             ),
                                 //                             decoration: BoxDecoration(
                                 //                               shape: BoxShape.circle,
                                 //                               color: adultCount == 1 ? kPrimaryColor.withOpacity(0.2) : kPrimaryColor,
                                 //                             ),
                                 //                             child: const Icon(
                                 //                               FeatherIcons.minus,
                                 //                               color: Colors.white,
                                 //                               size: 24.0,
                                 //                             ).onTap(() {
                                 //                               setStated(() {
                                 //                                 adultCount > 1 ? adultCount-- : adultCount = 1;
                                 //                               });
                                 //                             }),
                                 //                           ),
                                 //                           const SizedBox(width: 10.0),
                                 //                           Text(
                                 //                             adultCount.toString(),
                                 //                           ),
                                 //                           const SizedBox(width: 10.0),
                                 //                           Container(
                                 //                             padding: const EdgeInsets.all(
                                 //                               5.0,
                                 //                             ),
                                 //                             decoration: const BoxDecoration(
                                 //                               shape: BoxShape.circle,
                                 //                               color: kPrimaryColor,
                                 //                             ),
                                 //                             child: const Icon(
                                 //                               FeatherIcons.plus,
                                 //                               color: Colors.white,
                                 //                               size: 24.0,
                                 //                             ).onTap(() {
                                 //                               setStated(() {
                                 //                                 adultCount++;
                                 //
                                 //                                 // if (adultCount + childCount + infantCount < 9) {
                                 //                                 //   adultCount++;
                                 //                                 //   validationMessage = '';
                                 //                                 // }else {
                                 //                                 //   validationMessage = 'Total number of passengers cannot exceed 9'; // <-- CHANGE: Set error message
                                 //                                 // }
                                 //                               });
                                 //                             }),
                                 //                           ),
                                 //                         ],
                                 //                       ),
                                 //                       const Divider(
                                 //                         thickness: 1.0,
                                 //                         color: kBorderColorTextField,
                                 //                       ),
                                 //                       const SizedBox(height: 15.0),
                                 //                       Row(
                                 //                         mainAxisAlignment: MainAxisAlignment.start,
                                 //                         children: [
                                 //                           Column(
                                 //                             crossAxisAlignment: CrossAxisAlignment.start,
                                 //                             children: [
                                 //                               Text(
                                 //                                 lang.S.of(context).child,
                                 //                                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                 //                               ),
                                 //                               Text(
                                 //                                 '2-12 years',
                                 //                                 style: kTextStyle.copyWith(color: kSubTitleColor),
                                 //                               ),
                                 //                             ],
                                 //                           ),
                                 //                           const Spacer(),
                                 //                           Container(
                                 //                             padding: const EdgeInsets.all(
                                 //                               5.0,
                                 //                             ),
                                 //                             decoration: BoxDecoration(
                                 //                               shape: BoxShape.circle,
                                 //                               color: childCount == 0 ? kPrimaryColor.withOpacity(0.2) : kPrimaryColor,
                                 //                             ),
                                 //                             child: const Icon(
                                 //                               FeatherIcons.minus,
                                 //                               color: Colors.white,
                                 //                               size: 24.0,
                                 //                             ).onTap(() {
                                 //                               setStated(() {
                                 //                                 childCount > 0 ? childCount-- : childCount = 0;
                                 //                               });
                                 //                             }),
                                 //                           ),
                                 //                           const SizedBox(width: 10.0),
                                 //                           Text(childCount.toString()),
                                 //                           const SizedBox(width: 10.0),
                                 //                           Container(
                                 //                             padding: const EdgeInsets.all(
                                 //                               5.0,
                                 //                             ),
                                 //                             decoration: const BoxDecoration(
                                 //                               shape: BoxShape.circle,
                                 //                               color: kPrimaryColor,
                                 //                             ),
                                 //                             child: const Icon(
                                 //                               FeatherIcons.plus,
                                 //                               color: Colors.white,
                                 //                               size: 24.0,
                                 //                             ).onTap(() {
                                 //                               setStated(() {
                                 //                                childCount++;
                                 //                               //   if (adultCount + childCount + infantCount < 9) {
                                 //                               //     childCount++;
                                 //                               //     validationMessage = '';
                                 //                               //
                                 //                               //   }else {
                                 //                               //     validationMessage = 'Total number of passengers cannot exceed 9'; // <-- CHANGE: Set error message
                                 //                               //   }
                                 //
                                 //                               });
                                 //                             }),
                                 //                           ),
                                 //                         ],
                                 //                       ),
                                 //                       const Divider(
                                 //                         thickness: 1.0,
                                 //                         color: kBorderColorTextField,
                                 //                       ),
                                 //                       const SizedBox(height: 15.0),
                                 //                       Row(
                                 //                         mainAxisAlignment: MainAxisAlignment.start,
                                 //                         children: [
                                 //                           Column(
                                 //                             crossAxisAlignment: CrossAxisAlignment.start,
                                 //                             children: [
                                 //                               Text(
                                 //                                 lang.S.of(context).infants,
                                 //                                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                 //                               ),
                                 //                               Text(
                                 //                                 'Under 2 Years',
                                 //                                 style: kTextStyle.copyWith(color: kSubTitleColor),
                                 //                               ),
                                 //                             ],
                                 //                           ),
                                 //                           const Spacer(),
                                 //                           Container(
                                 //                             padding: const EdgeInsets.all(
                                 //                               5.0,
                                 //                             ),
                                 //                             decoration: BoxDecoration(
                                 //                               shape: BoxShape.circle,
                                 //                               color: infantCount == 0 ? kPrimaryColor.withOpacity(0.2) : kPrimaryColor,
                                 //                             ),
                                 //                             child: const Icon(
                                 //                               FeatherIcons.minus,
                                 //                               color: Colors.white,
                                 //                               size: 24.0,
                                 //                             ).onTap(() {
                                 //                               setStated(() {
                                 //                                 infantCount > 0 ? infantCount-- : infantCount = 0;
                                 //                               });
                                 //                             }),
                                 //                           ),
                                 //                           const SizedBox(width: 10.0),
                                 //                           Text(infantCount.toString()),
                                 //                           const SizedBox(width: 10.0),
                                 //                           Container(
                                 //                             padding: const EdgeInsets.all(
                                 //                               5.0,
                                 //                             ),
                                 //                             decoration: const BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor),
                                 //                             child: const Icon(FeatherIcons.plus, color: Colors.white, size: 24.0).onTap(() {
                                 //                               setStated(() {
                                 //                                 //infantCount++;
                                 //                                 if (infantCount < adultCount) {
                                 //                                   infantCount++;
                                 //                                   validationMessage = ''; // Clear any previous validation message
                                 //                                 } else {
                                 //                                   validationMessage = 'Infants cannot exceed the number of adults.';
                                 //                                 }
                                 //
                                 //                               });
                                 //                             }),
                                 //                           ),
                                 //                         ],
                                 //                       ),
                                 //                       const Divider(
                                 //                         thickness: 1.0,
                                 //                         color: kBorderColorTextField,
                                 //                       ),
                                 //                       const SizedBox(
                                 //                         height: 20.0,
                                 //                       ),
                                 //                       ButtonGlobal(
                                 //                           buttontext: lang.S.of(context).done,
                                 //                           buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor),
                                 //                           onPressed: () {
                                 //                             setState(() {
                                 //                               // finish(context);
                                 //                               // childCount = childCount;
                                 //                               // adultCount = adultCount;
                                 //                               // infantCount = infantCount;
                                 //
                                 //                               if (infantCount > adultCount) {
                                 //                                 validationMessage = 'Infants cannot exceed the number of adults.';
                                 //                               }
                                 //
                                 //                               else {
                                 //                                 finish(context);  // Close the modal
                                 //                               }
                                 //
                                 //                             });
                                 //                           }),
                                 //                     ],
                                 //                   ),
                                 //                 ),
                                 //               ],
                                 //             );
                                 //           });
                                 //         },
                                 //       )),
                                 //       child: const Icon(
                                 //         IconlyLight.arrowDown2,
                                 //         color: kSubTitleColor,
                                 //       ),
                                 //     ),
                                 //   ),
                                 // ),

                                 FormField(
                                   builder: (FormFieldState<dynamic> field) {
                                     return InputDecorator(
                                       decoration: kInputDecoration.copyWith(
                                         enabledBorder: const OutlineInputBorder(
                                           borderRadius: BorderRadius.all(
                                             Radius.circular(8.0),
                                           ),
                                           borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                         ),
                                         contentPadding: const EdgeInsets.all(7.0),
                                         floatingLabelBehavior: FloatingLabelBehavior.always,
                                         labelText: lang.S.of(context).classTitle,
                                         labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                       ),
                                       child: DropdownButtonHideUnderline(child: getClass()),
                                     );
                                   },
                                 ),



                                 const SizedBox(height: 20.0),

                                 Container(
                                   width: context.width(),
                                   padding: const EdgeInsets.all(10),
                                   decoration: BoxDecoration(
                                       color: kWhite,
                                       border: Border.all(
                                         color: kSecondaryColor,
                                       ),
                                       borderRadius: BorderRadius.circular(10),
                                       boxShadow: const [
                                         BoxShadow(
                                           color: kDarkWhite,
                                           spreadRadius: 2.0,
                                           blurRadius: 7.0,
                                           offset: Offset(0, 2),
                                         )
                                       ]
                                   ),

                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       const Text(
                                         'No. Of Passengers',
                                         style: TextStyle(
                                           fontSize: 18.0,
                                           fontWeight: FontWeight.bold,
                                         ),
                                       ),
                                       const SizedBox(height: 10.0),
                                       Row(
                                         children: [
                                           Expanded(
                                             child: TextFormField(
                                               controller: adultController,
                                               keyboardType: TextInputType.phone,
                                               cursorColor: kTitleColor,
                                               textInputAction: TextInputAction.next,
                                               decoration: kInputDecoration.copyWith(
                                                 labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                 hintText: lang.S.of(context).adultHint,
                                                 hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                                 focusColor: kTitleColor,
                                                 border: const OutlineInputBorder(),

                                                 errorMaxLines: 10
                                               ),
                                               inputFormatters: [
                                                 FilteringTextInputFormatter.digitsOnly,
                                                 LengthLimitingTextInputFormatter(3), // Limit to 3 digits
                                               ],


                                             ),
                                           ),
                                           const SizedBox(width: 10.0),
                                           Expanded(
                                             child: TextFormField(
                                               controller: childController,
                                               keyboardType: TextInputType.phone,
                                               cursorColor: kTitleColor,
                                               textInputAction: TextInputAction.next,
                                               decoration: kInputDecoration.copyWith(
                                                 labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                 hintText: lang.S.of(context).childHint,
                                                 hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                                 focusColor: kTitleColor,

                                                 border: const OutlineInputBorder(),
                                               ),
                                               inputFormatters: [
                                                 FilteringTextInputFormatter.digitsOnly,
                                                 LengthLimitingTextInputFormatter(3), // Limit to 3 digits
                                               ],

                                             ),
                                           ),
                                           const SizedBox(width: 10.0),
                                           Expanded(
                                             child: TextFormField(
                                               controller: infantController,
                                               keyboardType: TextInputType.phone,
                                               cursorColor: kTitleColor,
                                               textInputAction: TextInputAction.next,
                                               decoration: kInputDecoration.copyWith(
                                                 labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                 hintText: lang.S.of(context).infantHint,
                                                 hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                                 focusColor: kTitleColor,

                                                 border: const OutlineInputBorder(),
                                               ),
                                               inputFormatters: [
                                                 FilteringTextInputFormatter.digitsOnly,
                                                 LengthLimitingTextInputFormatter(3), // Limit to 3 digits
                                               ],

                                             ),
                                           ),
                                         ],
                                       ),
                                     ],
                                   ),
                                 ),


                                 const SizedBox(height: 20.0),

                                 TextFormField(
                                   controller: contactNameController,
                                   keyboardType: TextInputType.text,
                                   cursorColor: kTitleColor,
                                   textInputAction: TextInputAction.next,
                                   decoration: kInputDecoration.copyWith(
                                     labelText: lang.S.of(context).nameLabel,
                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                     hintText: lang.S.of(context).contactPersonHint,
                                     hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                     focusColor: kTitleColor,
                                     border: const OutlineInputBorder(),
                                   ),
                                 ),
                                 const SizedBox(height: 20.0),

                                 TextFormField(
                                   controller: emailController,
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
                                 const SizedBox(height: 20.0),
                                 TextFormField(
                                   controller: phoneController,
                                   keyboardType: TextInputType.phone,
                                   cursorColor: kTitleColor,
                                   textInputAction: TextInputAction.next,
                                   decoration: kInputDecoration.copyWith(
                                     labelText: lang.S.of(context).phoneLabel,
                                     labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                     hintText: lang.S.of(context).phoneHint,
                                     hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                     focusColor: kTitleColor,
                                     border: const OutlineInputBorder(),
                                   ),
                                 ),

 //                                Container(
 //                                  width: context.width(),
 //                                  padding: const EdgeInsets.all(10),
 //                                  decoration: BoxDecoration(
 //                                    color: kWhite,
 //                                    border: Border.all(
 //                                      color: kSecondaryColor,
 //                                    ),
 //                                    borderRadius: BorderRadius.circular(10),
 //                                    boxShadow: const [
 //                                      BoxShadow(
 //                                        color: kDarkWhite,
 //                                        spreadRadius: 2.0,
 //                                        blurRadius: 7.0,
 //                                        offset: Offset(0, 2),
 //                                      )
 //                                    ]
 //                                  ),
 //
 //
 //                                  child: Column(
 //                                    crossAxisAlignment: CrossAxisAlignment.start ,
 //                                    children: [
 //                                      Text(
 //                                        'Traveller Details',
 //                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),),
 //
 //                                     const SizedBox(height: 10,),
 //
 //                                      // Column(
 //                                      //   children: travelersProvider.travellers.map((traveler) {
 //                                      //     return Container(
 //                                      //       decoration: BoxDecoration(
 //                                      //         borderRadius: BorderRadius.circular(8),
 //                                      //         color: kWhite,
 //                                      //         boxShadow: const [
 //                                      //           BoxShadow(
 //                                      //             color: kBorderColorTextField,
 //                                      //             blurRadius: 7,
 //                                      //             spreadRadius: 2,
 //                                      //             offset: Offset(0, 2),
 //                                      //           ),
 //                                      //         ],
 //                                      //       ),
 //                                      //       child: ListTile(
 //                                      //         contentPadding: const EdgeInsets.only(left: 10, right: 10),
 //                                      //         horizontalTitleGap: 0,
 //                                      //         title: Text(
 //                                      //           traveler['name']?? 'No Name',
 //                                      //           style: kTextStyle.copyWith(color: kTitleColor),
 //                                      //         ),
 //                                      //         subtitle: Column(
 //                                      //           crossAxisAlignment: CrossAxisAlignment.start,
 //                                      //           children: [
 //                                      //             Text(
 //                                      //               'Gender: ${traveler['gender']?? 'Unknown'}',
 //                                      //               style: kTextStyle.copyWith(color: kSubTitleColor),
 //                                      //             ),
 //                                      //             Text(
 //                                      //               'Email: ${traveler['email']?? "No Email"}',
 //                                      //               style: kTextStyle.copyWith(color: kSubTitleColor),
 //                                      //             ),
 //                                      //             Text(
 //                                      //               'Phone: ${traveler['phone']?? "No Phone"}',
 //                                      //               style: kTextStyle.copyWith(color: kSubTitleColor),
 //                                      //             ),
 //                                      //           ],
 //                                      //         ),
 //                                      //         // Text(
 //                                      //         //   traveler['gender']!,
 //                                      //         //   style: kTextStyle.copyWith(color: kSubTitleColor),
 //                                      //         // ),
 //                                      //         trailing:
 //                                      //         GestureDetector(
 //                                      //           onTap: (){
 //                                      //             _showTravelerModal(context, traveler: traveler, index: index);
 //                                      //           },
 //                                      //           child: const Icon(
 //                                      //             IconlyBold.edit,
 //                                      //             color: kPrimaryColor,
 //                                      //           ),
 //                                      //         ),
 //                                      //       ),
 //                                      //     );
 //                                      //   }).toList(),
 //                                      // ),
 //
 //                                      Column(
 //                                        children: travelersProvider.travellers.asMap().entries.map((entry) {
 //                                          int index = entry.key; // Get the index
 //                                          var traveler = entry.value; // Get the traveler data
 //
 //                                          return Container(
 //                                            decoration: BoxDecoration(
 //                                              borderRadius: BorderRadius.circular(8),
 //                                              color: kWhite,
 //                                              boxShadow: const [
 //                                                BoxShadow(
 //                                                  color: kBorderColorTextField,
 //                                                  blurRadius: 7,
 //                                                  spreadRadius: 2,
 //                                                  offset: Offset(0, 2),
 //                                                ),
 //                                              ],
 //                                            ),
 //                                            child: ListTile(
 //                                              contentPadding: const EdgeInsets.only(left: 10, right: 10),
 //                                              horizontalTitleGap: 0,
 //                                              title: Text.rich(
 //                                                TextSpan(
 //                                                  children: [
 //                                                    TextSpan(
 //                                                      text: 'Name: ',
 //                                                      style: kTextStyle.copyWith(
 //                                                        color: kTitleColor,
 //                                                        fontWeight: FontWeight.bold, // Make 'Gender:' bold
 //                                                      ),
 //                                                    ),
 //                                                    TextSpan(
 //                                                      text: traveler['name'] ?? 'Unknown',
 //                                                      style: kTextStyle.copyWith(
 //                                                        color: kSubTitleColor,
 //                                                        fontWeight: FontWeight.normal, // Normal weight for gender value
 //                                                      ),
 //                                                    ),
 //                                                  ],
 //                                                ),
 //                                              ),
 //                                              subtitle: Column(
 //                                                crossAxisAlignment: CrossAxisAlignment.start,
 //                                                children: [
 //                                                  Text.rich(
 //                                                    TextSpan(
 //                                                      children: [
 //                                                        TextSpan(
 //                                                          text: 'Gender: ',
 //                                                          style: kTextStyle.copyWith(
 //                                                            color: kTitleColor,
 //                                                            fontWeight: FontWeight.bold, // Make 'Gender:' bold
 //                                                          ),
 //                                                        ),
 //                                                        TextSpan(
 //                                                          text: traveler['gender'] ?? 'Unknown',
 //                                                          style: kTextStyle.copyWith(
 //                                                            color: kSubTitleColor,
 //                                                            fontWeight: FontWeight.normal, // Normal weight for gender value
 //                                                          ),
 //                                                        ),
 //                                                      ],
 //                                                    ),
 //                                                  ),
 //                                                  Text.rich(
 //                                                    TextSpan(
 //                                                      children: [
 //                                                        TextSpan(
 //                                                          text: 'Email: ',
 //                                                          style: kTextStyle.copyWith(
 //                                                            color: kTitleColor,
 //                                                            fontWeight: FontWeight.bold, // Make 'Gender:' bold
 //                                                          ),
 //                                                        ),
 //                                                        TextSpan(
 //                                                          text: traveler['email'] ?? 'Unknown',
 //                                                          style: kTextStyle.copyWith(
 //                                                            color: kSubTitleColor,
 //                                                            fontWeight: FontWeight.normal, // Normal weight for gender value
 //                                                          ),
 //                                                        ),
 //                                                      ],
 //                                                    ),
 //                                                  ),
 //                                                  Text.rich(
 //                                                    TextSpan(
 //                                                      children: [
 //                                                        TextSpan(
 //                                                          text: 'Phone: ',
 //                                                          style: kTextStyle.copyWith(
 //                                                            color: kTitleColor,
 //                                                            fontWeight: FontWeight.bold, // Make 'Gender:' bold
 //                                                          ),
 //                                                        ),
 //                                                        TextSpan(
 //                                                          text: traveler['phone'] ?? 'Unknown',
 //                                                          style: kTextStyle.copyWith(
 //                                                            color: kSubTitleColor,
 //                                                            fontWeight: FontWeight.normal, // Normal weight for gender value
 //                                                          ),
 //                                                        ),
 //                                                      ],
 //                                                    ),
 //                                                  ),
 //                                                ],
 //                                              ),
 //                                              trailing: Row(
 //                                                mainAxisSize: MainAxisSize.min,
 //                                                children: [
 //                                                  GestureDetector(
 //                                                    onTap: (){
 //                                                      showEditTravelerDialog(context, index);
 //                                                    },
 //                                                    child: const Icon(
 //                                                      IconlyBold.edit,
 //                                                      color: kPrimaryColor,
 //                                                    ),
 //                                                  ),
 //                                                  const SizedBox(width: 20,),
 //                                                  GestureDetector(
 //                                                    onTap: (){
 //                                                     showDialog(
 //                                                         context: context,
 //                                                         builder: (BuildContext context){
 //                                                           return AlertDialog(
 //                                                             shape: RoundedRectangleBorder(
 //                                                               borderRadius: BorderRadius.circular(8),
 //                                                             ),
 //                                                             title: const Text("Confirm Delete", style: TextStyle(
 //                                                               fontSize: 18,
 //                                                             ),textAlign: TextAlign.center,),
 //                                                             content: const Text('Are you sure want to delete this traveller'),
 //                                                             actions: <Widget>[
 //                                                               Row(
 //                                                                 mainAxisAlignment: MainAxisAlignment.center,
 //
 //                                                                 children: [
 //                                                                   // ElevatedButton(
 //                                                                   //     onPressed: (){
 //                                                                   //       Navigator.of(context).pop();
 //                                                                   //     },
 //                                                                   //     child: const Text('No'),),
 //                                                                   Container(
 //                                                                     height: 40,
 //                                                                     width: 101,
 //                                                                     decoration: BoxDecoration(
 //                                                                         borderRadius: BorderRadius.circular(40),
 //                                                                         border: Border.all(
 //                                                                           color: Colors.red,
 //                                                                           width: 1.0,
 //                                                                         )),
 //                                                                     child: ElevatedButton(
 //                                                                         onPressed: () {
 //                                                                           Navigator.of(context).pop();
 //                                                                         },
 //                                                                         style: ElevatedButton.styleFrom(
 //                                                                             elevation: 0.0,
 //                                                                             backgroundColor: kWhite,
 //                                                                             shape: RoundedRectangleBorder(
 //                                                                               borderRadius: BorderRadius.circular(40),
 //                                                                             )),
 //                                                                         child: const Text(
 //                                                                           'No',
 //                                                                           style: TextStyle(
 //                                                                             color: Colors.red,
 //                                                                           ),
 //                                                                         )),
 //                                                                   ),
 //
 //                                                                   const SizedBox(width: 25,),
 //
 //                                                                   Container(
 //                                                                     height: 40,
 //                                                                     width: 101,
 //                                                                     decoration: BoxDecoration(
 //                                                                         borderRadius: BorderRadius.circular(40),
 //                                                                         border: Border.all(
 //                                                                           color: Colors.red,
 //                                                                           width: 1.0,
 //                                                                         )),
 //                                                                     child: ElevatedButton(
 //                                                                         onPressed: () {
 //                                                                           travelersProvider.deleteTraveler(index); // Delete traveler if 'Yes' is pressed
 //                                                                           Navigator.of(context).pop();
 //                                                                         },
 //                                                                         style: ElevatedButton.styleFrom(
 //                                                                             elevation: 0.0,
 //                                                                             backgroundColor: kWhite,
 //                                                                             shape: RoundedRectangleBorder(
 //                                                                               borderRadius: BorderRadius.circular(40),
 //                                                                             )),
 //                                                                         child: const Text(
 //                                                                           'Yes',
 //                                                                           style: TextStyle(
 //                                                                             color: Colors.red,
 //                                                                           ),
 //                                                                         )),
 //                                                                   ),
 //
 //
 //                                                                   // ElevatedButton(
 //                                                                   //   onPressed: () {
 //                                                                   //     travelersProvider.deleteTraveler(index); // Delete traveler if 'Yes' is pressed
 //                                                                   //     Navigator.of(context).pop(); // Close the dialog after deletion
 //                                                                   //   },
 //                                                                   //   child: const Text("Yes", style: TextStyle(color: Colors.red)),
 //                                                                   // ),
 //                                                                 ],
 //                                                               ),
 //
 //                                                             ],
 //                                                           );
 //                                                         }
 //                                                     );
 //
 //                                                    },
 //                                                    child: const FaIcon(
 //                                                      FontAwesomeIcons.trashCan,
 //                                                      color: Colors.red,
 //                                                    ),
 //                                                  ),
 //                                                ],
 //                                              ),
 //
 //                                            ),
 //                                          );
 //                                        }).toList(),
 //                                      ),
 //
 //
 //                                      const SizedBox(height: 10,),
 //                                      ButtonGlobalWithIcon(
 //                                          buttontext: "Add Travellers",
 //                                        buttonTextColor: kPrimaryColor,
 //                                        buttonIcon: FeatherIcons.plus,
 //                                          buttonDecoration: kButtonDecoration.copyWith(
 //                                            color: kWhite,
 //                                            borderRadius: BorderRadius.circular(8),
 //                                            border: Border.all(
 //                                              color: kPrimaryColor.withOpacity(0.5),
 //                                            )
 //                                          ),
 //                                        onPressed: (){
 //                                            setState(() {
 //                                              showModalBottomSheet(
 //                                                  isScrollControlled: true,
 //                                                  shape: const RoundedRectangleBorder(
 //                                                    borderRadius: BorderRadius.only(
 //                                                      topRight: Radius.circular(30.0),
 //                                                      topLeft: Radius.circular(30.0),
 //                                                    ),
 //                                                  ),
 //                                                  context: context,
 //                                                  builder: (BuildContext context){
 //
 //                                                    return StatefulBuilder(builder: ( context, setState){
 //                                                      return
 //                                                      DraggableScrollableSheet(
 //                                                          initialChildSize: 1.0,
 //                                                          expand: true,
 //                                                          maxChildSize: 1.0,
 //                                                          minChildSize: 0.70,
 //                                                          builder: (BuildContext context, ScrollController controller){
 //                                                            return SingleChildScrollView(
 //                                                              controller: controller,
 //                                                              child: Column(
 //                                                                children: [
 //                                                                  Padding(
 //                                                                      padding: const EdgeInsets.all(20),
 //                                                                  child: Row(
 //                                                                    children: [
 //                                                                      Text("Add Travellers Details",
 //                                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
 //                                                                      ),
 //                                                                      const Spacer(),
 //                                                                      GestureDetector(
 //                                                                        onTap: (){
 //                                                                          setState ((){
 //                                                                            Navigator.pop(context);
 //                                                                          });
 //                                                                        },
 //                                                                        child: const Icon(
 //                                                                          FeatherIcons.x,
 //                                                                          color: kSubTitleColor,
 //                                                                      ),
 //                                                                      )
 //                                                                    ],
 //                                                                  ),
 //                                                                  ),
 //                                                                  Container(
 //                                                                    width: context.width(),
 //                                                                    decoration: const BoxDecoration(
 //                                                                      color: kWhite,
 //                                                                      borderRadius: BorderRadius.only(
 //                                                                      topRight: Radius.circular(30),
 //                                                                      topLeft: Radius.circular(30),
 //                                                                      ),
 //                                                                      boxShadow: [
 //                                                                        BoxShadow(
 //                                                                          color: kDarkWhite,
 //                                                                          blurRadius: 7.0,
 //                                                                          spreadRadius: 2.0,
 //                                                                          offset: Offset(0, -2),
 //                                                                        )
 //                                                                      ]
 //                                                                    ),
 //                                                                    padding: const EdgeInsets.all(20),
 //                                                                    child: Column(
 //                                                                      crossAxisAlignment: CrossAxisAlignment.start,
 //                                                                      children: [
 //                                                                        Text(
 //                                                                          lang.S.of(context).selectGenderTitle,
 //                                                                          style: kTextStyle.copyWith(color: kSubTitleColor),
 //                                                                        ),
 //                                                                        HorizontalList(
 //                                                                          physics: const NeverScrollableScrollPhysics(),
 //                                                                            itemCount: genderList.length,
 //                                                                            itemBuilder: (_, i){
 //                                                                            return Row(
 //                                                                              children: [
 //                                                                                Radio(
 //                                                                                    value: genderList[i],
 //                                                                                    groupValue: selectedGender,
 //                                                                                    onChanged: (value){
 //                                                                                      setState ((){
 //                                                                                        selectedGender = value.toString();
 //                                                                                      });
 //                                                                                    }
 //                                                                                ),
 //                                                                                Text(
 //                                                                                  genderList[i],
 //                                                                                  style: kTextStyle.copyWith(
 //                                                                                    color: kTitleColor,
 //                                                                                    fontWeight: FontWeight.bold,
 //                                                                                  ),
 //                                                                                )
 //                                                                              ],
 //                                                                            );
 //                                                                            }
 //                                                                        ),
 //                                                                        const SizedBox(height: 10,),
 //                                                                        TextFormField(
 //                                                                          keyboardType: TextInputType.text,
 //                                                                          cursorColor: kTitleColor,
 //                                                                          textInputAction: TextInputAction.next,
 //                                                                          decoration: kInputDecoration.copyWith(
 //                                                                          labelText: lang.S.of(context).nameTitle,
 //                                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
 //                                                                          hintText: lang.S.of(context).nameHint,
 //                                                                          hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
 //                                                                          focusColor: kTitleColor,
 //                                                                          border: const OutlineInputBorder(),
 //                                                                          ),
 //                                                                          onChanged: (value) {
 //                                                                            setState(() {
 //                                                                              firstName = value;
 //
 //                                                                            });
 //                                                                          },
 //                                                                          ),
 //                                                                        const SizedBox(height: 20,),
 //                                                                        TextFormField(
 //                                                                          keyboardType: TextInputType.text,
 //                                                                          cursorColor: kTitleColor,
 //                                                                          textInputAction: TextInputAction.next,
 //                                                                          decoration: kInputDecoration.copyWith(
 //                                                                            labelText: lang.S.of(context).lastNameTitle,
 //                                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
 //                                                                            hintText: lang.S.of(context).lastNameHint,
 //                                                                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
 //                                                                            focusColor: kTitleColor,
 //                                                                            border: const OutlineInputBorder(),
 //                                                                          ),
 //                                                                          onChanged: (value){
 //                                                                            setState((){
 //                                                                              lastName = value;
 //                                                                            });
 //
 //                                                                          },
 //                                                                        ),
 //                                                                        const SizedBox(height: 20.0),
 //                                                                        TextFormField(
 //                                                                          keyboardType: TextInputType.emailAddress,
 //                                                                          cursorColor: kTitleColor,
 //                                                                          textInputAction: TextInputAction.next,
 //                                                                          decoration: kInputDecoration.copyWith(
 //                                                                            labelText: lang.S.of(context).emailLabel,
 //                                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
 //                                                                            hintText: lang.S.of(context).emailHint,
 //                                                                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
 //                                                                            focusColor: kTitleColor,
 //                                                                            border: const OutlineInputBorder(),
 //                                                                          ),
 //                                                                               onChanged: (value) {
 //                                                                                 setState(() {
 //                                                                                  email = value;
 //                                                                                       });
 //
 //                                                                               },
 //                                                                        ),
 //                                                                        const SizedBox(height: 20.0),
 //                                                                        TextFormField(
 //                                                                          keyboardType: TextInputType.phone,
 //                                                                          cursorColor: kTitleColor,
 //                                                                          textInputAction: TextInputAction.next,
 //                                                                          decoration: kInputDecoration.copyWith(
 //                                                                            labelText: lang.S.of(context).phoneLabel,
 //                                                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
 //                                                                            hintText: lang.S.of(context).phoneHint,
 //                                                                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
 //                                                                            focusColor: kTitleColor,
 //                                                                            border: const OutlineInputBorder(),
 //                                                                          ),
 //                                                                          onChanged: (value) {
 //                                                                            setState(() {
 //                                                                              phone = value;
 //                                                                            });
 //
 //                                                                          },
 //                                                                        ),
 //                                                                        const SizedBox(height: 20.0),
 //                                                                        ButtonGlobalWithoutIcon(
 //                                                                          buttontext: 'Done',
 //                                                                          buttonDecoration: kButtonDecoration.copyWith(
 //                                                                            color: kPrimaryColor,
 //                                                                            borderRadius: BorderRadius.circular(30.0),
 //                                                                          ),
 //                                                                          onPressed: () {
 //                                                                            FocusScope.of(context).unfocus();
 //
 //                                                                            final newTraveler = {
 //                                                                              'name': '$firstName $lastName',
 //                                                                              'gender': selectedGender,
 //                                                                              'email': email,
 //                                                                              'phone': phone,
 //                                                                            };
 //                                                                            travelersProvider.addTraveler(newTraveler);
 //
 //                                                                            // setState((){
 //                                                                            //     travellers.add(
 //                                                                            //         {
 //                                                                            //           'name' : '$firstName $lastName',
 //                                                                            //           'gender' : selectedGender,
 //                                                                            //           'email' : email,
 //                                                                            //           'phone' : phone,
 //                                                                            //         });
 //                                                                            //
 //                                                                            //     // print("All Travelers after adding: $travellers");
 //                                                                            //   });
 //                                                                              Navigator.pop(context);
 //
 //                                                                          },
 //                                                                          buttonTextColor: kWhite,
 //                                                                        ),
 //
 //
 //
 //
 //
 //
 //                                                                      ],
 //                                                                    ),
 //                                                                  )
 //                                                                ],
 //                                                              ),
 //                                                            );
 //                                                          }
 // );
 //                                                    }
 //                                                    );
 //                                                  }
 //                                              );
 //                                            });
 //                                        },
 //                                         )
 //                                    ],
 //                                  ),
 //
 //                                ) ,
                                 const SizedBox(height: 20.0),
                                 Center(
                                   child: ButtonGlobalWithoutIcon(
                                     width: 150,
                                     buttontext: lang.S.of(context).submitquery,
                                     buttonDecoration: kButtonDecoration.copyWith(
                                       color: kPrimaryColor,
                                       borderRadius: BorderRadius.circular(30.0),
                                     ),
                                     onPressed: _submitForm,
                                     buttonTextColor: kWhite,
                                   ),
                                 ),
                               ],
                             )
                           ],
                         ),
                       ),
                     ),
                   ),
                   const SizedBox(height: 20.0),
                   Container(
                     width: context.width(),
                     decoration: const  BoxDecoration(color: kDarkWhite),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                             padding: const EdgeInsets.only(left: 15, right: 15),
                         child: Text(
                           lang.S.of(context).recentSearch,
                           style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),

                         ),
                         ),
                         HorizontalList(
                             padding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 10.0),
                             itemCount: 10, itemBuilder: (_, i){
                            return Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: const Color(0xFFEDF0FF),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Dhaka to New York',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kTextStyle.copyWith(color: kBlueColor, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    '17 Jan - 18 Jan ',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kTextStyle.copyWith(color: kPrimaryColor),
                                  ),
                                ],
                              ),
                            );
                         })
                       ],
                     ),
                   )
                 ],
               ),
             )),
       )
    );
  }
}
