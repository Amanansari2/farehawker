import 'dart:convert';

import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/models/flight_details_model.dart';
import 'package:flightbooking/routes/route_generator.dart';
import 'package:flightbooking/screen/pricing/oneway/one_way_baggage.dart';
import 'package:flightbooking/screen/pricing/oneway/one_way_meal.dart';
import 'package:flightbooking/screen/pricing/oneway/one_way_other_service.dart';
import 'package:flightbooking/widgets/button_global.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flightbooking/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../models/pricing_rules_model/pricing_response_model.dart';
import '../../../providers/fare_rule_provider.dart';
import '../../../providers/pricing_request _provider.dart';
import '../../../providers/search_flight_provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/seat_map_provider.dart';

class RoundTripPricingTabView extends StatefulWidget {
  final FlightDetail onwardFlight;
  final FlightDetail returnFlight;
  const RoundTripPricingTabView(
      {Key? key, required this.onwardFlight, required this.returnFlight})
      : super(key: key);

  @override
  State<RoundTripPricingTabView> createState() =>
      _RoundTripPricingTabViewState();
}

class _RoundTripPricingTabViewState extends State<RoundTripPricingTabView>
    with SingleTickerProviderStateMixin {
  late TabController _topTabController;

  bool _onwardAnySelected = false;
  bool _returnAnySelected = false;

  @override
  void initState() {
    super.initState();
    _topTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _topTabController.dispose();
    super.dispose();
  }

  Widget _buildTopTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: kSubTitleColor,
      ),
      child: TabBar(
        controller: _topTabController,
        labelColor: kWhite,
        labelStyle: kTextStyle.copyWith(color: Colors.white),
        unselectedLabelColor: kWhite,
        indicatorColor: kPrimaryColor,
        indicator: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          shape: BoxShape.rectangle,
          color: kPrimaryColor,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Onward'),
          Tab(text: 'Return'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchFlightProvider>();
    final provider = Provider.of<PricingProvider>(context);
    final seatMapProvider = context.watch<SeatMapProvider>();

    final bool showContinue = _onwardAnySelected || _returnAnySelected;

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: kWhite),
        backgroundColor: kBlueColor,
        title: ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          horizontalTitleGap: 00.0,
          contentPadding: const EdgeInsets.only(right: 15.0),
          title: Text(
            'Round Trip Pricing',
            style: kTextStyle.copyWith(
              color: kWhite,
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
          _buildTopTabs(),
          Expanded(
            child: TabBarView(
              controller: _topTabController,
              children: [
                // ONWARD TAB
                _LegPricingBody(
                    isLoading: provider.isOnwardLoading,
                    error: provider.onwardError,
                    options: provider.onwardOptions,
                    titlePrefix: 'Onward',
                    onAnySelectionChanged: (any) {
                      if (!mounted) return;
                      setState(() => _onwardAnySelected = any);
                    }),
                // RETURN TAB
                _LegPricingBody(
                    isLoading: provider.isReturnLoading,
                    error: provider.returnError,
                    options: provider.returnOptions,
                    titlePrefix: 'Return',
                    onAnySelectionChanged: (any) {
                      if (!mounted) return;
                      setState(() => _returnAnySelected = any);
                    }),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ButtonGlobalWithoutIcon(
                buttontext: (seatMapProvider.isOnwardLoading ||
                        seatMapProvider.isReturnLoading)
                    ? 'Please wait...'
                    : (showContinue ? 'Continue' : 'Skip'),
                buttonDecoration: kButtonDecoration.copyWith(
                    color: showContinue ? kPrimaryColor : kSubTitleColor,
                    borderRadius: BorderRadius.circular(30)),
                onPressed: (seatMapProvider.isOnwardLoading ||
                        seatMapProvider.isReturnLoading)
                    ? null
                    : () async {
                        final bookingProvider =
                            context.read<BookProceedProvider>();

                        if (showContinue) {
                          AppLogger.log(' - Continue pressed');
                          seatMapProvider.clearSelectedSeats();
                          await seatMapProvider.fetchRoundTripSeatMap(
                              onwardFlight: widget.onwardFlight,
                              returnFlight: widget.returnFlight,
                              travellers: bookingProvider.travellers,
                              onwardFlightIds: provider.onwardFlightIds,
                              onwardTrackId: provider.onwardLatestTrackId,
                              returnFlightIds: provider.returnFlightIds,
                              returnTrackId: provider.returnLatestTrackId);

                          if (!context.mounted) {
                            AppLogger.log(
                                'Context not mounted -> cannot show dialog');
                            return;
                          }
                          final onwardErr = seatMapProvider.onwardError?.trim();
                          final returnErr = seatMapProvider.returnError?.trim();
                          AppLogger.log(
                              'seatMapProvider.error(after)= "$onwardErr"');
                          AppLogger.log(
                              'seatMapProvider.error(after)= "$returnErr"');

                          String combinedError = '';

                          if (onwardErr != null && onwardErr.isNotEmpty) {
                            combinedError += 'Onward: $onwardErr\n';
                          }
                          if (returnErr != null && returnErr.isNotEmpty) {
                            combinedError += 'Return: $returnErr\n';
                          }

                          Navigator.pushNamed(
                              context, AppRoutes.roundTripSeatMap, arguments: {
                            'onwardFlight': widget.onwardFlight,
                            'returnFlight': widget.returnFlight,
                          });
                          // if (combinedError.isNotEmpty) {
                          //   await showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) {
                          //         return CustomDialogBox(
                          //           title: "Error",
                          //           descriptions: combinedError.trim(),
                          //           text: "Close",
                          //           titleColor: kRedColor,
                          //           img: 'images/dialog_error.png',
                          //           functionCall: () {
                          //             Navigator.of(context)
                          //                 .pop(); // close dialog
                          //           },
                          //         );
                          //       });
                          // } else {
                          //   AppLogger.log("Data fetched");
                          //   Navigator.pushNamed(
                          //       context, AppRoutes.roundTripSeatMap, arguments: {
                          //     'onwardFlight': widget.onwardFlight,
                          //     'returnFlight': widget.returnFlight,
                          //   });
                          // }
                        } else {
                          AppLogger.log('- Skip pressed');
                          seatMapProvider.clearSelectedSeats();
                          await seatMapProvider.fetchRoundTripSeatMap(
                              onwardFlight: widget.onwardFlight,
                              returnFlight: widget.returnFlight,
                              travellers: bookingProvider.travellers,
                              onwardFlightIds: provider.onwardFlightIds,
                              onwardTrackId: provider.onwardLatestTrackId,
                              returnFlightIds: provider.returnFlightIds,
                              returnTrackId: provider.returnLatestTrackId);

                          if (!context.mounted) {
                            AppLogger.log(
                                'Context not mounted -> cannot show dialog');
                            return;
                          }
                          final onwardErr = seatMapProvider.onwardError?.trim();
                          final returnErr = seatMapProvider.returnError?.trim();
                          AppLogger.log(
                              'seatMapProvider.error(after)= "$onwardErr"');
                          AppLogger.log(
                              'seatMapProvider.error(after)= "$returnErr"');

                          String combinedError = '';

                          if (onwardErr != null && onwardErr.isNotEmpty) {
                            combinedError += 'Onward: $onwardErr\n';
                          }
                          if (returnErr != null && returnErr.isNotEmpty) {
                            combinedError += 'Return: $returnErr\n';
                          }

                          Navigator.pushNamed(
                              context, AppRoutes.roundTripSeatMap, arguments: {
                            'onwardFlight': widget.onwardFlight,
                            'returnFlight': widget.returnFlight,
                          });

                          // if (combinedError.isNotEmpty) {
                          //   await showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) {
                          //         return CustomDialogBox(
                          //           title: "Error",
                          //           descriptions: combinedError.trim(),
                          //           text: "Close",
                          //           titleColor: kRedColor,
                          //           img: 'images/dialog_error.png',
                          //           functionCall: () {
                          //             Navigator.of(context)
                          //                 .pop(); // close dialog
                          //           },
                          //         );
                          //       });
                          // } else {
                          //   AppLogger.log("Data fetched");
                          //   Navigator.pushNamed(
                          //       context, AppRoutes.roundTripSeatMap, arguments: {
                          //     'onwardFlight': widget.onwardFlight,
                          //     'returnFlight': widget.returnFlight,
                          //   });
                          // }
                        }
                      },
                buttonTextColor: kWhite),
          )
        ],
      ),
    );
  }
}

class _LegPricingBody extends StatefulWidget {
  final bool isLoading;
  final String? error;
  final FlightOptionsResponse? options;
  final String titlePrefix;
  final ValueChanged<bool> onAnySelectionChanged;

  const _LegPricingBody({
    Key? key,
    required this.isLoading,
    required this.error,
    required this.options,
    required this.titlePrefix,
    required this.onAnySelectionChanged,
  }) : super(key: key);

  @override
  State<_LegPricingBody> createState() => _LegPricingBodyState();
}

class _LegPricingBodyState extends State<_LegPricingBody>
    with SingleTickerProviderStateMixin {
  late TabController _innerTabController;

  bool _mealSelected = false;
  bool _baggageSelected = false;
  bool _serviceSelected = false;

  void _notifyParent() {
    final any = _mealSelected || _baggageSelected || _serviceSelected;
    widget.onAnySelectionChanged(any);
  }

  @override
  void initState() {
    super.initState();
    _innerTabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyParent());
  }

  @override
  void dispose() {
    _innerTabController.dispose();
    super.dispose();
  }

  Widget _buildInnerTabs() {
    return Container(
      decoration: BoxDecoration(
        color: kBlueColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: _innerTabController,
        labelColor: kWhite,
        labelStyle: kTextStyle.copyWith(color: Colors.white),
        unselectedLabelColor: kWhite,
        indicatorColor: kPrimaryColor,
        indicator: const BoxDecoration(
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
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.error != null) {
      return Center(child: Text('Error: ${widget.error!}'));
    }
    final options = widget.options;
    if (options == null) {
      return Center(
          child: Text(
              'No ${widget.titlePrefix.toLowerCase()} pricing data available'));
    }

    final meals = options.meals;
    final baggage = options.baggs;
    final otherServices = options.otherServices;

    return Column(
      children: [
        _buildInnerTabs().paddingOnly(left: 10, right: 10, top: 5),
        // const Divider(),
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: [
              meals.isEmpty
                  ? const Center(child: Text('No meals available'))
                  : MealListView(
                      meals: meals,
                      onSelectionChanged: (any) {
                        _mealSelected = any;
                        _notifyParent();
                        if (mounted) setState(() {});
                      },
                    ),
              baggage.isEmpty
                  ? const Center(child: Text('No baggage options'))
                  : BaggageListView(
                      baggage: baggage,
                      onSelectionChanged: (any) {
                        _baggageSelected = any;
                        _notifyParent();
                        if (mounted) setState(() {});
                      },
                    ),
              otherServices.isEmpty
                  ? const Center(child: Text('No other services'))
                  : OtherServiceListView(
                      otherService: otherServices,
                      onSelectionChanged: (any) {
                        _serviceSelected = any;
                        _notifyParent();
                        if (mounted) setState(() {});
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
