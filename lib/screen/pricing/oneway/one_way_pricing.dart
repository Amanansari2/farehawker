import 'package:flightbooking/providers/fare_rule_provider.dart';
import 'package:flightbooking/providers/seat_map_provider.dart';
import 'package:flightbooking/routes/route_generator.dart';
import 'package:flightbooking/screen/pricing/oneway/one_way_baggage.dart';
import 'package:flightbooking/screen/pricing/oneway/one_way_meal.dart';
import 'package:flightbooking/screen/pricing/oneway/one_way_other_service.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flightbooking/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../api_services/app_logger.dart';
import '../../../models/flight_details_model.dart';
import '../../../providers/pricing_request _provider.dart';
import '../../../providers/search_flight_provider.dart';
import 'package:intl/intl.dart';

import '../../../widgets/button_global.dart';


class PricingTabView extends StatefulWidget {
  final FlightDetail flight;
  const PricingTabView({Key? key, required this.flight}) : super(key: key);

  @override
  State<PricingTabView> createState() => _PricingTabViewState();
}

class _PricingTabViewState extends State<PricingTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _mealSelected = false;
  bool _baggageSelected = false;
  bool _otherSelected = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: kBlueColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: kWhite,
        labelStyle: kTextStyle.copyWith(color: Colors.white),
        unselectedLabelColor: kWhite,
        indicatorColor: kPrimaryColor,
        indicator:
        const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          shape: BoxShape.rectangle,
          color: kPrimaryColor,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Meals'),
          Tab(text: 'Baggage'),
          Tab(text: 'Other Services'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchFlightProvider>();
    final provider = Provider.of<PricingProvider>(context);
    final seatMapProvider = context.watch<SeatMapProvider>();


    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error!}'));
    }
    final options = provider.flightOptions;
    if (options == null) {
      return const Center(child: Text('No pricing data available'));
    }

    final meals = options.meals;
    final baggage = options.baggs;
    final otherServices = options.otherServices;
    final bool showContinue = _mealSelected || _baggageSelected || _otherSelected;


    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: kWhite),
        backgroundColor: kBlueColor,
        title:  ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          horizontalTitleGap: 00.0,
          contentPadding: const EdgeInsets.only(right: 15.0),
          title: Text(
            'Pricing Details',
            style: kTextStyle.copyWith(
              color: kWhite,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          subtitle: Text(
            '${searchProvider.fromCity?.city ?? ''} - ${searchProvider.toCity?.city ?? ''} | ${DateFormat('EEE d MMM').format(searchProvider.selectedDate)} | ${searchProvider.adultCount} Adult, ${searchProvider.childCount} Child, ${searchProvider.infantCount} Infant',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(color: kWhite),
          ),
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTabs().paddingOnly(left: 10, right: 10, top: 5),
          const Divider(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Meals Tab
                meals.isEmpty
                    ? const Center(child: Text('No meals available'))
                    : MealListView(
                    meals: meals,
                  onSelectionChanged: (any) {
                    if (!mounted) return;
                    setState(() => _mealSelected = any);
                  },
                ),
                // Baggage Tab
                baggage.isEmpty
                    ? const Center(child: Text('No baggage options'))
                    : BaggageListView(
                    baggage: baggage,
                  onSelectionChanged: (any) {
                    if (!mounted) return;
                    setState(() => _baggageSelected = any);
                  },
                ),
                // Other Services Tab
                otherServices.isEmpty
                    ? const Center(child: Text('No other services'))
                    : OtherServiceListView(
                    otherService: otherServices,
                  onSelectionChanged: (any) {
                    if (!mounted) return;
                    setState(() => _otherSelected = any);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),

          Padding( padding: const EdgeInsets.all(16),
            child: ButtonGlobalWithoutIcon(
                buttontext: seatMapProvider.loading ? 'Please wait...' :(showContinue ? 'Continue' : 'Skip'),
                buttonDecoration: kButtonDecoration.copyWith(
                    color: showContinue? kPrimaryColor : kSubTitleColor,
                    borderRadius: BorderRadius.circular(30)
                ),
                onPressed:seatMapProvider.loading ? null : () async {
                  final bookingProvider = context.read<BookProceedProvider>();

                  if (showContinue) {
                    AppLogger.log(' - Continue pressed');

                    seatMapProvider.clearSelectedSeats();

                    await seatMapProvider.fetchSeatMap(
                        flight: widget.flight,
                        travellers: bookingProvider.travellers,
                        pricingFlightIds:provider.latestFlightIds ,
                      pricingTrackId:provider.latestTrackId
                    );
                    if (!context.mounted) {
                      AppLogger.log('Context not mounted -> cannot show dialog');
                      return;
                    }

                    final err = seatMapProvider.error?.trim();
                    AppLogger.log('seatMapProvider.error(after)= "$err"');

                    Navigator.pushNamed(context, AppRoutes.seatMap, arguments: widget.flight);

                    // if(err != null && err.isNotEmpty){
                    //  await showDialog(
                    //       context: context,
                    //       builder: (BuildContext context){
                    //         return CustomDialogBox(
                    //           title: "Error",
                    //           descriptions: err,
                    //           text: "Close",
                    //           titleColor: kRedColor,
                    //           img: 'images/dialog_error.png',
                    //           functionCall: () {
                    //             Navigator.of(context).pop(); // close dialog
                    //           },
                    //         );
                    //       });
                    // }else{
                    //   AppLogger.log("Data fetched");
                    //   Navigator.pushNamed(context, AppRoutes.seatMap, arguments: widget.flight);
                    // }

                  } else {
                    AppLogger.log('- Skip pressed');
                    seatMapProvider.clearSelectedSeats();
                    await seatMapProvider.fetchSeatMap(
                        flight: widget.flight,
                        travellers: bookingProvider.travellers,
                        pricingFlightIds:provider.latestFlightIds,
                        pricingTrackId:provider.latestTrackId
                    );
                    if (!context.mounted) {
                      AppLogger.log('Context not mounted -> cannot show dialog');
                      return;
                    }
                    final err = seatMapProvider.error?.trim();
                    AppLogger.log('seatMapProvider.error(after)= "$err"');

                    Navigator.pushNamed(context, AppRoutes.seatMap, arguments: widget.flight);

                   //  if(err != null && err.isNotEmpty){
                   // await   showDialog(
                   //        context: context,
                   //        builder: (BuildContext context){
                   //          return CustomDialogBox(
                   //            title: "Error",
                   //            descriptions: err,
                   //            text: "Close",
                   //            titleColor: kRedColor,
                   //            img: 'images/dialog_error.png',
                   //            functionCall: () {
                   //              Navigator.of(context).pop(); // close dialog
                   //            },
                   //          );
                   //        });
                   //  }else{
                   //    AppLogger.log("Data fetched");
                   //    Navigator.pushNamed(context, AppRoutes.seatMap, arguments: widget.flight);
                   //
                   //  }
                  }
                },
                buttonTextColor: kWhite),)
        ],
      ),
    );
  }
}



