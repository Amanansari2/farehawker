import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../api_services/configs/app_configs.dart';
import '../../models/airline_list_model.dart';
import '../../models/airport_list_model.dart';
import '../../models/flight_details_model.dart';
import '../../providers/country_provider.dart';
import '../../providers/fare_rule_provider.dart';
import '../../providers/search_flight_provider.dart';
import '../../routes/route_generator.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/custom_dialog.dart';
import '../book proceed/book_proceed.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;


class RoundTripFlightDetails extends StatefulWidget {
  final FlightDetail flight;
  final FlightDetail? returnFlight;
  const RoundTripFlightDetails({required this.flight,  this.returnFlight, Key? key}) : super(key: key);

  @override
  State<RoundTripFlightDetails> createState() => _FlightDetailsState();
}

class _FlightDetailsState extends State<RoundTripFlightDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Duration calculateLayover(String arrivalDateTime, String nextDepartureDateTime) {
    try {
      final format =
      DateFormat("dd MMM yyyy HH:mm"); // matches "24 Jul 2025 20:05"
      final arrDate = format.parse(arrivalDateTime);
      final depDate = format.parse(nextDepartureDateTime);
      return depDate.difference(arrDate);
    } catch (e) {
      debugPrint("Error parsing layover times: $e");
      return Duration.zero;
    }
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchFlightProvider>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlueColor,
        bottomNavigationBar: _buildBottomBar(),
        body: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Container(
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                _buildTabs(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: _buildFlightDetailCard(provider, widget.flight),
                      ),
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: widget.returnFlight != null
                            ? _buildFlightDetailCard(provider, widget.returnFlight!)
                            : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'No return flight details available',
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Text(
            lang.S.of(context).flightDetails,
            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              FeatherIcons.x,
              color: kSubTitleColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.grey.shade100,
      child: TabBar(
        controller: _tabController,
        labelColor: kPrimaryColor,
        unselectedLabelColor: kSubTitleColor,
        indicatorColor: kPrimaryColor,
        tabs: const [
          Tab(text: 'Onwards'),
          Tab(text: 'Return'),
        ],
      ),
    );
  }

  Widget _buildFlightDetailCard(SearchFlightProvider provider, FlightDetail flight) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: kDarkWhite,
            spreadRadius: 2,
            blurRadius: 7.0,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 0, thickness: 1.0, color: kBorderColorTextField),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _buildRouteHeader(provider, flight),
                Divider(height: 0, thickness: 1.0, color: kPrimaryColor.withOpacity(0.2)),
                _buildFlightSegments(flight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteHeader(SearchFlightProvider provider, FlightDetail flight) {
    return Container(
      width: context.width(),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        border: Border.all(color: kSecondaryColor),
      ),
      child: Column(
        children: [
          Text(
            '${provider.fromCity?.city ?? ''} - ${provider.toCity?.city ?? ''}',
            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
          ),
          Text(
            "${flight.stops} Stop | ${flight.journeyTime} | ${flight.cabinClass}",
            style: kTextStyle.copyWith(color: kSubTitleColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightSegments(FlightDetail flight) {
    final countryProvider = context.read<CountryProvider>();


    return Container(
      width: context.width(),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
        border: Border.all(color: kSecondaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAirlineTile(flight),
          const SizedBox(height: 20),
          for (int i = 0; i < flight.stopovers.length; i++) ...[
            if (i > 0) ...[
              _buildLayoverInfo(
                flight.stopovers[i].cityOrigin.isNotEmpty
                    ? flight.stopovers[i].cityOrigin
                    : flight.stopovers[i].departure,
               flight.stopovers[i - 1].arrivalTime,
               flight.stopovers[i].departureTime,
              ),
              const SizedBox(height: 10),
            ],
            Builder(builder: (_) {
              final stop = flight.stopovers[i];
              final depFromApiCity = stop.cityOrigin;
              final depFromApiName = stop.airportNameOrigin;

              final depAirport = countryProvider.airport.firstWhere(
                    (a) => a.code.toUpperCase() == stop.departure.toUpperCase(),
                orElse: () => Airport(
                  code: stop.departure,
                  name: stop.departure,
                  logo: '',
                  city: stop.departure,
                ),
              );
              final depCity = depFromApiCity.isNotEmpty
                  ? depFromApiCity
                  : (depAirport.city.isNotEmpty
                  ? depAirport.city
                  : stop.departure);

              final depName = depFromApiName.isNotEmpty
                  ? depFromApiName
                  : (depAirport.name.isNotEmpty
                  ? depAirport.name
                  : stop.departure);

              final arrFromApiCity = stop.cityDestination;
              final arrFromApiName = stop.airportNameDestination;

              final arrAirport = countryProvider.airport.firstWhere(
                    (a) => a.code.toUpperCase() == stop.arrival.toUpperCase(),
                orElse: () => Airport(
                  code: stop.arrival,
                  name: stop.arrival,
                  logo: '',
                  city: stop.arrival,
                ),
              );

              final arrCity = arrFromApiCity.isNotEmpty
                  ? arrFromApiCity
                  : (arrAirport.city.isNotEmpty
                  ? arrAirport.city
                  : stop.arrival);

              final arrName = arrFromApiName.isNotEmpty
                  ? arrFromApiName
                  : (arrAirport.name.isNotEmpty
                  ? arrAirport.name
                  : stop.arrival);

              return _buildTimelineSegment(
                  time: stop.departureTime,
                  location: depCity.isNotEmpty ? depCity : stop.departure,
                  airport: '${stop.departure} -- $depName',
                  terminal: stop.terminalOrigin.isNotEmpty
                      ? "Terminal -- ${stop.terminalOrigin}"
                      : "",
                  arrivalTime: stop.arrivalTime,
                  arrivalLocation: arrCity.isNotEmpty ? arrCity : stop.arrival,
                  arrivalAirport: '${stop.arrival} -- $arrName',
                  arrivalTerminal: stop.terminalDestination.isNotEmpty
                      ? "Terminal -- ${stop.terminalDestination}"
                      : "");
            }),
            const SizedBox(height: 20),
          ],

        ],
      ),
    );
  }

  Widget _buildAirlineTile(FlightDetail flight) {
    final countryProvider = context.read<CountryProvider>();
    final airline = countryProvider.airlines.firstWhere(
          (a) => a.code.toUpperCase() == flight.airlineCode.toUpperCase(),
      orElse: () => Airline(name: flight.airlineCode, code: flight.airlineCode, logo: ''),
    );
    final logo = airline.logo.isNotEmpty
        ? NetworkImage('${AppConfigs.mediaUrl}${airline.logo}')
        : const AssetImage('images/indigo.png') as ImageProvider;

    return ListTile(
      dense: true,
      horizontalTitleGap: 10,
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      leading: CircleAvatar(
        radius: 17,
        backgroundImage: logo,
      ),
      title: Text(
        airline.name,
        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${flight.journeyTime} in flight',
        style: kTextStyle.copyWith(color: kSubTitleColor),
      ),
    );
  }

  Widget _buildLayoverInfo( String layoverCity, String arrivalTime, String nextDepartureTime) {
    final diff = calculateLayover(arrivalTime, nextDepartureTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3E7EA),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: ListTile(
        dense: true,
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        leading: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(color: Colors.transparent),
          child: const Icon(Icons.directions_walk_outlined, color: kSubTitleColor),
        ),
        title: Text(
          'Layover in $layoverCity',
          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            '${hours.toString().padLeft(2, '0')} h ${minutes.toString().padLeft(2, '0')} m',
          style: kTextStyle.copyWith(color: kSubTitleColor),
        ),
      ),
    );
  }



  Widget _buildTimelineSegment({
    required String time,
    required String location,
    required String airport,
    required String terminal,
    required String arrivalTime,
    required String arrivalLocation,
    required String arrivalAirport,
    required String arrivalTerminal,

  }) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 100.0,
                  width: 2,
                  decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.5)),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 1.0, bottom: 5),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Icon(Icons.flight, color: kPrimaryColor),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Container(
                height: 15.0,
                width: 15.0,
                decoration: BoxDecoration(
                  color: kWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: kPrimaryColor.withOpacity(0.5), width: 3),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 25.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$time - $location',
              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 265,
              child: Text(
                airport,
                maxLines: 2,
                style: kTextStyle.copyWith(color: kSubTitleColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 265,
              child: Text(
                terminal,
                maxLines: 2,
                style: kTextStyle.copyWith(color: kSubTitleColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 25.0),
            Text(
              '$arrivalTime - $arrivalLocation',
              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 265,
              child: Text(
                arrivalAirport,
                maxLines: 2,
                style: kTextStyle.copyWith(color: kSubTitleColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 265,
              child: Text(
                arrivalTerminal,
                maxLines: 2,
                style: kTextStyle.copyWith(color: kSubTitleColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final totalFare = (widget.flight.fare ?? 0) + (widget.returnFlight?.fare ?? 0);
    return Container(
      decoration: const BoxDecoration(color: kWhite),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
        visualDensity: const VisualDensity(vertical: 2),
        title: Text(
          'Total Price',
          style: kTextStyle.copyWith(color: kSubTitleColor),
        ),
        subtitle: Text(
          ' $currencySign$totalFare',
          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          height: 80,
          width: 200,
          child: Consumer<BookProceedProvider>(
            builder: (context, fareProvider, _) {
              return ButtonGlobalWithoutIcon(
                buttontext: fareProvider.isLoading ? "Please wait..." :'Proceed to Book',
                buttonDecoration: kButtonDecoration.copyWith(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: fareProvider.isLoading
                ? null
                  : () async {
                  await fareProvider.loadFareRulesForRoundTrip(
                    onwardFlight: widget.flight,
                    returnFlight: widget.returnFlight!,
                  );

                  if (fareProvider.error != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: "Error",
                          descriptions: fareProvider.error,
                          text: "Close",
                          titleColor: kRedColor,
                          img: 'images/dialog_error.png',
                          functionCall: () {
                            Navigator.of(context).pop(); // close dialog
                          },
                        );
                      },
                    );
                  } else {
                    // ✅ success → navigate
                    Navigator.pushNamed(
                      context,
                      AppRoutes.roundTripBookProceed,
                      arguments: {
                        'onwardFlight': widget.flight,
                        'returnFlight': widget.returnFlight
                      },
                    );
                  }
                },

                buttonTextColor: kWhite,
              );
            }
          ),
        ),
      ),
    );
  }
}
