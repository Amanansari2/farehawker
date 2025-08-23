import 'package:flightbooking/models/flight_details_model.dart';
import 'package:flightbooking/screen/payment/payment%20method/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:provider/provider.dart';

import '../../api_services/configs/app_configs.dart';
import '../../models/airline_list_model.dart';
import '../../models/airport_list_model.dart';
import '../../models/booking_model/booking_post_model.dart';
import '../../models/pricing_rules_model/pricing_response_model.dart';
import '../../providers/country_provider.dart';
import '../../providers/fare_rule_provider.dart';
import '../../providers/pricing_request _provider.dart';
import '../../providers/search_flight_provider.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/custom_dialog.dart';
import '../home/home.dart';
import '../ticket status/ticket_status.dart';

class Payment extends StatefulWidget {
  final FlightDetail onwardFlight;
  final FlightDetail? returnFlight;

  const Payment({
    Key? key,
    required this.onwardFlight,
    this.returnFlight,
  }) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  double getTotalFare() {
    double fare = widget.onwardFlight.fare ?? 0;
    if (widget.returnFlight != null) {
      fare += widget.returnFlight!.fare ?? 0;
    }
    return fare;
  }

  @override
  Widget build(BuildContext context) {
    final totalFare = getTotalFare();

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: kBlueColor,
        iconTheme: const IconThemeData(color: kWhite),
        centerTitle: true,
        title: Text(
          lang.S.of(context).paymentTitle,
          style: kTextStyle.copyWith(
            color: kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              _buildTripSummary(context, totalFare),
              const SizedBox(height: 20.0),
              _buildFareSummary(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15, bottom: 5),
        child: Container(
          decoration: const BoxDecoration(color: kWhite),
          child:
          Row(
            children: [
              Text(
                ' $currencySign$totalFare',
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                child: ButtonGlobalWithoutIcon(
                  buttontext: lang.S.of(context).continueButton,
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),

                  // onPressed: () async {
                  //   final traceId = widget.onwardFlight.traceID;
                  //   final amount = getTotalFare().toStringAsFixed(2);
                  //
                  //   final result = await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) => PaymentMethod(
                  //         amount: amount,
                  //         orderId: traceId,
                  //       ),
                  //     ),
                  //   );
                  //
                  //   if (result != null && result is Map) {
                  //     final status = result['status'];
                  //
                  //     if (status == 'success') {
                  //       showSuccessPopup(context);
                  //     } else {
                  //       showDialog(
                  //         context: context,
                  //         builder: (_) => CustomDialogBox(
                  //           title: 'Payment Failed',
                  //           descriptions: "",
                  //           text: 'Ok',
                  //           img: 'images/dialog_error.png',
                  //           titleColor: kRedColor,
                  //           functionCall: () => Navigator.of(context).pop(),
                  //         ),
                  //       );
                  //     }
                  //   }
                  // },

                  onPressed: () {
                    showSuccessPopup(context);
                  },

                  buttonTextColor: kWhite,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripSummary(BuildContext context, double totalFare) {

    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: kWhite,
        border: Border.all(
          color: kBorderColorTextField,
        ),
        boxShadow: const [
          BoxShadow(
            color: kBorderColorTextField,
            spreadRadius: 2.0,
            blurRadius: 7.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            minLeadingWidth: 0,
            title: Text(
              'Total Due:$currencySign$totalFare',
              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 14.0),
            ),
            subtitle: Text(
              'Convenience Fee Added',
              style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12.0),
            ),
          ),
          const Divider(height: 1, thickness: 1.0, color: kBorderColorTextField),
          _buildFlightTile(widget.onwardFlight),
          if (widget.returnFlight != null)
            Column(
              children: [
                const Divider(height: 1, thickness: 1.0, color: kBorderColorTextField),
                _buildFlightTile(widget.returnFlight!),

              ],
            ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

    Widget _buildFlightTile(FlightDetail flight) {
    final countryProvider = context.read<CountryProvider>();

    // Airline info
    final airline = countryProvider.airlines.firstWhere(
          (a) => a.code.toUpperCase() == flight.airlineCode.toUpperCase(),
      orElse: () => Airline(name: flight.airlineCode, code: flight.airlineCode, logo: ''),
    );
    final ImageProvider logo = airline.logo.isNotEmpty
        ? NetworkImage('${AppConfigs.mediaUrl}${airline.logo}')
        : const AssetImage('images/indigo.png');

    // Airport info
    final originAirport = countryProvider.airport.firstWhere(
          (a) => a.code.toUpperCase() == (flight.origin ?? '').toUpperCase(),
      orElse: () => Airport(code: flight.origin ?? '', name: flight.origin ?? '', city: '', logo: ''),
    );

    final destinationAirport = countryProvider.airport.firstWhere(
          (a) => a.code.toUpperCase() == (flight.destination ?? '').toUpperCase(),
      orElse: () => Airport(code: flight.destination ?? '', name: flight.destination ?? '', city: '', logo: ''),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Airline name and logo
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: logo, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  airline.name,
                  style: kTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kTitleColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Origin -> Destination
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      originAirport.name,
                      style: kTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTitleColor,
                      ),
                    ),
                    Text(
                      "(${originAirport.code})",
                      style: kTextStyle.copyWith(
                        fontSize: 12,
                        color: kSubTitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.swap_horiz_outlined,
                  color: kPrimaryColor,
                  size: 34,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destinationAirport.name,
                      style: kTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTitleColor,
                      ),
                    ),
                    Text(
                      "(${destinationAirport.code})",
                      style: kTextStyle.copyWith(
                        fontSize: 12,
                        color: kSubTitleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Time details
          Text(
            '${flight.departure} - ${flight.arrival}  |  ${flight.journeyTime}  |  ${flight.stops} Stops',
            style: kTextStyle.copyWith(
              fontSize: 12,
              color: kSubTitleColor,
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildFareSummary() {
    final searchProvider = context.read<SearchFlightProvider>();
    final int adultCount = searchProvider.adultCount;
    final int childCount = searchProvider.childCount;
    final int infantCount = searchProvider.infantCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fare Summary',
          style: kTextStyle.copyWith(
            color: kTitleColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 12.0),

        Text(
          'Onward Journey',
          style: kTextStyle.copyWith(
            color: kTitleColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8.0),

        if (adultCount > 0) ...[
          _fareRow('Adult x $adultCount', widget.onwardFlight.adultFare),
        ],
        if (childCount > 0) ...[
          _fareRow('Child x $childCount', widget.onwardFlight.childFare),
        ],
        if (infantCount > 0) ...[
          _fareRow('Infant x $infantCount', widget.onwardFlight.infantFare),
        ],

        const Divider(height: 24, thickness: 1.0),
        if (widget.returnFlight != null) ...[
          Text(
            'Return Journey',
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8.0),

          if (adultCount > 0) ...[
            _fareRow('Adult x $adultCount', widget.returnFlight!.adultFare),
          ],
          if (childCount > 0) ...[
            _fareRow('Child x $childCount', widget.returnFlight!.childFare),
          ],
          if (infantCount > 0) ...[
            _fareRow('Infant x $infantCount', widget.returnFlight!.infantFare),
          ],

          const Divider(height: 24, thickness: 1.0),


        ],
      ],
    );
  }




  Widget _fareRow(String label, double fare) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Text(
            label,
            style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 14),
          ),
          const Spacer(),
          Text(
            '$currencySign${fare.toStringAsFixed(2)}',
            style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }




  void showSuccessPopup(BuildContext contex) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 118.0,
                  width: 133.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/success.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Payment Succeed!',
                  style: kTextStyle.copyWith(
                    color: kTitleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                Text(
                  'Thank you for purchasing the ticket!',
                  textAlign: TextAlign.center,
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                const SizedBox(height: 10.0),
                ButtonGlobalWithoutIcon(
                  buttontext: 'View Ticket',
                  buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor),
                  onPressed: () {
                    finish(context);
                    const TicketStatus().launch(context);
                  },
                  buttonTextColor: kWhite,
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    finish(context);
                     Home().launch(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FeatherIcons.arrowLeft,
                        color: kSubTitleColor,
                      ),
                      Text(
                        'Back to Home',
                        style: kTextStyle.copyWith(color: kSubTitleColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
