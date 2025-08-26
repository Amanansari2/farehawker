import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/providers/search_flight_provider.dart';
import 'package:flightbooking/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:provider/provider.dart';

import '../../data.dart';
import '../../models/country_list_model.dart';
import '../../models/search_result_arguments.dart';
import '../../providers/country_provider.dart';
import '../../providers/filter_provider.dart';
import '../../providers/login_provider.dart';
import '../../routes/route_generator.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/loading.dart';
import '../search/search_result.dart';


/*
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // TabController? tabController;
  City? selectedFromCityOneWay;
  City? selectedToCityOneWay;





  @override
  void initState() {
    super.initState();
    // tabController = TabController(length: 4, vsync: this);
  }


  int adultCount = 1;
  int childCount = 0;
  int infantCount = 0;
  // int flightNumber = 0;
  // bool showCounter = false;

  String validationMessage = '';




  String departureDateTitle = 'Departure Date';
  String returnDateTitle = 'Return Date';

  DateTime selectedDate = DateTime.now();



  void _showDepartureDate1() async {
    final DateTime? result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040, 12, 31),
    );
    if (result != null) {
      if(result.isBefore(DateTime.now().subtract(const Duration(days: 1)))){
        showDialog(
            context: context,
            builder: (context) => CustomDialogBox(
              title: 'Invalid date',
              descriptions: 'You cannot select a past date',
              text: 'Okay',
              titleColor: kRedColor,
              img: 'images/dialog_error.png',
              functionCall: () => Navigator.of(context).pop(),
            )
        );
      }else{
      setState(() {
        selectedDate = result;
        departureDateTitle = result.toString().substring(0, 10);
      });
    }
    }
  }



  String get selectedRouteInfo{
    final fromCity = selectedFromCityOneWay?.city ?? 'From';
    final toCity = selectedToCityOneWay?.city?? "To";
    final formattedDate = '${selectedDate.day.toString().padLeft(2,'0')} '
                            '${_monthName(selectedDate.month)} '
                            '${selectedDate.year}';

    final weekDay = _weekDay(selectedDate.weekday);

    return '$fromCity to $toCity, $weekDay $formattedDate';
  }

  String _monthName(int month){
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  String _weekDay(int weekDay){
    const weekDays = [
      '', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
    return weekDays[weekDay];
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
       top: false,
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: kDarkWhite,
          body:
          Column(

            //alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        height: 190,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                          ),
                          image: DecorationImage(image: AssetImage('images/bg.png'), fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.only(top: 20),
                              leading: GestureDetector(
                                onTap: (){
                                 Navigator.pushNamed(context, AppRoutes.profile);
                                },
                                child: Container(
                                  height: 44,
                                  width: 44,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage('images/profile1.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  GestureDetector(
                              onTap: (){
                               Navigator.pushNamed(context, AppRoutes.profile);
                              },
                                    child: Text(
                                      lang.S.of(context).welcome,
                                      style: kTextStyle.copyWith(color: kWhite, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Test User',
                                style: kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold),
                              ),
                              trailing: GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, AppRoutes.notification);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: Border.all(color: kWhite),
                                  ),
                                  child:  const Icon(
                                    FeatherIcons.bell,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                            ),
                          //  const SizedBox(height: 10),
                            Text(
                              lang.S.of(context).bookFlightTitle,
                              style: kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold, fontSize: 25.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10),
                        child: Material(
                          borderRadius: BorderRadius.circular(30.0),
                          elevation: 1,
                          shadowColor: kDarkWhite,
                          child: Container(
                            padding: const EdgeInsets.all(6.0),
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
                                    indicator:
                                     const BoxDecoration(
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
                                    tabs: [
                                      Tab(
                                        text: lang.S.of(context).tab1,
                                      ),
                                      Tab(
                                        text: lang.S.of(context).tab2,
                                      ),

                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Consumer<CountryProvider>(
                                                builder: (context, provider, _) {
                                                  return SizedBox(
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
                                                        onTap: () async {
                                                          final result = await Navigator.pushNamed(
                                                            context,
                                                            AppRoutes.search,
                                                            arguments: provider.countries,
                                                          );
                                                          if (result != null && result is City) {
                                                            setState(() {
                                                              selectedFromCityOneWay = result;
                                                            });
                                                          }
                                                        },
                                                        title: Text(
                                                          selectedFromCityOneWay != null ? '(${selectedFromCityOneWay!.cityCode})' : '(DEL)',
                                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                        ),
                                                        subtitle: Text(
                                                          selectedFromCityOneWay != null
                                                          ? '${selectedFromCityOneWay!.city}, ${selectedFromCityOneWay!.country}'
                                                          :'Delhi, India',
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: kTextStyle.copyWith(color: kSubTitleColor),
                                                        ),
                                                        horizontalTitleGap: 0,
                                                        contentPadding: const EdgeInsets.only(left: 5.0),
                                                        minVerticalPadding: 0.0,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Consumer<CountryProvider>(
                                                builder: (context, provider, _) {
                                                  return SizedBox(
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
                                                         onTap: () async {
                                                           final result = await Navigator.pushNamed(
                                                             context,
                                                             AppRoutes.search,
                                                             arguments: provider.countries,
                                                           );
                                                           if (result != null && result is City) {
                                                             setState(() {
                                                               selectedToCityOneWay = result;
                                                             });
                                                           }
                                                         },
                                                        title: Text(
                                                          selectedToCityOneWay != null ? '(${selectedToCityOneWay!.cityCode})' : '(Bom)',
                                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                        ),
                                                        subtitle: Text(
                                                          selectedToCityOneWay != null
                                                              ? '${selectedToCityOneWay!.city}, ${selectedToCityOneWay!.country}'
                                                              :'Mumbai, India',
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: kTextStyle.copyWith(color: kSubTitleColor),
                                                        ),
                                                        horizontalTitleGap: 0,
                                                        contentPadding: const EdgeInsets.only(left: 5.0),
                                                        minVerticalPadding: 0.0,
                                                      ),
                                                    ),
                                                  );
                                                }
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
                                          // onTap: () {
                                          //   setState(() {
                                          //     _showDepartureDate();
                                          //     isReturn == true;
                                          //   });
                                          // },
                                          child: const Icon(
                                            IconlyLight.calendar,
                                            color: kSubTitleColor,
                                          ),
                                        ),
                                      ),
                                    ).visible(selectedIndex == 1),
                                    const SizedBox(height: 20.0),
                                    TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.name,
                                      cursorColor: kTitleColor,
                                      showCursor: false,
                                      textInputAction: TextInputAction.next,
                                      decoration: kInputDecoration.copyWith(
                                        labelText: lang.S.of(context).travellerTitle,
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                        hintText: '$adultCount Adult,$childCount child,$infantCount Infants',
                                        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                        border: const OutlineInputBorder(),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        suffixIcon: GestureDetector(
                                          onTap: (() => showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30.0),
                                                ),
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(builder: (BuildContext context, setStated) {
                                                    return Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(20.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    lang.S.of(context).travellerTitle,
                                                                    style: kTextStyle.copyWith(
                                                                      color: kTitleColor,
                                                                      fontSize: 18.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  const Spacer(),
                                                                  const Icon(FeatherIcons.x, size: 18.0, color: kTitleColor).onTap(
                                                                    () => finish(context),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                              selectedRouteInfo,
                                                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.all(15.0),
                                                          decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              topRight: Radius.circular(30.0),
                                                              topLeft: Radius.circular(30.0),
                                                            ),
                                                            color: kWhite,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: kDarkWhite,
                                                                spreadRadius: 5.0,
                                                                blurRadius: 7.0,
                                                                offset: Offset(0, -5),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              if (validationMessage.isNotEmpty)
                                                                Padding(
                                                                  padding: const EdgeInsets.all(0),
                                                                  child: Text(
                                                                    validationMessage,
                                                                    style: kTextStyle.copyWith(color: Colors.red),
                                                                  ),
                                                                ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        lang.S.of(context).adults,
                                                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        '12+ years',
                                                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Spacer(),
                                                                  Container(
                                                                    padding: const EdgeInsets.all(
                                                                      5.0,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: adultCount == 1 ? kPrimaryColor.withOpacity(0.2) : kPrimaryColor,
                                                                    ),
                                                                    child: const Icon(
                                                                      FeatherIcons.minus,
                                                                      color: Colors.white,
                                                                      size: 24.0,
                                                                    ).onTap(() {
                                                                      setStated(() {
                                                                        adultCount > 1 ? adultCount-- : adultCount = 1;
                                                                      });
                                                                    }),
                                                                  ),
                                                                  const SizedBox(width: 10.0),
                                                                  Text(
                                                                    adultCount.toString(),
                                                                  ),
                                                                  const SizedBox(width: 10.0),
                                                                  Container(
                                                                    padding: const EdgeInsets.all(
                                                                      5.0,
                                                                    ),
                                                                    decoration: const BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: kPrimaryColor,
                                                                    ),
                                                                    child: const Icon(
                                                                      FeatherIcons.plus,
                                                                      color: Colors.white,
                                                                      size: 24.0,
                                                                    ).onTap(() {
                                                                      setStated(() {
                                                                      //  adultCount++;
                                                                        if (adultCount + childCount + infantCount < 9) {
                                                                          adultCount++;
                                                                          validationMessage = '';
                                                                        }else {
                                                                          validationMessage = 'Total number of passengers cannot exceed 9. Please go to Group Booking.';
                                                                        }
                                                                      });
                                                                    }),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Divider(
                                                                thickness: 1.0,
                                                                color: kBorderColorTextField,
                                                              ),
                                                              const SizedBox(height: 15.0),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        lang.S.of(context).child,
                                                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        '2-12 years',
                                                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Spacer(),
                                                                  Container(
                                                                    padding: const EdgeInsets.all(
                                                                      5.0,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: childCount == 0 ? kPrimaryColor.withOpacity(0.2) : kPrimaryColor,
                                                                    ),
                                                                    child: const Icon(
                                                                      FeatherIcons.minus,
                                                                      color: Colors.white,
                                                                      size: 24.0,
                                                                    ).onTap(() {
                                                                      setStated(() {
                                                                        childCount > 0 ? childCount-- : childCount = 0;
                                                                      });
                                                                    }),
                                                                  ),
                                                                  const SizedBox(width: 10.0),
                                                                  Text(childCount.toString()),
                                                                  const SizedBox(width: 10.0),
                                                                  Container(
                                                                    padding: const EdgeInsets.all(
                                                                      5.0,
                                                                    ),
                                                                    decoration: const BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: kPrimaryColor,
                                                                    ),
                                                                    child: const Icon(
                                                                      FeatherIcons.plus,
                                                                      color: Colors.white,
                                                                      size: 24.0,
                                                                    ).onTap(() {
                                                                      setStated(() {
                                                                       // childCount++;
                                                                        if (adultCount + childCount + infantCount < 9) {
                                                                          childCount++;
                                                                          validationMessage = '';

                                                                        }else {
                                                                          validationMessage = 'Total number of passengers cannot exceed 9. Please go to Group Booking.'; // <-- CHANGE: Set error message
                                                                        }

                                                                      });
                                                                    }),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Divider(
                                                                thickness: 1.0,
                                                                color: kBorderColorTextField,
                                                              ),
                                                              const SizedBox(height: 15.0),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        lang.S.of(context).infants,
                                                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        'Under 2 Years',
                                                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Spacer(),
                                                                  Container(
                                                                    padding: const EdgeInsets.all(
                                                                      5.0,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: infantCount == 0 ? kPrimaryColor.withOpacity(0.2) : kPrimaryColor,
                                                                    ),
                                                                    child: const Icon(
                                                                      FeatherIcons.minus,
                                                                      color: Colors.white,
                                                                      size: 24.0,
                                                                    ).onTap(() {
                                                                      setStated(() {
                                                                        infantCount > 0 ? infantCount-- : infantCount = 0;
                                                                      });
                                                                    }),
                                                                  ),
                                                                  const SizedBox(width: 10.0),
                                                                  Text(infantCount.toString()),
                                                                  const SizedBox(width: 10.0),
                                                                  Container(
                                                                    padding: const EdgeInsets.all(
                                                                      5.0,
                                                                    ),
                                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor),
                                                                    child: const Icon(FeatherIcons.plus, color: Colors.white, size: 24.0).onTap(() {
                                                                      setStated(() {
                                                                      //  infantCount++;
                                                                        if (infantCount >= adultCount) {
                                                                          validationMessage = 'Each adult can only bring 1 infant';
                                                                        } else if (adultCount + childCount + infantCount >= 9) {
                                                                          validationMessage =
                                                                          'Total number of passengers cannot exceed 9. Please go to Group Booking.';
                                                                        } else {
                                                                          infantCount++;
                                                                          validationMessage = '';
                                                                        }
                                                                      });
                                                                    }),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Divider(
                                                                thickness: 1.0,
                                                                color: kBorderColorTextField,
                                                              ),
                                                              const SizedBox(
                                                                height: 20.0,
                                                              ),
                                                              ButtonGlobal(
                                                                  buttontext: lang.S.of(context).done,
                                                                  buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor),
                                                                  onPressed: () {
                                                                    setState(() {


                                                                      if (adultCount + childCount + infantCount > 9) {
                                                                        validationMessage = 'Total number of passengers cannot exceed 9. Please go to Group Booking.';
                                                                      }

                                                                      else if (infantCount > adultCount) {
                                                                        validationMessage = 'Each adult can only bring 1 infant.';
                                                                      }

                                                                      else {
                                                                        validationMessage = '';
                                                                        finish(context);
                                                                      }

                                                                    });
                                                                  }),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                                },
                                              )),
                                          child: const Icon(
                                            IconlyLight.arrowDown2,
                                            color: kSubTitleColor,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10.0),
                                    Center(
                                      child: ButtonGlobalWithoutIcon(
                                        width: 150,
                                        buttontext: lang.S.of(context).searchFlight,
                                        buttonDecoration: kButtonDecoration.copyWith(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () {
                                          const SearchResult().launch(context);
                                        },
                                        buttonTextColor: kWhite,
                                      ),
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),







///////////////////////////////------------------------------------recent Search -------------------------------------------------------
                      Column(
                        children: [
                          Container(
                            //width: context.width(),
                            width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height,
                            decoration: const BoxDecoration(color: kDarkWhite),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: Text(
                                    lang.S.of(context).recentSearch,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                HorizontalList(
                                  padding: const EdgeInsets.only(left: 10.0, top: 15.0, ),
                                  itemCount: 10,
                                  itemBuilder: (_, i) {
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
                                  },
                                ),
                                const SizedBox(height: 10.0),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: Text(
                                    lang.S.of(context).flightOfferTitle,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                HorizontalList(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 15.0,
                                    bottom: 15.0,
                                    right: 10.0,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: 10,
                                  itemBuilder: (_, i) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        color: const Color(0xFFEDF0FF),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 120,
                                            width: context.width() / 1.2,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.0),
                                              color: kWhite,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 120,
                                                  width: 100,
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(8.0),
                                                      bottomLeft: Radius.circular(8.0),
                                                    ),
                                                    image: DecorationImage(
                                                      image: AssetImage('images/offer1.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Dhaka',
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                          ),
                                                          const SizedBox(width: 10.0),
                                                          const Icon(
                                                            Icons.flight_land,
                                                            color: kSubTitleColor,
                                                          ),
                                                          const SizedBox(width: 10.0),
                                                          Text(
                                                            'New York',
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      Container(
                                                        height: 1.0,
                                                        width: 120,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kBorderColorTextField),
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      SizedBox(
                                                        width: 180,
                                                        child: Text(
                                                          'Lorem ipsum dolor sit am et consectetur adipiscing elit, sed do eiusmod',
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: kTextStyle.copyWith(color: kSubTitleColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                           ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                        ],
                      )


                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}

*/






class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final box = GetStorage();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SearchFlightProvider>();
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
    final provider = context.watch<SearchFlightProvider>();
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
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(30.0),
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
                              const SizedBox(height: 20),
                              _buildFromToInput(provider, context),
                              const SizedBox(height: 20),
                              _buildDateInput(provider, context),

                              if (provider.selectedTripIndex == 1) ...[
                                const SizedBox(height: 20),
                                _buildReturnDateInput(provider, context),
                              ],
                              const SizedBox(height: 20),
                              _buildPassengerField(provider, context),
                              const SizedBox(height: 20),
                              Center(child: _buildSearchButton(
                                  context, provider)),

                              const SizedBox(height: 50),
                              // GestureDetector(
                              //   onTap: (){
                              //     Navigator.push(context, MaterialPageRoute(builder: (_) => const TestShimmerScreen()));
                              //   },
                              //   child: const Text("Testing Shimmer ", style: TextStyle(fontSize: 25),),
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
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

  Widget _buildFromToTabs(SearchFlightProvider provider, BuildContext ctx) {
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

  Widget _buildFromToInput(SearchFlightProvider provider,
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
      SearchFlightProvider provider,
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

  Widget _buildDateInput(SearchFlightProvider provider, BuildContext context) {
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

  Widget _buildReturnDateInput(SearchFlightProvider provider, BuildContext context) {
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



  Widget _buildPassengerField(SearchFlightProvider provider,
      BuildContext context) {
    String passengerSummary = '';
    if (provider.adultCount > 0) {
      passengerSummary += '${provider.adultCount} Adult${provider.adultCount > 1 ? 's' : ''}';
    }
    if (provider.childCount > 0) {
      if (passengerSummary.isNotEmpty) passengerSummary += ', ';
      passengerSummary += '${provider.childCount} Child${provider.childCount > 1 ? 'ren' : ''}';
    }
    if (provider.infantCount > 0) {
      if (passengerSummary.isNotEmpty) passengerSummary += ', ';
      passengerSummary += '${provider.infantCount} Infant${provider.infantCount > 1 ? 's' : ''}';
    }
    if (passengerSummary.isEmpty) {
      passengerSummary = 'Select Travellers';
    }
    return TextFormField(
      readOnly: true,
      keyboardType: TextInputType.name,
      cursorColor: kTitleColor,
      showCursor: false,
      textInputAction: TextInputAction.next,
      decoration: kInputDecoration.copyWith(
        labelText: lang.S
            .of(context)
            .travellerTitle,
        labelStyle: kTextStyle.copyWith(color: kTitleColor),
        hintText: passengerSummary,
        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const Icon(Icons.person),
      ),
      onTap:  provider.isLoading ? null : () => _showPassengerSheet(context, provider),
    );
  }

  void _showPassengerSheet(BuildContext context, SearchFlightProvider prov) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          Consumer<SearchFlightProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(provider.routeInfo, style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    if (provider.validationMessage.isNotEmpty)
                      Text(provider.validationMessage,
                          style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 20),
                    _buildCounterRow('Adults', provider.adultCount,
                            () => provider.changePassengerCount(adults: -1),
                            () => provider.changePassengerCount(adults: 1)),
                    const SizedBox(height: 10),
                    _buildCounterRow('Children', provider.childCount,
                            () => provider.changePassengerCount(children: -1),
                            () => provider.changePassengerCount(children: 1)),
                    const SizedBox(height: 10),
                    _buildCounterRow('Infants', provider.infantCount,
                            () => provider.changePassengerCount(infants: -1),
                            () => provider.changePassengerCount(infants: 1)),
                    const SizedBox(height: 20),
                    ButtonGlobal(
                      buttontext: lang.S
                          .of(context)
                          .done,
                      buttonDecoration: kButtonDecoration.copyWith(
                          color: kPrimaryColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildCounterRow(String label, int count, VoidCallback onDec,
      VoidCallback onInc) {
    return Row(
      children: [
        Text(label, style: kTextStyle.copyWith(
            color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 16)),
        const Spacer(),
        Container(
            padding: const EdgeInsets.all(2.0,),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryColor,),
            child: IconButton(icon: const Icon(
              FeatherIcons.minus, color: Colors.white, size: 24.0,),
                onPressed: onDec)),

        const SizedBox(width: 10.0),

        Text('$count', style: kTextStyle.copyWith(
            color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18),),

        const SizedBox(width: 10.0),

        Container(
            padding: const EdgeInsets.all(2.0,),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryColor,),
            child: IconButton(icon: const Icon(
              FeatherIcons.plus, color: Colors.white, size: 24.0,),
                onPressed: onInc)),
      ],
    );
  }

  Widget _buildSearchButton(BuildContext context,
      SearchFlightProvider provider) {
    return provider.isLoading
        ? const CircularProgressIndicator()
        : ButtonGlobal(
      buttontext: lang.S
          .of(context)
          .searchFlight,
      buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor),
      onPressed: () async {
        bool success = false;

        if(provider.selectedTripIndex == 0){
          final filterProvider = context.read<FilterProvider>();
          final countryProvider = context.read<CountryProvider>();
          filterProvider.resetFilters();
          success = await provider.searchFlight(filterProvider: filterProvider, countryProvider: countryProvider);
        }else{
          final filterProvider = context.read<FilterProvider>();
          final countryProvider = context.read<CountryProvider>();
          filterProvider.resetFilters();
          success = await provider.searchRoundTripFlight(initialLoad: true, filterProvider: filterProvider, countryProvider: countryProvider);
        }

        if (!success && provider.validationMessage.isNotEmpty) {
          showDialog(
            context: context,
            builder: (_) =>
                CustomDialogBox(
                  title: 'Field Required',
                  descriptions: provider.validationMessage,
                  text: 'OK',
                  titleColor: kRedColor,
                  img: 'images/dialog_error.png',
                  functionCall: () => Navigator.of(context).pop(),
                ),
          );
        } else if (provider.error != null) {

          showDialog(
            context: context,
            builder: (_) =>
                CustomDialogBox(
                  title: 'Error',
                  descriptions: provider.error,
                  text: 'Retry',
                  titleColor: kRedColor,
                  img: 'images/dialog_error.png',
                  functionCall: () => Navigator.of(context).pop(),
                ),
          );
        } else {
         if (provider.selectedTripIndex == 0 && provider.onwardFlights.isNotEmpty) {
            Navigator.pushNamed(context, AppRoutes.searchResult,);
          } else if(
         provider.selectedTripIndex == 1 && (provider.onwardFlights.isNotEmpty || provider.returnFlights.isNotEmpty)){
           Navigator.pushNamed(context, AppRoutes.searchRoundTripResult);
         }
        }
      },
    );
  }
}

