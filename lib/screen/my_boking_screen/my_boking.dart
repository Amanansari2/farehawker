import 'package:flutter/material.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;

import '../../widgets/constant.dart';
import '../ticket status/ticket_status.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({Key? key}) : super(key: key);

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: kBlueColor,
        iconTheme: const IconThemeData(color: kWhite),
        centerTitle: true,
        title: Text(
          lang.S.of(context).myBookingTitle,
          style: kTextStyle.copyWith(
            color: kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: kBorderColorTextField,
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   'Paid: \₹14500.',
                                  //   style: kTextStyle.copyWith(
                                  //     fontSize: 14,
                                  //     color: kTitleColor,
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Convenience Fee Added',
                                    style: kTextStyle.copyWith(fontSize: 12, color: kSubTitleColor),
                                  )
                                ],
                              ),
                              Text(
                                'Completed',
                                style: kTextStyle.copyWith(
                                  fontSize: 12,
                                  color: const Color(0xff00CD46),
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            thickness: 1.0,
                            color: kBorderColorTextField,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TicketStatus(),
                                ),
                              );
                            },
                            horizontalTitleGap: 5.0,
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 0,
                            leading: Container(
                              height: 44.0,
                              width: 44.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage('images/logo/AF.png'), fit: BoxFit.cover),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Air France", style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 16),),
                                Row(
                                  children: [
                                    Text(
                                      'BOM',
                                      style: kTextStyle.copyWith(color: kTitleColor),
                                    ),
                                    const SizedBox(width: 2.0),
                                    const Icon(
                                      Icons.swap_horiz,
                                      color: kLightNeutralColor,
                                    ),
                                    const SizedBox(width: 2.0),
                                    Text(
                                      'Yow',
                                      style: kTextStyle.copyWith(fontSize: 14, color: kTitleColor),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'Fri, 25 Jul 01:20  -  Fri, 25 Jul 15:05 | 17h 25m | 1 Stop',
                              style: kTextStyle.copyWith(fontSize: 12, color: kSubTitleColor),
                            ),
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          const Divider(
                            thickness: 1.0,
                            color: kBorderColorTextField,
                          ),
                          const Text(
                            'Ms. Aayat Sayed (Female)',
                            style: TextStyle(fontSize: 12, color: kTitleColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
