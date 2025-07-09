import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../models/flight_response_model.dart';
import '../../widgets/constant.dart';
import 'filter.dart';
import 'flight_details.dart';
import 'package:intl/intl.dart';


class SearchResult extends StatefulWidget {
  final FlightResponse flightResponse;
  final String fromCity;
  final String toCity;
  final DateTime travelDate;
  final int adultCount;
  final int childCount;
  final int infantCount;

  const SearchResult({
    Key? key,
    required this.flightResponse,
    required this.fromCity,
    required this.toCity,
    required this.travelDate,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<String> filterTitleList = [
    'Filter',
    'Non Stop',
    '1 Stop',
    'Duration',
  ];

  List<String> selectedFilter = [];

  String formatJourneyTime(String minutes) {
    final totalMinutes = int.tryParse(minutes) ?? 0;
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    return '${hours}h ${mins}m';
  }

  String extractTime(String dateTimeStr) {
    try {
      final dt = DateFormat('dd MMM yyyy HH:mm').parse(dateTimeStr);
      return DateFormat('HH:mm').format(dt);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
            '${widget.fromCity} - ${widget.toCity}',
            style: kTextStyle.copyWith(
              color: kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${DateFormat('EEE d MMM').format(widget.travelDate)} | ${widget.adultCount} Adult, ${widget.childCount} Child, ${widget.infantCount} Infant',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(color: kWhite),
          ),

        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: context.width(),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                child: Text(
                  // 'Flight to New Delhi',
                    ' Flights from ${widget.fromCity} to ${widget.toCity}',
                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                ),
              ),
              HorizontalList(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  itemCount: filterTitleList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, i) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter.contains(filterTitleList[i])
                              ? selectedFilter.remove(filterTitleList[i])
                              : selectedFilter.add(
                                  filterTitleList[i],
                                );
                          i == 0 ? Navigator.push(context, MaterialPageRoute(builder: (context) => const Filter())) : null;
                        });
                      },
                      child: Container(
                        height: 35,
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                          color: selectedFilter.contains(filterTitleList[i]) ? kPrimaryColor.withOpacity(0.1) : kWhite,
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                            color: kBorderColorTextField,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.sort,
                              color: kSubTitleColor,
                            ).visible(i == 0),
                            const SizedBox(width: 5.0).visible(i == 0),
                            Text(
                              filterTitleList[i],
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 10.0),
              ListView.builder(
                  itemCount: widget.flightResponse.data.itineraryFlightList.first.items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 15.0),
                  itemBuilder: (_, i) {
                    final item = widget.flightResponse.data.itineraryFlightList.first.items[i];
                    final flight = item.flightDetails.first;
                    final fare = item.fares.first.fareDescription.first;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: kWhite,
                          border: Border.all(color: kBorderColorTextField),
                        ),
                        child: Column(
                          children: [
                            ListTileTheme(
                              contentPadding: const EdgeInsets.all(0),
                              dense: true,
                              horizontalTitleGap: 0.0,
                              minLeadingWidth: 0,
                              child: ListTile(
                                dense: true,
                                horizontalTitleGap: 10.0,
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  height: 20.0,
                                  width: 20.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(image: AssetImage('images/indigo.png'), fit: BoxFit.cover),
                                  ),
                                ),
                                title: Text(
                                  'IndiGo',
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  '$currencySign${fare.grossAmount}',
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 1.0,
                              height: 1,
                              color: kBorderColorTextField,
                            ),
                            const SizedBox(height: 10.0),
                            Material(
                              color: kWhite,
                              elevation: 2.0,
                              shadowColor: kDarkWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(color: kBorderColorTextField),
                              ),
                              child: GestureDetector(
                                onTap: () => const FlightDetails().launch(context),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        dense: true,
                                        horizontalTitleGap: 10.0,
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          flight.flightNumber,
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            const Icon(
                                              Icons.swap_horiz,
                                              color: kPrimaryColor,
                                            ),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              // '2h 35m Layover at new york',
                                                "${formatJourneyTime(flight.journeyTime)}  Layover at  ${widget.toCity}",
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
                                              Text(
                                                extractTime(flight.arrivalDateTime),
                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                              ),
                                              Text(
                                                widget.fromCity,
                                                style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 5.0),
                                          Column(
                                            children: [
                                              Text(
                                              formatJourneyTime(flight.journeyTime),
                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                              ),
                                              const SizedBox(height: 2.0),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 10.0,
                                                    width: 10.0,
                                                    decoration: const BoxDecoration(color: kBlueColor, shape: BoxShape.circle),
                                                  ),
                                                  Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        height: 2.0,
                                                        width: 100,
                                                        decoration: const BoxDecoration(
                                                          color: kBlueColor,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.all(5.0),
                                                        decoration: const BoxDecoration(
                                                          color: kPrimaryColor,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: const Icon(
                                                          Icons.flight_land_outlined,
                                                          size: 16,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                    width: 10.0,
                                                    decoration: BoxDecoration(
                                                      color: kWhite,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: kBlueColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 2.0),
                                              Text(
                                                "${flight.stops} Stop",
                                                style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 5.0),
                                          Column(
                                            children: [
                                              Text(
                                                extractTime(flight.departureDateTime),
                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 12),
                                              ),
                                              Text(
                                                widget.toCity,
                                                style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 5.0),

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
