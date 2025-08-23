import 'package:country_code_picker/country_code_picker.dart';
import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:flightbooking/routes/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../models/flight_details_model.dart';
import '../../providers/fare_rule_provider.dart';
import '../../providers/pricing_request _provider.dart';
import '../../providers/search_flight_provider.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/custom_dialog.dart';
import '../payment/payment.dart';

// ============================= MAIN SCREEN =============================
class BookProceed extends StatefulWidget {
  final FlightDetail flight;

  const BookProceed({Key? key, required this.flight}) : super(key: key);

  @override
  State<BookProceed> createState() => _BookProceedState();
}

class _BookProceedState extends State<BookProceed> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchFlightProvider>();
    return Scaffold(
      backgroundColor: kWhite,
      appBar: BookProceedAppBar(provider: provider),
      bottomNavigationBar: BookProceedBottomBar(flight: widget.flight,provider: provider),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              BaggagePolicyCard(
                flight: widget.flight,
              ),
              const SizedBox(height: 10),
              BookingDetailsCard(
                onEdit: () => _showBookingModal(context),
              ),
              const SizedBox(height: 10),
               TravellerDetailsCard(flight: widget.flight),
               // if (widget.flight.passport == true)

            ],
          ),
        ),
      ),
    );
  }





  void _showBookingModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      context: context,
      builder: (_) => const BookingModal(),
    );
  }
}

// ============================= APP BAR =============================
class BookProceedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SearchFlightProvider provider;

  const BookProceedAppBar({Key? key, required this.provider}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      elevation: 0,
      backgroundColor: kBlueColor,
      iconTheme: const IconThemeData(color: kWhite),
      title: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        contentPadding: const EdgeInsets.only(right: 15),
        title: Text(
          '${provider.fromCity?.city ?? ''} - ${provider.toCity?.city ?? ''}',
          style:
              kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${DateFormat('EEE d MMM').format(provider.selectedDate)} | ${provider.adultCount} Adult, ${provider.childCount} Child, ${provider.infantCount} Infant',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: kTextStyle.copyWith(color: kWhite),
        ),
      ),
    );
  }
}

// ============================= BOTTOM BAR =============================
class BookProceedBottomBar extends StatelessWidget {
  final SearchFlightProvider provider;
  final FlightDetail flight;

  const BookProceedBottomBar({Key? key,required this.flight,required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: kWhite),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child:


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ' $currencySign${flight.fare}',
              style: kTextStyle.copyWith(
                  color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20),
            ),

            SizedBox(
              width: 200,
              child: Consumer<PricingProvider>(
                builder: (context, pricingProvider,_) {
                  return ButtonGlobalWithoutIcon(
                    buttontext: pricingProvider.isLoading? 'Please wait...' : lang.S.of(context).continueButton,
                    buttonDecoration: kButtonDecoration.copyWith(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: pricingProvider.isLoading
                        ? null
                          : ()  async{
                      final bookProvider = context.read<BookProceedProvider>();
                      final searchProvider = context.read<SearchFlightProvider>();
                     try {

                       final response = await bookProvider.submitBookingData(
                           context: context,
                           flight:flight,
                           searchProvider: searchProvider);

                       AppLogger.log("data Submit -->> $response");
                       pricingProvider.clearSelectedServices(bookProvider.travellers);


                       await pricingProvider.fetchOneWayPricing(
                           flight, searchProvider.adultCount,
                           searchProvider.childCount,
                           searchProvider.infantCount);




                       if(!context.mounted)return;
                       final err = pricingProvider.error?.trim();
                       if(err != null && err.isNotEmpty){
                         await showDialog(
                             context: context,
                             builder: (BuildContext context){
                               return CustomDialogBox(
                                 title: "Error",
                                 descriptions: err,
                                 text: "Close",
                                 titleColor: kRedColor,
                                 img: 'images/dialog_error.png',
                                 functionCall: () {
                                   Navigator.of(context).pop(); // close dialog
                                 },
                               );
                             });
                       }
                       else{
                         Navigator.pushNamed(context, AppRoutes.pricingRules, arguments: flight);
                         // Navigator.pushNamed(context, AppRoutes.payment, arguments: flight, );
                       }
                     }catch(e){
                       AppLogger.log("Data Submit failed -->> $e");
                     }
                    },
                    buttonTextColor: kWhite,
                  );
                }
              ),
            ),

          ],
        ),

    );
  }
}

// ============================= BAGGAGE POLICY =============================
class BaggagePolicyCard extends StatelessWidget {
  final FlightDetail flight;

  const BaggagePolicyCard({Key? key, required this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchFlightProvider>();
    final proceedProvider = context.watch<BookProceedProvider>();

    final baggageRows = proceedProvider.getBaggageRows(
      flight,
      adultCount: provider.adultCount,
      childCount: provider.childCount,
      infantCount: provider.infantCount,
    );

    List<TableRow> rows = [
      TableRow(
        decoration: const BoxDecoration(color: kDarkWhite),
        children: [
          _headerCell('Passenger Type'),
          _headerCell('Checked Baggage'),
          _headerCell('Cabin Baggage'),
        ],
      ),
    ];

    for (final row in baggageRows) {
      rows.add(_buildRow(row['type']!, row['checked']!, row['cabin']!));
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(lang.S.of(context).bagPolicyTitle,
                    style: kTextStyle.copyWith(
                        color: kTitleColor, fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      context: context,
                      builder: (_) => const BaggageModal(),
                    );
                  },
                  child: Text(
                    "View Details",
                    style:  kTextStyle.copyWith(
                        color: kPrimaryColor, fontWeight: FontWeight.bold, )


                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Table(
            border: TableBorder.all(color: kBorderColorTextField, width: 1),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },
            children: rows,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          style: kTextStyle.copyWith(
              color: kTitleColor, fontWeight: FontWeight.bold)),
    );
  }

  TableRow _buildRow(String type, String cabin, String checked) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(type, style: kTextStyle.copyWith(color: kSubTitleColor)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cabin,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kSubTitleColor)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(checked,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kSubTitleColor)),
        ),
      ],
    );
  }
}

// Modal
// class BaggageModal extends StatelessWidget {
//   const BaggageModal({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.75,
//       maxChildSize: 0.80,
//       minChildSize: 0.20,
//       expand: false,
//       builder: (_, controller) {
//         return SingleChildScrollView(
//           physics: const NeverScrollableScrollPhysics(),
//           controller: controller,
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 Row(
//                   children: [
//                     Text('Flight Rules',
//                         style: kTextStyle.copyWith(
//                             color: kTitleColor, fontWeight: FontWeight.bold)),
//                     const Spacer(),
//                     GestureDetector(
//                         onTap: () => finish(context),
//                         child:
//                             const Icon(FeatherIcons.x, color: kSubTitleColor)),
//                   ],
//                 ),
//                 Consumer<BookProceedProvider>(
//                   builder: (context, fareProvider, _) {
//                     if (fareProvider.isLoading) {
//                       return const Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child: Center(child: CircularProgressIndicator()),
//                       );
//                     }
//                     if (fareProvider.error != null) {
//                       return Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Text(
//                           fareProvider.error!,
//                           style: kTextStyle.copyWith(color: Colors.red),
//                         ),
//                       );
//                     }
//                     if (fareProvider.fareRulesContent == null ||
//                         fareProvider.fareRulesContent!.isEmpty) {
//                       return Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Text(
//                           "No fare rules found",
//                           style: kTextStyle.copyWith(color: kSubTitleColor),
//                         ),
//                       );
//                     }
//                     return SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.7,
//                       child: SingleChildScrollView(
//                         child: Html(
//                           data: fareProvider.formatFareRulesHtml(
//                               fareProvider.fareRulesContent ?? ''),
//                           style: {
//                             "body": Style(
//                               fontSize: FontSize(16.0),
//                               lineHeight: LineHeight.number(1.2),
//                               color: Colors.black87,
//                             ),
//                             "b": Style(
//                               fontWeight: FontWeight.bold,
//                             ),
//                             "table": Style(
//                               backgroundColor: Colors.grey.shade50,
//                               border: Border.all(color: Colors.grey.shade300),
//                             ),
//                             "th": Style(
//                               padding: HtmlPaddings.all(6),
//                               fontWeight: FontWeight.bold,
//                               backgroundColor: Colors.grey.shade200,
//                             ),
//                             "td": Style(
//                               padding: HtmlPaddings.all(6),
//                             ),
//                             "li": Style(
//                               padding: HtmlPaddings.symmetric(vertical: 4),
//                             ),
//                             "ul": Style(padding: HtmlPaddings.only(left: 16)),
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class BaggageModal extends StatelessWidget {
  const BaggageModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.80,
      minChildSize: 0.20,
      expand: false,
      builder: (context, controller) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: ListView(
            controller: controller, // **Critical**: Using provided controller
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Flight Rules',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontWeight: FontWeight.bold,
                      )),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => finish(context),
                    child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Consumer<BookProceedProvider>(
                builder: (context, fareProvider, _) {
                  if (fareProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (fareProvider.error != null) {
                    return Text(fareProvider.error!,
                        style: kTextStyle.copyWith(color: Colors.red));
                  }

                  final htmlData = fareProvider.formatFareRulesHtml(
                      fareProvider.fareRulesContent ?? '');

                  if (htmlData.trim().isEmpty) {
                    return Text("No fare rules found",
                        style: kTextStyle.copyWith(color: kSubTitleColor));
                  }

                  return Text("No fare rules found",
                      style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 20));

                  // return Html(
                  //   data: htmlData,
                  //   // Avoid introducing another scroll view here
                  //   style: {
                  //     "body": Style(
                  //       fontSize: FontSize(16.0),
                  //       lineHeight: LineHeight.number(1.2),
                  //       color: Colors.black87,
                  //     ),
                  //     "table": Style(
                  //       backgroundColor: Colors.grey.shade50,
                  //       border: Border.all(color: Colors.grey.shade300),
                  //     ),
                  //     "th": Style(
                  //       padding: HtmlPaddings.all(6),
                  //       fontWeight: FontWeight.bold,
                  //       backgroundColor: Colors.grey.shade200,
                  //     ),
                  //     "td": Style(padding: HtmlPaddings.all(6)),
                  //     "li": Style(
                  //         padding: HtmlPaddings.symmetric(vertical: 4)),
                  //     "ul":
                  //     Style(padding: HtmlPaddings.only(left: 16)),
                  //   },
                  // );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}





// ============================= TRAVELLER DETAILS =============================

class TravellerDetailsCard extends StatelessWidget {
  final FlightDetail flight;
  const TravellerDetailsCard({Key? key, required this.flight}) : super(key: key);

  void _showAddTravellerModal(BuildContext context, String type, int typeLimit) {
    final bookProvider = context.read<BookProceedProvider>();
    final currentTypeCount = bookProvider.travellers.where((t) => t.type == type).length;
    if (currentTypeCount >= typeLimit) {
      showDialog(
        context: context,
        builder: (ctx) {
          return CustomDialogBox(
            title: "Limit Reached",
            descriptions: "You can add up to $typeLimit $type(s) only.",
            text: "OK",
            img: 'images/dialog_error.png',
            titleColor: Colors.red,
            functionCall: () {
              Navigator.of(ctx).pop();
            },
          );
        },
      );
      return;
    }
    bookProvider.resetForm();
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (_) => AddTravellerModal(type: type, typeLimit: typeLimit, flight: flight,)
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.read<SearchFlightProvider>();
    final bookProvider = context.watch<BookProceedProvider>();

    // Prepare grouped data
    final Map<String, int> typeLimits = {
      'Adult': searchProvider.adultCount,
      'Child': searchProvider.childCount,
      'Infant': searchProvider.infantCount,
    };

    final Map<String, List<dynamic>> groupedTravellers = {
      'Adult': bookProvider.travellers.where((t) => t.type == 'Adult').toList(),
      'Child': bookProvider.travellers.where((t) => t.type == 'Child').toList(),
      'Infant': bookProvider.travellers.where((t) => t.type == 'Infant').toList(),
    };

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Travelers Details',
            style: kTextStyle.copyWith(
                color: kTitleColor, fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 20),
          ...typeLimits.entries.where((e) => e.value > 0).expand((entry) {
            final type = entry.key;
            final limit = entry.value;
            final travellersOfType = groupedTravellers[type] ?? [];
            final currentCount = travellersOfType.length;

            // Section UI: Header, Traveller Cards, Add Button (if not full)
            return [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  type,
                  style: kTextStyle.copyWith(
                      color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16
                  ),
                ),
              ),
              ...travellersOfType.asMap().entries.map((tEntry) {
                final index = bookProvider.travellers.indexOf(tEntry.value);
                final traveller = tEntry.value;
                final bool showPassport = (traveller.passportNumber != null && traveller.passportNumber.trim().isNotEmpty)
                    || (traveller.passportExpiry != null);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: kWhite,
                    boxShadow: const [
                      BoxShadow(
                        color: kBorderColorTextField,
                        blurRadius: 7.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.check_box, color: kPrimaryColor),
                    title: Text(
                      '${traveller.firstName} ${traveller.lastName}',
                      style: kTextStyle.copyWith(color: kTitleColor),
                    ),
                    subtitle:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${traveller.gender} | ${DateFormat('dd MMM yyyy').format(traveller.dateOfBirth)}',
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                        if (showPassport) ...[
                          if (traveller.passportNumber != null && traveller.passportNumber.trim().isNotEmpty)
                            Text(
                              'Passport Number: ${traveller.passportNumber}',
                              style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 13),
                            ),
                          if (traveller.passportExpiry != null)
                            Text(
                              ' Passport Expiry: ${DateFormat('dd MMM yyyy').format(traveller.passportExpiry)}',
                              style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 13),
                            ),
                        ],
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        bookProvider.removeTraveller(index);
                      },
                    ),
                  ),
                );
              }),
              if (currentCount < limit)
                _AddTravellerTypeButton(
                  type: type,
                  limit: limit,
                  currentCount: currentCount,
                  onAdd: () => _showAddTravellerModal(context, type, limit),
                ),
            ];
          }),
        ],
      ),
    );
  }
}

// Modal
class AddTravellerModal extends StatefulWidget {
  final String type;
  final int typeLimit;
  final FlightDetail flight;
  const AddTravellerModal({Key? key, required this.type, required this.typeLimit, required this.flight}) : super(key: key);

  @override
  State<AddTravellerModal> createState() => _AddTravellerModalState();
}

class _AddTravellerModalState extends State<AddTravellerModal> {
  late TextEditingController _dobController;
  late TextEditingController _passportExpiryController;

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController();
    _passportExpiryController = TextEditingController();
  }

  @override
  void dispose() {
    _dobController.dispose();
    _passportExpiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProceedProvider>();

    if (provider.dateOfBirth != null) {
      final formatted = DateFormat('dd MMM yyyy').format(provider.dateOfBirth!);
      if (_dobController.text != formatted) {
        _dobController.text = formatted;
      }
    } else {
      if (_dobController.text.isNotEmpty) {
        _dobController.text = '';
      }
    }

    if(provider.passportExpiry != null){
      final formatted = DateFormat('dd MMM yyyy').format(provider.passportExpiry!);
      if(_passportExpiryController.text != formatted){
        _passportExpiryController.text = formatted;
      }
    }else{
      if(_passportExpiryController.text.isNotEmpty){
        _passportExpiryController.text = '';
      }
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Add Travellers Details',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.S.of(context).selectGenderTitle,
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                    ),
                    Wrap(
                      spacing: 10,
                      children: provider.genderList.map((g) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: g,
                              groupValue: provider.selectedGender,
                              onChanged: (val) {
                                if (val != null) provider.setGender(val);
                              },
                            ),
                            Text(
                              g,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    _textField(lang.S.of(context).nameTitle,
                        lang.S.of(context).nameHint,
                        onChanged: provider.setFirstName),
                    const SizedBox(height: 20),
                    _textField(lang.S.of(context).lastNameTitle,
                        lang.S.of(context).lastNameHint,
                        onChanged: provider.setLastName),
                    const SizedBox(height: 20),
                    _textField(
                      "Date Of Birth",
                      "Select date",
                      controller: _dobController,
                      onChanged: (_) {},
                      suffixIcon: Icons.calendar_today,
                      onIconTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              provider.dateOfBirth ?? DateTime(2000, 1, 1),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          provider.setDateOfBirth(picked);
                          _dobController.text =
                              DateFormat('dd MMM yyyy').format(picked);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
          if (widget.flight.passport == true) ...[
                    _textField(
                        "Passport Number",
                        "Passport Number",
                        onChanged: provider.setPassportNumber),
                    
                    const SizedBox(height: 20),
                    
                    _textField(
                        "Passport Expiry",
                        "Select date",
                        controller: _passportExpiryController,
                        onChanged: (_){},
                    suffixIcon: Icons.calendar_today,
                      onIconTap: () async {
                          final today = DateTime.now();
                          final picked = await showDatePicker(
                              context: context,
                              initialDate: provider.passportExpiry ?? today,
                              firstDate: today,
                              lastDate: DateTime(2099)
                          );
                          if(picked != null){
                            provider.setPassportExpiry(picked);
                            _passportExpiryController.text = DateFormat('dd MMM yyyy').format(picked);
                          }
                      }
                    ),
                    const SizedBox(height: 20),
                    ],
                    ButtonGlobalWithoutIcon(
                      buttontext: 'Done',
                      buttonDecoration: kButtonDecoration.copyWith(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () {
                        final success = context
                            .read<BookProceedProvider>()
                            .addTraveller(context,
                          type: widget.type,
                          typeLimit: widget.typeLimit,
                        isPassportRequired: widget.flight.passport == true
                        );
                        if (success) {
                          Navigator.pop(context);
                        }
                      },
                      buttonTextColor: kWhite,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _textField(
    String label,
    String hint, {
    required ValueChanged<String> onChanged,
    TextEditingController? controller,
    String? initialValue,
    IconData? suffixIcon,
    VoidCallback? onIconTap,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      readOnly: onIconTap != null,
      onTap: onIconTap,
      decoration: kInputDecoration.copyWith(
        labelText: label,
        hintText: hint,
        labelStyle: kTextStyle.copyWith(color: kTitleColor),
        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, color: kPrimaryColor),
                onPressed: onIconTap,
              )
            : null,
      ),
    );
  }
}


class _AddTravellerTypeButton extends StatelessWidget {
  final String type;
  final int limit;
  final int currentCount;
  final VoidCallback onAdd;

  const _AddTravellerTypeButton({
    required this.type,
    required this.limit,
    required this.currentCount,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ButtonGlobalWithIcon(
        buttontext: 'Add New $type (${currentCount}/$limit)',
        buttonTextColor: kPrimaryColor,
        buttonIcon: FeatherIcons.plus,
        buttonDecoration: kButtonDecoration.copyWith(
          color: kWhite,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: kPrimaryColor.withOpacity(0.5)),
        ),
        onPressed: currentCount < limit ? onAdd : null,
      ),
    );
  }
}



// ============================= BOOKING DETAILS =============================
class BookingDetailsCard extends StatelessWidget {
  final VoidCallback onEdit;

  const BookingDetailsCard({
    Key? key,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProceedProvider>();
    return GestureDetector(
      onTap: onEdit,
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Booking details will be sent to',
                    style: kTextStyle.copyWith(
                        color: kTitleColor, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('Add Details',
                    style: kTextStyle.copyWith(
                        color: kPrimaryColor, fontWeight: FontWeight.bold)),

              ],
            ),
            ListTile(
              leading: _icon(Icons.email),
              title: Text(
                  bookProvider.email.isNotEmpty
                      ? bookProvider.email
                      : 'Add Email',
                  style: kTextStyle.copyWith(color: kSubTitleColor)),
            ),
            ListTile(
              leading: _icon(Icons.phone),
              title: Text(
                  bookProvider.phone.isNotEmpty
                  ?'${bookProvider.countryCode.isNotEmpty ? bookProvider.countryCode : ""} ${bookProvider.phone}'
                      : 'Add Mobile Number',
                  style: kTextStyle.copyWith(color: kSubTitleColor)),
            ),
            const Divider(thickness: 1, color: kBorderColorTextField),
          ],
        ),
      ),
    );
  }

  static Widget _icon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: kPrimaryColor.withOpacity(0.2)),
      child: Icon(icon, color: kPrimaryColor, size: 18),
    );
  }
}

// Modal
class BookingModal extends StatefulWidget {
  const BookingModal({Key? key}) : super(key: key);

  @override
  State<BookingModal> createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<BookProceedProvider>();
    _emailController = TextEditingController(text: provider.email);
    _phoneController = TextEditingController(text: provider.phone);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(lang.S.of(context).contactInfoTitle,
                      style: kTextStyle.copyWith(
                          color: kTitleColor, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  GestureDetector(
                      onTap: () => finish(context),
                      child: const Icon(FeatherIcons.x, color: kSubTitleColor)),
                ],
              ),
              const SizedBox(height: 20),
              _textField(
                lang.S.of(context).emailHint,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _textField(
                lang.S.of(context).phoneHint,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefix:  CountryCodePicker(
                  onChanged: (country) {
                    context.read<BookProceedProvider>().setCountryCode(country.dialCode ?? '+91');
                  },
                  initialSelection: 'IN',
                  showFlag: true,
                  showDropDownButton: true,
                ),
              ),
              const SizedBox(height: 20),
              ButtonGlobalWithoutIcon(
                buttontext: lang.S.of(context).confirm,
                buttonDecoration: kButtonDecoration.copyWith(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () {
                  final provider = context.read<BookProceedProvider>();

                  provider.setEmail(_emailController.text.trim());
                  provider.setPhone(_phoneController.text.trim());

                  final success = provider.validateBookingDetails(context);
                  if (success) {
                    Navigator.pop(context);
                  }
                },
                buttonTextColor: kWhite,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  static Widget _textField(
    String label, {
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
    Widget? prefix,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: kInputDecoration.copyWith(
          labelText: label,
          hintText: label,
          border: const OutlineInputBorder(),
          labelStyle: kTextStyle.copyWith(color: kTitleColor),
          hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
          prefixIcon: prefix),
    );
  }
}




// ============================= HELPER CARD DECORATION =============================
Widget _card({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: kWhite,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: kSecondaryColor),
      boxShadow: const [
        BoxShadow(
          color: kDarkWhite,
          spreadRadius: 2,
          blurRadius: 7,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}
