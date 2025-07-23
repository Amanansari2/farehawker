import 'package:flightbooking/api_services/configs/app_configs.dart';
import 'package:flightbooking/routes/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../models/airline_list_model.dart';
import '../../models/flight_details_model.dart';
import '../../providers/country_provider.dart';
import '../../providers/filter_provider.dart';
import '../../providers/search_flight_provider.dart';
import '../../shimmers/search_result_shimmer.dart';
import '../../widgets/constant.dart';
import 'filter.dart';
import 'flight_details.dart';
import 'package:intl/intl.dart';

class SearchResult extends StatefulWidget {

  const SearchResult({Key? key,}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<String> filterTitleList = [
    'Filter',
    'Non Stop',
    'Up to 1 Stop',
    'All Available',
  ];




  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {

    final provider = context.read<SearchFlightProvider>();
    final filterProvider = context.read<FilterProvider>();
    final countryProvider = context.read<CountryProvider>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !provider.isLoadingMore &&
        provider.hasMore) {
      provider.searchFlight(filterProvider: filterProvider,countryProvider:countryProvider,loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchFlightProvider>();
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: kBlueColor,
        iconTheme: const IconThemeData(color: kWhite),
        title: ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          horizontalTitleGap: 00.0,
          contentPadding: const EdgeInsets.only(right: 15.0),
          title: Text(
            '${provider.fromCity?.city ?? ''} - ${provider.toCity?.city ?? ''}',
            style: kTextStyle.copyWith(
              color: kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${DateFormat('EEE d MMM').format(provider.selectedDate)} | ${provider.adultCount} Adult, ${provider.childCount} Child, ${provider.infantCount} Infant',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(color: kWhite),
          ),
        ),
      ),
      body: provider.isLoading && provider.onwardFlights.isEmpty
          ?  ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 10,
        itemBuilder: (_, __) => const ShimmerSearchResultFlightCard(),
      )
          : Column(
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
           return   GestureDetector(
                onTap: () async  {


                  if(i == 0){
                    Navigator.pushNamed(context, AppRoutes.filter);
                    return;
                  }

                  String mappedValue;

                  if(filterTitleList[i] == 'Non Stop'){
                    mappedValue = 'nonStop';
                  }else if(filterTitleList[i] == 'Up to 1 Stop') {
                    mappedValue = 'oneStop';
                  } else{
                    mappedValue = 'all';
                  }

                  context.read<FilterProvider>().selectStopOption(mappedValue);
                  final filterProvider = context.read<FilterProvider>();

                  final stopOptionsForApi = mappedValue == 'all' ? null : mappedValue;
                  final departureTime = filterProvider.selectedDepartureTime;
                  final selectedAirlines = filterProvider.selectedAirlines.isNotEmpty
                      ? filterProvider.selectedAirlines.join(',')
                      : null;
                  final refundableOption = filterProvider.selectedRefundableOptions;
                  final classOptions = filterProvider.selectedClassOptions;


                  final searchProvider = context.read<SearchFlightProvider>();
                  final countryProvider = context.read<CountryProvider>();


                  await searchProvider.searchFlight(
                      filterProvider: filterProvider,
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

          /// Flight list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: provider.onwardFlights.length + (provider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.onwardFlights.length) {
                  return const ShimmerSearchResultFlightCard();
                }

                return _buildFlightCard(
                  provider.onwardFlights[index],
                  fromCity: provider.fromCity?.city ?? '',
                  toCity: provider.toCity?.city ?? '',
                );

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(FlightDetail flight, {bool isReturn = false, required String fromCity,
    required String toCity,}) {
    final countryProvider = context.watch<CountryProvider>();
    final airlineCode = flight.airlineCode;
    final airline = countryProvider.airlines.firstWhere(
          (a) => a.code.toUpperCase() == airlineCode.toUpperCase(),
      orElse: () => Airline(name: airlineCode, code: airlineCode, logo: ''),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: kWhite,
            // border: Border.all(color: kTitleColor),
            boxShadow: [
              BoxShadow(
                color: kTitleColor.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,

              )
            ]
        ),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 15,
                // backgroundImage: AssetImage('images/indigo.png'),
                backgroundImage: airline.logo.isNotEmpty
                    ? NetworkImage('${AppConfigs.mediaUrl}${airline.logo}')
                    : const AssetImage('images/indigo.png') as ImageProvider,
              ),
              title: Text(
                airline.name,
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '$currencySign${flight.fare}',
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const Divider(thickness: 1, color: kBorderColorTextField),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.flightDetails, arguments: flight);
              },
              child: Column(
                children: [
                  ListTile(
                    title: Text(flight.flightNumber, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.swap_horiz, color: kPrimaryColor),
                        const SizedBox(width: 5.0),
                        Text(
                          "${flight.journeyTime} -- In Flight",
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
                              style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12)),
                          Text(flight.arrival,
                              style: kTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),

                        ],
                      ),
                      Column(
                        children: [
                          Text(
                              flight.journeyTime,
                              style: kTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text("${flight.stops} Stop",
                              style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(isReturn ? fromCity : toCity,
                              style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12)),
                          Text(flight.departure,
                              style: kTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),

                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

