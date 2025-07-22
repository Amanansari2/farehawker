import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/screen/search/round_trip_flight_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../api_services/configs/app_configs.dart';
import '../../models/airline_list_model.dart';
import '../../models/flight_details_model.dart';
import '../../providers/country_provider.dart';
import '../../providers/filter_provider.dart';
import '../../providers/search_flight_provider.dart';
import '../../shimmers/search_result_shimmer.dart';
import '../../widgets/constant.dart';
import 'filter.dart';

class RoundTripSearchResult extends StatefulWidget {
  const RoundTripSearchResult({Key? key}) : super(key: key);

  @override
  State<RoundTripSearchResult> createState() => _RoundTripSearchResultState();
}

class _RoundTripSearchResultState extends State<RoundTripSearchResult>
    with TickerProviderStateMixin {
  late final ScrollController _onwardScrollController;
  late final ScrollController _returnScrollController;

  FlightDetail? selectedOnwardFlight;
  FlightDetail? selectedReturnFlight;

  List<String> filterTitleList = [
    'Filter',
    'Non Stop',
    'Up to 1 Stop',
    'All Available',
  ];


  @override
  void initState() {
    super.initState();
    _onwardScrollController = ScrollController()
      ..addListener(_onwardScrollListener);
    _returnScrollController = ScrollController()
      ..addListener(_returnScrollListener);

    Future.microtask(() {
      context.read<SearchFlightProvider>().searchRoundTripFlight(
        filterProvider: context.read<FilterProvider>(),
        countryProvider: context.read<CountryProvider>(),
        initialLoad: true,
      );
    });
  }

  void _onwardScrollListener() {
    final provider = context.read<SearchFlightProvider>();
    final filterProvider = context.read<FilterProvider>();
    final countryProvider = context.read<CountryProvider>();
    if (_onwardScrollController.position.pixels >=
            _onwardScrollController.position.maxScrollExtent - 200 &&
        !provider.isLoadingMore &&
        provider.hasMore) {
      provider.searchRoundTripFlight(
          filterProvider: filterProvider,
          countryProvider: countryProvider,
          loadMoreOnward: true);
    }
  }

  void _returnScrollListener() {
    final provider = context.read<SearchFlightProvider>();
    final filterProvider = context.read<FilterProvider>();
    final countryProvider = context.read<CountryProvider>();
    if (_returnScrollController.position.pixels >=
            _returnScrollController.position.maxScrollExtent - 200 &&
        !provider.returnIsLoadingMore &&
        provider.returnHasMore) {
      provider.searchRoundTripFlight(
          filterProvider: filterProvider,
          countryProvider: countryProvider,
          loadMoreReturn: true);
    }
  }

  @override
  void dispose() {
    _onwardScrollController.dispose();
    _returnScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchFlightProvider>();
    final isApplyEnabled =
        selectedOnwardFlight != null && selectedReturnFlight != null;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: kBlueColor,
            iconTheme: const IconThemeData(color: kWhite),
            title: ListTile(
              dense: true,
              visualDensity: const VisualDensity(vertical: -2),
              horizontalTitleGap: 0.0,
              contentPadding: const EdgeInsets.only(right: 15.0),
              title: Text(
                '${provider.fromCity?.city ?? ''} - ${provider.toCity?.city ?? ''}',
                style: kTextStyle.copyWith(
                    color: kWhite, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${DateFormat('EEE d MMM').format(provider.selectedDate)} | ${provider.adultCount} Adult, ${provider.childCount} Child, ${provider.infantCount} Infant',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: kTextStyle.copyWith(color: kWhite),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF0FF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TabBar(
                  indicator: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: kWhite,
                  unselectedLabelColor: kBlueColor,
                  tabs: [
                    Tab(text: 'Onward'),
                    Tab(text: 'Return'),
                  ],
                ),
              ),
            )),
        body: provider.isLoading && provider.onwardFlights.isEmpty && provider.returnFlights.isEmpty
        ?  ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: 10,
          itemBuilder: (_, __) => const ShimmerSearchResultFlightCard(),
        )
        :Column(
          children: [
            const SizedBox(height: 10),
            HorizontalList(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: filterTitleList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, i) {

                final filterProvider = context.watch<FilterProvider>();

                final bool isSelected = (){
                  switch (filterTitleList[i]){
                    case 'Non Stop':
                      return filterProvider.selectedStopOption == 'nonStop';
                    case 'Up to 1 Stop':
                      return filterProvider.selectedStopOption == 'oneStop';
                    case 'All Available':
                      return filterProvider.selectedStopOption == 'all';
                    default:
                      return false;
                  }
                }();

               return  GestureDetector(
                  onTap: ()async  {



                    if(i == 0){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const Filter()));
                      return;
                    }

                    String mappedValue;

                    if(filterTitleList[i] == 'Non Stop'){
                      mappedValue = 'nonStop';
                    } else if(filterTitleList[i] == 'Up to 1 Stop'){
                      mappedValue = 'oneStop';
                    }else{
                      mappedValue = 'all';
                    }

                    context.read<FilterProvider>().selectStopOption(mappedValue);

                    final stopOptionsForApi = mappedValue == 'all' ? null : mappedValue;
                    final departureTime = filterProvider.selectedDepartureTime;
                    final selectedAirlines = filterProvider.selectedAirlines.isNotEmpty
                        ? filterProvider.selectedAirlines.join(',')
                        : null;
                    final refundableOption = filterProvider.selectedRefundableOptions;
                    final classOptions = filterProvider.selectedClassOptions;

                    final searchProvider = context.read<SearchFlightProvider>();
                    final countryProvider = context.read<CountryProvider>();

                    await searchProvider.searchRoundTripFlight(
                        filterProvider: context.read<FilterProvider>(),
                        countryProvider: countryProvider,
                      stopOption: stopOptionsForApi,
                      departureTime: departureTime,
                      selectedAirlines: selectedAirlines,
                      refundableOption: refundableOption,
                      classOptions: classOptions,
                    );

                  },
                  child: Container(
                    height: 35,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? kPrimaryColor.withOpacity(0.1)
                          : kWhite,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: kBorderColorTextField),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sort, color: kSubTitleColor)
                            .visible(i == 0),
                        const SizedBox(width: 5).visible(i == 0),
                        Text(filterTitleList[i],
                            style: kTextStyle.copyWith(color: kSubTitleColor)),
                      ],
                    ),
                  ),
                );

              }
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                children: [
                  _buildFlightList(
                    flights: provider.onwardFlights,
                    isLoadingMore: provider.isLoadingMore,
                    controller: _onwardScrollController,
                    fromCity: provider.fromCity?.city ?? '',
                    toCity: provider.toCity?.city ?? '',
                    isReturn: false,
                    isOnwardTab: true,
                  ),
                  _buildFlightList(
                    flights: provider.returnFlights,
                    isLoadingMore: provider.returnIsLoadingMore,
                    controller: _returnScrollController,
                    fromCity: provider.toCity?.city ?? '',
                    toCity: provider.fromCity?.city ?? '',
                    isReturn: true,
                    isOnwardTab: false,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: isApplyEnabled
            ? SafeArea(
                child: Container(
                color: kWhite,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RoundTripFlightDetails(
                                  flight: selectedOnwardFlight!,
                                  returnFlight: selectedReturnFlight!,
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ))
            : null,
      ),
    );
  }

  Widget _buildFlightList({
    required List<FlightDetail> flights,
    required bool isLoadingMore,
    required ScrollController controller,
    required String fromCity,
    required String toCity,
    required bool isReturn,
    required bool isOnwardTab,
  }) {
    AppLogger.log("📋 Building list: ${flights.length} flights");
    return ListView.builder(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      itemCount: flights.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == flights.length) {
          return const ShimmerSearchResultFlightCard();
        }
        AppLogger.log(" Building card for ${flights[index].flightNumber}");
        return _buildFlightCard(
          flights[index],
          fromCity: fromCity,
          toCity: toCity,
          isReturn: isReturn,
          isOnwardTab: isOnwardTab,
        );
      },
    );
  }    

  Widget _buildFlightCard(
    FlightDetail flight, {
    required String fromCity,
    required String toCity,
    required bool isReturn,
    required bool isOnwardTab,
  }) {
    final countryProvider = context.watch<CountryProvider>();
    final airlineCode = flight.airlineCode;
    final airline = countryProvider.airlines.firstWhere(
      (a) => a.code.toUpperCase() == airlineCode.toUpperCase(),
      orElse: () => Airline(name: airlineCode, code: airlineCode, logo: ''),
    );



    final isSelected = isOnwardTab
        ? selectedOnwardFlight == flight
        : selectedReturnFlight == flight;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isOnwardTab) {
              selectedOnwardFlight = flight;
            } else {
              selectedReturnFlight = flight;
            }
          });
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: kWhite,
                boxShadow: [
                  BoxShadow(
                    color: kTitleColor.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: (airline.logo != null && airline.logo!.isNotEmpty)
                            ? NetworkImage(
                                '${AppConfigs.mediaUrl}${airline.logo}')
                            : const AssetImage('images/indigo.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          airline.name,
                          style: kTextStyle.copyWith(
                              color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '$currencySign${flight.fare}',
                        style: kTextStyle.copyWith(
                            color: kTitleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),

                  const Divider(thickness: 1, color: kBorderColorTextField),
                  ListTile(
                    title: Text(
                      flight.flightNumber,
                      style: kTextStyle.copyWith(
                          color: kTitleColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.swap_horiz, color: kPrimaryColor),
                        const SizedBox(width: 5.0),
                        Text(
                           "${flight.journeyTime}  -- In Flight",
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(isReturn ? toCity : fromCity,
                              style: kTextStyle.copyWith(
                                  color: kSubTitleColor, fontSize: 12)),
                          Text(flight.arrival,
                              style: kTextStyle.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(

                              flight.journeyTime,
                              style: kTextStyle.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text("${flight.stops} Stop",
                              style: kTextStyle.copyWith(
                                  color: kSubTitleColor, fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(isReturn ? fromCity : toCity,
                              style: kTextStyle.copyWith(
                                  color: kSubTitleColor, fontSize: 12)),
                          Text(flight.departure,
                              style: kTextStyle.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isOnwardTab) {
                      selectedOnwardFlight = flight;
                    } else {
                      selectedReturnFlight = flight;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? kPrimaryColor : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? kPrimaryColor : Colors.transparent,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
