import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../models/flight_details_model.dart';
import '../../providers/fare_rule_provider.dart';
import '../../providers/search_flight_provider.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../payment/payment.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;




import 'package:flutter/cupertino.dart';

// ============================= MAIN SCREEN =============================
class BookProceed extends StatefulWidget {
  final FlightDetail flight;
  const BookProceed({Key? key, required this.flight}) : super(key: key);

  @override
  State<BookProceed> createState() => _BookProceedState();
}

class _BookProceedState extends State<BookProceed> {

  List<String> genderList = ['Mr.', 'Mrs.', 'Miss.'];
  String selectedGender = 'Mr.';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchFlightProvider>();
    return Scaffold(
      backgroundColor: kWhite,
      appBar: BookProceedAppBar(provider: provider),
      bottomNavigationBar: BookProceedBottomBar(provider: provider),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
               BaggagePolicyCard(flight: widget.flight,),
              const SizedBox(height: 10),
              BookingDetailsCard(
                onEdit: () => _showBookingModal(context),
              ),
              const SizedBox(height: 10),
              TravellerDetailsCard(
                onAddTraveller: () => _showAddTravellerModal(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTravellerModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      context: context,
      builder: (_) => AddTravellerModal(
        genderList: genderList,
        selectedGender: selectedGender,
        onGenderChanged: (val) => setState(() => selectedGender = val),
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

  const BookProceedBottomBar({Key? key, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: kWhite),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        visualDensity: const VisualDensity(vertical: 2),
        title: Text(
          'For ${provider.adultCount} Adult, ${provider.childCount} Child, ${provider.infantCount} Infant',
          style: kTextStyle.copyWith(color: kSubTitleColor),
        ),
        subtitle: Text(
          '$currencySign${45000.00}',
          style: kTextStyle.copyWith(
              color: kTitleColor, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          width: 200,
          child: ButtonGlobalWithoutIcon(
            buttontext: lang.S.of(context).continueButton,
            buttonDecoration: kButtonDecoration.copyWith(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () => const Payment().launch(context),
            buttonTextColor: kWhite,
          ),
        ),
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
                  child: const Icon(FeatherIcons.chevronRight,
                      color: kPrimaryColor),
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
class BaggageModal extends StatelessWidget {


  const BaggageModal({Key? key,})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.80,
      minChildSize: 0.20,
      expand: false,
      builder: (_, controller) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text('Refund & Baggage Policy',
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    GestureDetector(
                        onTap: () => finish(context),
                        child:
                            const Icon(FeatherIcons.x, color: kSubTitleColor)),
                  ],
                ),
                Consumer<BookProceedProvider>(
                  builder: (context, fareProvider, _) {
                    if (fareProvider.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (fareProvider.error != null) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          fareProvider.error!,
                          style: kTextStyle.copyWith(color: Colors.red),
                        ),
                      );
                    }
                    if (fareProvider.fareRulesContent == null ||
                        fareProvider.fareRulesContent!.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "No fare rules found",
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: SingleChildScrollView(
                        child: Html(
                          data:  fareProvider.formatFareRulesHtml(fareProvider.fareRulesContent ?? ''),
                          style: {
                            "body": Style(
                              fontSize: FontSize(16.0),
                              lineHeight: LineHeight.number(1.2),
                              color: Colors.black87,
                            ),
                            "b": Style(
                              fontWeight: FontWeight.bold,
                            ),
                            "table": Style(
                              backgroundColor: Colors.grey.shade50,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            "th": Style(
                              padding: HtmlPaddings.all(6),
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.grey.shade200,
                            ),
                            "td": Style(
                              padding: HtmlPaddings.all(6),
                            ),
                            "li": Style(
                              padding: HtmlPaddings.symmetric(vertical: 4),
                            ),
                            "ul": Style(
                                padding: HtmlPaddings.only(left: 16)
                            ),
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================= TRAVELLER DETAILS =============================
class TravellerDetailsCard extends StatelessWidget {
  final VoidCallback onAddTraveller;

  const TravellerDetailsCard({Key? key, required this.onAddTraveller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Traveler Details',
              style: kTextStyle.copyWith(
                  color: kTitleColor, fontWeight: FontWeight.bold)),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: _circleIcon(IconlyBold.profile),
            title: Text('Adult (12 yrs+)',
                style: kTextStyle.copyWith(color: kSubTitleColor)),
            trailing: RichText(
              text: TextSpan(
                  text: '1/1 ',
                  style: kTextStyle.copyWith(color: kTitleColor),
                  children: [
                    TextSpan(
                        text: 'Added',
                        style: kTextStyle.copyWith(color: kSubTitleColor)),
                  ]),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: kWhite,
              boxShadow: const [
                BoxShadow(
                    color: kBorderColorTextField,
                    blurRadius: 7.0,
                    spreadRadius: 2.0,
                    offset: Offset(0, 2))
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.check_box, color: kPrimaryColor),
              title: Text('Ibne Riead',
                  style: kTextStyle.copyWith(color: kTitleColor)),
              trailing: const Icon(IconlyBold.edit, color: kPrimaryColor),
            ),
          ),
          const SizedBox(height: 10),
          ButtonGlobalWithIcon(
            buttontext: 'Add Traveller Details',
            buttonTextColor: kPrimaryColor,
            buttonIcon: FeatherIcons.plus,
            buttonDecoration: kButtonDecoration.copyWith(
              color: kWhite,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: kPrimaryColor.withOpacity(0.5)),
            ),
            onPressed: onAddTraveller,
          ),
        ],
      ),
    );
  }

  static Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: kPrimaryColor.withOpacity(0.2)),
      child: Icon(icon, color: kPrimaryColor, size: 18),
    );
  }
}

// Modal
class AddTravellerModal extends StatelessWidget {
  final List<String> genderList;
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;
  const AddTravellerModal({
    Key? key,
    required this.genderList,
    required this.selectedGender,
    required this.onGenderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      maxChildSize: 1,
      minChildSize: 0.7,
      expand: true,
      builder: (_, controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: controller,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text('Add Details',
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    GestureDetector(
                        onTap: () => finish(context),
                        child:
                            const Icon(FeatherIcons.x, color: kSubTitleColor)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: kDarkWhite,
                        blurRadius: 7,
                        spreadRadius: 2,
                        offset: Offset(0, -2))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lang.S.of(context).selectGenderTitle,
                        style: kTextStyle.copyWith(color: kSubTitleColor)),
                    Wrap(
                      children: genderList.map((g) {
                        return Row(mainAxisSize: MainAxisSize.min, children: [
                          Radio<String>(
                            value: g,
                            groupValue: selectedGender,
                            onChanged: (val) => onGenderChanged(val!),
                          ),
                          Text(g,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold)),
                        ]);
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    _textField(lang.S.of(context).nameTitle,
                        lang.S.of(context).nameHint),
                    const SizedBox(height: 20),
                    _textField(lang.S.of(context).lastNameTitle,
                        lang.S.of(context).lastNameHint),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    ButtonGlobalWithoutIcon(
                      buttontext: 'Done',
                      buttonDecoration: kButtonDecoration.copyWith(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () => finish(context),
                      buttonTextColor: kWhite,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static Widget _textField(String label, String hint) {
    return TextFormField(
      decoration: kInputDecoration.copyWith(
        labelText: label,
        hintText: hint,
        labelStyle: kTextStyle.copyWith(color: kTitleColor),
        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

// ============================= BOOKING DETAILS =============================
class BookingDetailsCard extends StatelessWidget {
  final VoidCallback onEdit;

  const BookingDetailsCard(
      {Key? key,
      required this.onEdit,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Booking details will be sent to',
                  style: kTextStyle.copyWith(
                      color: kTitleColor, fontWeight: FontWeight.bold)),
              const Spacer(),
              GestureDetector(
                  onTap: onEdit,
                  child: const Icon(FeatherIcons.chevronRight,
                      color: kPrimaryColor)),
            ],
          ),
          ListTile(
            leading: _icon(Icons.email),
            title: Text('shaidulilalm@gmail.com)',
                style: kTextStyle.copyWith(color: kSubTitleColor)),
          ),
          ListTile(
            leading: _icon(Icons.phone),
            title: Text('Add Mobile Number-',
                style: kTextStyle.copyWith(color: kPrimaryColor)),
          ),
          const Divider(thickness: 1, color: kBorderColorTextField),

        ],
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
class BookingModal extends StatelessWidget {
  const BookingModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 1.0,
      minChildSize: 0.55,
      expand: false,
      builder: (_, controller) {
        return SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(lang.S.of(context).contactInfoTitle,
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    GestureDetector(
                        onTap: () => finish(context),
                        child:
                            const Icon(FeatherIcons.x, color: kSubTitleColor)),
                  ],
                ),
                const SizedBox(height: 20),
                _textField(lang.S.of(context).emailHint),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: kInputDecoration.copyWith(
                    hintText: lang.S.of(context).phoneHint,
                    hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                    border: const OutlineInputBorder(),
                    prefixIcon: const CountryCodePicker(
                      onChanged: print,
                      initialSelection: 'BD',
                      showFlag: true,
                      showDropDownButton: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ButtonGlobalWithoutIcon(
                  buttontext: lang.S.of(context).confirm,
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onPressed: () => finish(context),
                  buttonTextColor: kWhite,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _textField(String label) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: kInputDecoration.copyWith(
        labelText: label,
        hintText: label,
        border: const OutlineInputBorder(),
        labelStyle: kTextStyle.copyWith(color: kTitleColor),
        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
      ),
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
