import 'package:country_code_picker/country_code_picker.dart';
import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../models/flight_details_model.dart';
import '../../providers/fare_rule_provider.dart';
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
              TravellerDetailsCard(
                onAddTraveller: () => _showAddTravellerModal(context),
              ),
              PassportDetailsCard(
                onAddPassport:() => _showAddPassportModal(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTravellerModal(BuildContext context) {
    final searchProvider = context.read<SearchFlightProvider>();
    final bookProvider = context.read<BookProceedProvider>();

    final maxTravellers = searchProvider.adultCount +
        searchProvider.childCount +
        searchProvider.infantCount;
    if (bookProvider.travellers.length >= maxTravellers) {
      showDialog(
        context: context,
        builder: (ctx) {
          return CustomDialogBox(
            title: "Limit Reached",
            descriptions: "You can add up to $maxTravellers travellers only.",
            text: "OK",
            img: 'images/dialog_error.png',
            titleColor: Colors.red,
            functionCall: () {
              Navigator.of(ctx).pop(); // dismiss dialog
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
        builder: (_) => const AddTravellerModal());
  }

  void _showAddPassportModal(BuildContext context) {
    final searchProvider = context.read<SearchFlightProvider>();
    final bookProvider = context.read<BookProceedProvider>();

    final maxPassports = searchProvider.adultCount +
        searchProvider.childCount +
        searchProvider.infantCount;
    if (bookProvider.passports.length >= maxPassports) {
      showDialog(
        context: context,
        builder: (ctx) {
          return CustomDialogBox(
            title: "Limit Reached",
            descriptions: "You can add up to $maxPassports passport only.",
            text: "OK",
            img: 'images/dialog_error.png',
            titleColor: Colors.red,
            functionCall: () {
              Navigator.of(ctx).pop(); // dismiss dialog
            },
          );
        },
      );
      return;
    }
    bookProvider.resetPassportForm();
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (_) => const AddPassportModal());
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
              child: ButtonGlobalWithoutIcon(
                buttontext: lang.S.of(context).continueButton,
                buttonDecoration: kButtonDecoration.copyWith(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: ()  async{
                  final bookProvider = context.read<BookProceedProvider>();
                  final searchProvider = context.read<SearchFlightProvider>();
                 try {
                   final response = await bookProvider.submitBookingData(
                       context: context,
                       flight:flight,
                       searchProvider: searchProvider);

                   AppLogger.log("data Submit -->> $response");

                   if(context.mounted){
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (_) => const Payment(),
                       ),
                     );
                   }
                 }catch(e){
                   AppLogger.log("Data Submit failed -->> $e");
                 }
                },
                buttonTextColor: kWhite,
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
  const BaggageModal({
    Key? key,
  }) : super(key: key);

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
                          data: fareProvider.formatFareRulesHtml(
                              fareProvider.fareRulesContent ?? ''),
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
                            "ul": Style(padding: HtmlPaddings.only(left: 16)),
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
    final bookProvider = context.watch<BookProceedProvider>();
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Travelers Details',
              style: kTextStyle.copyWith(
                  color: kTitleColor, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          ...bookProvider.travellers
              .asMap()
              .entries
              .map((entry) {
            final index = entry.key;
            final traveller = entry.value;
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
                      offset: Offset(0, 2))
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.check_box, color: kPrimaryColor),
                title: Text(
                  '${traveller.firstName} ${traveller.lastName}',
                  style: kTextStyle.copyWith(color: kTitleColor),
                ),
                subtitle: Text(
                  '${traveller.gender} | ${DateFormat('dd MMM yyyy').format(
                      traveller.dateOfBirth)}',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    bookProvider.removeTraveller(index);
                  },
                ),
              ),
            );
          }).toList(),
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
}

// Modal
class AddTravellerModal extends StatefulWidget {
  const AddTravellerModal({Key? key}) : super(key: key);

  @override
  State<AddTravellerModal> createState() => _AddTravellerModalState();
}

class _AddTravellerModalState extends State<AddTravellerModal> {
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController();
  }

  @override
  void dispose() {
    _dobController.dispose();
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
                    ButtonGlobalWithoutIcon(
                      buttontext: 'Done',
                      buttonDecoration: kButtonDecoration.copyWith(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () {
                        final searchProvider =
                            context.read<SearchFlightProvider>();
                        final maxTravellers = searchProvider.adultCount +
                            searchProvider.childCount +
                            searchProvider.infantCount;

                        final success = context
                            .read<BookProceedProvider>()
                            .addTraveller(context,
                                maxTravellers: maxTravellers);
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
            title: Text(
                bookProvider.email.isNotEmpty
                    ? bookProvider.email
                    : 'Add Email',
                style: kTextStyle.copyWith(color: kSubTitleColor)),
          ),
          ListTile(
            leading: _icon(Icons.phone),
            title: Text(  bookProvider.phone.isNotEmpty
                ? bookProvider.phone
                : 'Add Mobile Number',
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


// ============================= Passport DETAILS =============================
class PassportDetailsCard extends StatelessWidget {
  final VoidCallback onAddPassport;

  const PassportDetailsCard({Key? key, required this.onAddPassport})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProceedProvider>();
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Passport Details',
              style: kTextStyle.copyWith(
                  color: kTitleColor, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          ...bookProvider.passports
              .asMap()
              .entries
              .map((entry) {
            final index = entry.key;
            final passport = entry.value;
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
                      offset: Offset(0, 2))
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.check_box, color: kPrimaryColor),
                title: Text(
                  passport.passportNumber,
                  style: kTextStyle.copyWith(color: kTitleColor),
                ),
                subtitle: Text(
                 DateFormat('dd MMM yyyy').format(passport.passportExpiry),
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    bookProvider.removePassport(index);
                  },
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 10),
          ButtonGlobalWithIcon(
            buttontext: 'Add Passport Details',
            buttonTextColor: kPrimaryColor,
            buttonIcon: FeatherIcons.plus,
            buttonDecoration: kButtonDecoration.copyWith(
              color: kWhite,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: kPrimaryColor.withOpacity(0.5)),
            ),
            onPressed: onAddPassport,
          ),
        ],
      ),
    );
  }
}

// Modal
class AddPassportModal extends StatefulWidget {
  const AddPassportModal({Key? key}) : super(key: key);

  @override
  State<AddPassportModal> createState() => _AddPassportModal();
}

class _AddPassportModal extends State<AddPassportModal> {
  late TextEditingController _passportController;

  @override
  void initState() {
    super.initState();
    _passportController = TextEditingController();
  }

  @override
  void dispose() {
    _passportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProceedProvider>();

    if (provider.passportExpiry != null) {
      final formatted = DateFormat('dd MMM yyyy').format(provider.passportExpiry!);
      if (_passportController.text != formatted) {
       _passportController.text = formatted;
      }
    } else {
      if (_passportController.text.isNotEmpty) {
        _passportController.text = '';
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
                      'Add Passports Details',
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
                    const SizedBox(height: 10),
                    _textField("Passport Number",
                        "Passport Number",
                        onChanged: provider.setPassportNumber),
                    const SizedBox(height: 20),
                    _textField(
                      "Passport Expiry",
                      "Select date",
                      controller: _passportController,
                      onChanged: (_) {},
                      suffixIcon: Icons.calendar_today,
                      onIconTap: () async {
                        final today = DateTime.now();
                        final passportPicked = await showDatePicker(
                          context: context,
                          initialDate:
                          provider.passportExpiry ?? today,
                          firstDate: today,
                          lastDate: DateTime(2099),
                        );
                        if (passportPicked != null) {
                          provider.setPassportExpiry(passportPicked);
                          _passportController.text =
                              DateFormat('dd MMM yyyy').format(passportPicked);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonGlobalWithoutIcon(
                      buttontext: 'Done',
                      buttonDecoration: kButtonDecoration.copyWith(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () {
                        final searchProvider =
                        context.read<SearchFlightProvider>();
                        final maxPassports = searchProvider.adultCount +
                            searchProvider.childCount +
                            searchProvider.infantCount;

                        final success = context
                            .read<BookProceedProvider>()
                            .addPassport(context,
                            maxPassports: maxPassports);
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
