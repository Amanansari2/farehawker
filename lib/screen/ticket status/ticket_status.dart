import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../widgets/constant.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;



class TicketStatus extends StatefulWidget {
  const TicketStatus({Key? key}) : super(key: key);

  @override
  State<TicketStatus> createState() => _TicketStatusState();
}

class _TicketStatusState extends State<TicketStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: kBlueColor,
        title: Text(lang.S.of(context).ticketStatusTitle, style: const TextStyle(color: kWhite),),
        iconTheme: const IconThemeData(color: kWhite),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: kDarkWhite),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 90,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: kWhite,
            boxShadow: [
              BoxShadow(
                color: kDarkWhite,
                offset: Offset(
                  0,
                  -2,
                ),
                blurRadius: 7.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: double.infinity,
                child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 0.0,
                    backgroundColor: kPrimaryColor,
                  ),
                  onPressed: () async{


                      // String fileUrl = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
                      //
                      // final directory = await getExternalStorageDirectory();
                      // String filePath = '${directory!.path}/downloadedFile.pdf';
                      //
                      // try {
                      //   var response = await http.get(Uri.parse(fileUrl));
                      //
                      //
                      //   if (response.statusCode == 200) {
                      //     File file = File(filePath);
                      //     await file.writeAsBytes(response.bodyBytes);
                      //     print('File downloaded to $filePath');
                      //   } else {
                      //     print('Error downloading file: ${response.statusCode}');
                      //   }
                      // } catch (e) {
                      //   print('Error: $e');
                      // }


                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Download',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: kWhite),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      FaIcon(
                        FeatherIcons.downloadCloud,
                        size: 25,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(16.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 47,
                        width: 53,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(image: AssetImage('images/logo/TTT.png'), fit: BoxFit.cover),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'E-Ticket',
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Booking ID- EMT9456544',
                            style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12.0),
                          ),
                          Text(
                            'Booking on - Fri, 08 Jul 2025 - 14:27',
                            style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12.0),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: List.generate(
                        800 ~/ 10,
                            (index) => Expanded(
                          child: Container(
                            color: index % 2 == 0 ? Colors.transparent : kPrimaryColor.withOpacity(0.5),
                            height: 1,
                          ),
                        )),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: kBorderColorTextField),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTileTheme(
                            contentPadding: const EdgeInsets.all(0),
                            dense: true,
                            horizontalTitleGap: 0.0,
                            minLeadingWidth: 0,
                            child: ListTile(
                              visualDensity: const VisualDensity(vertical: -4),
                              dense: true,
                              horizontalTitleGap: 10.0,
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                height: 24.0,
                                width: 24.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: AssetImage('images/logo/AF.png'), fit: BoxFit.cover),
                                ),
                              ),
                              title: Text(
                                'Air France',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'AF | 217',
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'BOM',
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        '01:20',
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Fri, 25 Jul 2025',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Terminal T2',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  ),
                                  Text(
                                    'Mumbai, India',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 5.0),
                              Column(
                                children: [
                                  Text(
                                    '09h 35m',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Row(
                                    children: [
                                      Container(
                                        height: 10.0,
                                        width: 10.0,
                                        decoration: const BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 2.0,
                                            width: 80,
                                            decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.arrow_right_alt_outlined,
                                              size: 16,
                                              color: kWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 10.0,
                                        width: 10.0,
                                        decoration: BoxDecoration(
                                          color: kWhite,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: kPrimaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2.0),
                                  // Text(
                                  //   'First Class',
                                  //   style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  // ),
                                ],
                              ),
                              const SizedBox(width: 5.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'PAR',
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        '07:25',
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Fri, 25 Jul 2025',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Terminal T2E',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  ),
                                  Text(
                                    'Paris, France',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            color: kSecondaryColor,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.luggage,
                                color: kTitleColor,
                              ),
                              Text(
                                'Baggage:',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12.0),
                              ),
                              const Spacer(),
                              Text(
                                'Cabin - 12 Kgs  \n (1 Piece x 12 Kgs)',
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(color: kTitleColor, fontSize: 10.0),
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Text(
                                    'Check-in  - 23 Kgs',
                                    textAlign: TextAlign.end,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 10.0),
                                  ),
                                  Text(
                                    '(1 Piece x 23 Kgs)',
                                    textAlign: TextAlign.end,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 10.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: kBorderColorTextField),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTileTheme(
                            contentPadding: const EdgeInsets.all(0),
                            dense: true,
                            horizontalTitleGap: 0.0,
                            minLeadingWidth: 0,
                            child: ListTile(
                              visualDensity: const VisualDensity(vertical: -4),
                              dense: true,
                              horizontalTitleGap: 10.0,
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                height: 24.0,
                                width: 24.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: AssetImage('images/logo/AF.png'), fit: BoxFit.cover),
                                ),
                              ),
                              title: Text(
                                'Air France',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'AF | 328',
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'PAR',
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        '13:15',
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Fri, 25 Jul 2025',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Terminal T2E',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  ),
                                  Text(
                                    'Paris, France',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 5.0),
                              Column(
                                children: [
                                  Text(
                                    '07h 50m',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Row(
                                    children: [
                                      Container(
                                        height: 10.0,
                                        width: 10.0,
                                        decoration: const BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 2.0,
                                            width: 80,
                                            decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.arrow_right_alt_outlined,
                                              size: 16,
                                              color: kWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 10.0,
                                        width: 10.0,
                                        decoration: BoxDecoration(
                                          color: kWhite,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: kPrimaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2.0),
                                  // Text(
                                  //   'First Class',
                                  //   style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  // ),
                                ],
                              ),
                              const SizedBox(width: 5.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'YOW',
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        '15:05',
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Fri, 25 Jul 2025',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  ),
                                  const SizedBox(height: 5.0),
                                  // Text(
                                  //   'Terminal T2E',
                                  //   style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  // ),
                                  Text(
                                    'Ottawa, Canada',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            color: kSecondaryColor,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.luggage,
                                color: kTitleColor,
                              ),
                              Text(
                                'Baggage:',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12.0),
                              ),
                              const Spacer(),
                              Text(
                                'Cabin - 12 Kgs  \n (1 Piece x 12 Kgs)',
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(color: kTitleColor, fontSize: 10.0),
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Text(
                                    'Check-in  - 23 Kgs',
                                    textAlign: TextAlign.end,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 10.0),
                                  ),
                                  Text(
                                    '(1 Piece x 23 Kgs)',
                                    textAlign: TextAlign.end,
                                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 10.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: List.generate(
                        800 ~/ 10,
                            (index) => Expanded(
                          child: Container(
                            color: index % 2 == 0 ? Colors.transparent : kPrimaryColor.withOpacity(0.5),
                            height: 1,
                          ),
                        )),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    'Traveler Details',
                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: kBorderColorTextField)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Passenger Name',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Ms. Aayat Sayed',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 10.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Airline PNR',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    '9H3TQF',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 10.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Ticket Number',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    '057-1234567890',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 10.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        const Divider(
                          thickness: 1.0,
                          color: kBorderColorTextField,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Travel Insurance',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Not Confirmed',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 10.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Class | Cabin',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    '1A | (First Class) | Window',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 10.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Status',
                                    style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Confirm',
                                    style: kTextStyle.copyWith(color: Colors.green, fontSize: 10.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: List.generate(
                        800 ~/ 10,
                            (index) => Expanded(
                          child: Container(
                            color: index % 2 == 0 ? Colors.transparent : kPrimaryColor.withOpacity(0.5),
                            height: 1,
                          ),
                        )),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: context.width(),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: kBorderColorTextField)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Fare Summary',
                          style: kTextStyle.copyWith(
                            color: kTitleColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Basic Fare',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '$currencySign ${NumberFormat('#,##0').format(63170)}',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'SurCharges',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '$currencySign ${NumberFormat('#,##0').format(30910)}',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Reschedule Charges',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '$currencySign ${0}',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'K3',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '$currencySign ${0}',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Coupon offer',
                                style: kTextStyle.copyWith(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '$currencySign ${0}',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Total',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '$currencySign ${NumberFormat('#,##0').format(94080)}',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                ),
                                color: kSecondaryColor,
                                border: Border.all(color: kBorderColorTextField),
                              ),
                              child: Text(
                                'BOM - YOW',
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8.0),
                                ),
                                color: kSecondaryColor,
                                border: Border.all(color: kBorderColorTextField),
                              ),
                              child: Text(
                                'Cancellation\nCharges',
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 52,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kSecondaryColor,
                                      border: Border.all(color: kBorderColorTextField),
                                    ),
                                    child: Text(
                                      'Type',
                                      textAlign: TextAlign.center,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 52,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kSecondaryColor,
                                      border: Border.all(color: kBorderColorTextField),
                                    ),
                                    child: Text(
                                      'Cancellation Time',
                                      textAlign: TextAlign.center,
                                      style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                border: Border.all(color: kBorderColorTextField),
                              ),
                              child: Text(
                                'Airline',
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 52,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      border: Border.all(color: kBorderColorTextField),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Text(
                                      'ADT',
                                      textAlign: TextAlign.center,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontSize: 12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 52,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      border: Border.all(color: kBorderColorTextField),
                                    ),
                                    child: Text(
                                      'Before 4 hours of Flight departure',
                                      textAlign: TextAlign.center,
                                      style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                ),
                                border: Border.all(color: kBorderColorTextField),
                              ),
                              child: Text(
                                'As per airlines T&C',
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: context.width(),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: kBorderColorTextField)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Terms & Conditions',
                          style: kTextStyle.copyWith(
                            color: kTitleColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                             Icon(
                              MdiIcons.circleMedium,
                              color: kSubTitleColor,
                            ),
                            Expanded(
                              child: Text(
                                'Lorem ipsum dolor sit amet consectetur. Quisque',
                                style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              MdiIcons.circleMedium,
                              color: kSubTitleColor,
                            ),
                            Expanded(
                              child: Text(
                                ' nulla bibendum nibh augue porta consequat.',
                                style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                             Icon(
                              MdiIcons.circleMedium,
                              color: kSubTitleColor,
                            ),
                            Expanded(
                              child: Text(
                                'Aliquet nam arcu potenti congue risus quam.',
                                style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                             Icon(
                              MdiIcons.circleMedium,
                              color: kSubTitleColor,
                            ),
                            Expanded(
                              child: Text(
                                'enim blandit in eget quam magna donec magna\n scelerisque. Interdum sed in convallis',
                                style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             Icon(
                              MdiIcons.circleMedium,
                              color: kSubTitleColor,
                            ),
                            Expanded(
                              child: Text(
                                'varius sapien ullamcorper posuere. Sem tortor\n eros volutpat pulvinar. Platea suspendisse ut\n condimen tum felis. Duis amet lobortis\n lacus nibh ',
                                style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
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

