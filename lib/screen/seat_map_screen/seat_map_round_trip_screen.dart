import 'package:flightbooking/widgets/button_global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../api_services/app_logger.dart';
import '../../models/flight_details_model.dart';
import '../../providers/hidden_booking_provider.dart';
import '../../providers/pricing_request _provider.dart';
import '../../providers/seat_map_provider.dart';
import '../../providers/search_flight_provider.dart';
import '../../routes/route_generator.dart';
import '../../widgets/constant.dart';
import '../../models/seat_map_model/seat_map_model.dart';
import '../../widgets/custom_dialog.dart';





class RoundTripSeatMapScreen extends StatefulWidget {
  final FlightDetail onwardFlight;
  final FlightDetail returnFlight;

  const RoundTripSeatMapScreen({super.key, required this.onwardFlight, required this.returnFlight});

  @override
  State<RoundTripSeatMapScreen> createState() => _RoundTripSeatMapScreenState();
}

class _RoundTripSeatMapScreenState extends State<RoundTripSeatMapScreen> with SingleTickerProviderStateMixin {


  late TabController _topTabController; @override
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
    final provider = context.watch<SeatMapProvider>();
    final showContinue = provider.selectedSeats.isNotEmpty;



    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: kWhite),
        backgroundColor: kBlueColor,
        title: ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          horizontalTitleGap: 0.0,
          contentPadding: const EdgeInsets.only(right: 15.0),
          title: Text(
            'Pricing Details',
            style: kTextStyle.copyWith(
                color: kWhite,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          subtitle: Text(
            '${searchProvider.fromCity?.city ?? ''} - ${searchProvider.toCity?.city ?? ''} | '
                '${DateFormat('EEE d MMM').format(searchProvider.selectedDate)} | '
                '${searchProvider.adultCount} Adult, ${searchProvider.childCount} Child, ${searchProvider.infantCount} Infant',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(color: kWhite),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTopTabs(),
          Expanded(
            child: TabBarView(
              controller: _topTabController,
              children: [
                _TripLegsView(
                  legs: provider.onwardSeatMap?.legs ?? {},
                  loading: provider.isOnwardLoading,
                  error: provider.onwardError,
                  tripLabel: "Onward",
                ),
                _TripLegsView(
                  legs: provider.returnSeatMap?.legs ?? {},
                  loading: provider.isReturnLoading,
                  error: provider.returnError,
                  tripLabel: "Return",
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 12, left: 12),
      child:  ButtonGlobalWithoutIcon(
          buttontext: showContinue ? "Continue" : "Skip",
          buttonDecoration: kButtonDecoration.copyWith(
          color: context.watch<SeatMapProvider>().selectedSeats.isNotEmpty ? kPrimaryColor : kSubTitleColor,
          borderRadius: BorderRadius.circular(30),),
          buttonTextColor: kWhite,
    //       onPressed: () async {
    //         final bookingProvider = context.read<HiddenBookingProvider>();
    //         final pricingProvider = context.read<PricingProvider>();
    //
    //         if(showContinue){
    //           AppLogger.log("Continue pressed");
    //           await bookingProvider.sendRoundtripBookingrequest(
    //               context: context,
    //               onwardFlight: widget.onwardFlight,
    //               returnFlight: widget.returnFlight,
    //           onwardFlightIds: pricingProvider.onwardFlightIds,
    //           returnFlightIds: pricingProvider.returnFlightIds,
    //           );
    //
    // if (bookingProvider.onwardError != null && bookingProvider.returnError != null) {
    // final onwardApiError = bookingProvider
    //     .response?["data"]?["Status"]?["Error"]
    //     ?.toString();
    // final returnApiError = bookingProvider
    //     .response?["data"]?["Status"]?["Error"]
    //     ?.toString();
    //
    // if ((onwardApiError != null && onwardApiError.isNotEmpty) ||
    //     (returnApiError != null && returnApiError.isNotEmpty) ) {
    //   final combinedError = [
    //     if (onwardApiError != null && onwardApiError.isNotEmpty)
    //       "Onward: $onwardApiError",
    //     if (returnApiError != null && returnApiError.isNotEmpty)
    //       "Return: $returnApiError",
    //   ].join("\n\n");
    // AppLogger.log("Booking failed with errors:\n$combinedError ");
    // showCustomErrorDialog(context, combinedError, );
    // }else{
    //   AppLogger.log("Booking failed onward (fallback): ${bookingProvider.onwardError} ,Booking failed return (fallback): ${bookingProvider.returnError} ");
    //   showCustomErrorDialog(context, bookingProvider.error!);
    // }
    // }else{
    //   final onwardApiError = bookingProvider
    //       .response?["data"]?["Status"]?["Error"]
    //       ?.toString();
    //   final returnApiError = bookingProvider
    //       .response?["data"]?["Status"]?["Error"]
    //       ?.toString();
    //
    //   if ((onwardApiError != null && onwardApiError.isNotEmpty )||
    //       (returnApiError!= null && returnApiError.isNotEmpty)) {
    //     final combinedError = [
    //       if (onwardApiError != null && onwardApiError.isNotEmpty)
    //         "Onward: $onwardApiError",
    //       if (returnApiError != null && returnApiError.isNotEmpty)
    //         "Return: $returnApiError",
    //     ].join("\n\n");
    //     AppLogger.log("Booking failed onward: $combinedError,");
    //     showCustomErrorDialog(context, combinedError);
    //   } else {
    //     AppLogger.log("Booking success ✅");
    //   }
    // }
    //   } else{
    //           AppLogger.log("Skip pressed");
    //           await bookingProvider.sendRoundtripBookingrequest(
    //             context: context,
    //             onwardFlight: widget.onwardFlight,
    //             returnFlight: widget.returnFlight,
    //             onwardFlightIds: pricingProvider.onwardFlightIds,
    //             returnFlightIds: pricingProvider.returnFlightIds,
    //           );
    //
    //           if (bookingProvider.onwardError != null && bookingProvider.returnError != null) {
    //             final onwardApiError = bookingProvider
    //                 .response?["data"]?["Status"]?["Error"]
    //                 ?.toString();
    //             final returnApiError = bookingProvider
    //                 .response?["data"]?["Status"]?["Error"]
    //                 ?.toString();
    //
    //             if ((onwardApiError != null && onwardApiError.isNotEmpty) ||
    //                 (returnApiError != null && returnApiError.isNotEmpty) ) {
    //               final combinedError = [
    //                 if (onwardApiError != null && onwardApiError.isNotEmpty)
    //                   "Onward: $onwardApiError",
    //                 if (returnApiError != null && returnApiError.isNotEmpty)
    //                   "Return: $returnApiError",
    //               ].join("\n\n");
    //               AppLogger.log("Booking failed with errors:\n$combinedError ");
    //               showCustomErrorDialog(context, combinedError, );
    //             }else{
    //               AppLogger.log("Booking failed onward (fallback): ${bookingProvider.onwardError} ,Booking failed return (fallback): ${bookingProvider.returnError} ");
    //               showCustomErrorDialog(context, bookingProvider.error!);
    //             }
    //           }else{
    //             final onwardApiError = bookingProvider
    //                 .response?["data"]?["Status"]?["Error"]
    //                 ?.toString();
    //             final returnApiError = bookingProvider
    //                 .response?["data"]?["Status"]?["Error"]
    //                 ?.toString();
    //
    //             if ((onwardApiError != null && onwardApiError.isNotEmpty )||
    //                 (returnApiError!= null && returnApiError.isNotEmpty)) {
    //               final combinedError = [
    //                 if (onwardApiError != null && onwardApiError.isNotEmpty)
    //                   "Onward: $onwardApiError",
    //                 if (returnApiError != null && returnApiError.isNotEmpty)
    //                   "Return: $returnApiError",
    //               ].join("\n\n");
    //               AppLogger.log("Booking failed onward: $combinedError,");
    //               showCustomErrorDialog(context, combinedError);
    //             } else {
    //               AppLogger.log("Booking success ✅");
    //             }
    //           }
    //         }
    //
    //       },

        onPressed: (){
          Navigator.pushNamed(context, AppRoutes.payment, arguments: {
             'onwardFlight': widget.onwardFlight,
            'returnFlight' : widget.returnFlight
            });
        },
          ),
      ),
    );
  }
}

void showCustomErrorDialog(BuildContext context, String message) {
  AppLogger.log("🚨 Error Dialog Message: $message");
  showDialog(
    context: context,
    builder: (ctx) => CustomDialogBox(
      title: "Booking Error",
      descriptions: message,
      text: "OK",
      titleColor: kRedColor,
      img: 'images/dialog_error.png',
      functionCall: () {
        Navigator.of(ctx).pop(); // Close dialog
      },
    ),
  );
}


class _TripLegsView extends StatelessWidget {
  final Map<dynamic, List<SeatItem>> legs;
  final bool loading;
  final String? error;
  final String tripLabel;

  const _TripLegsView({
    required this.legs,
    required this.loading,
    required this.error,
    required this.tripLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text(error!));
    if (legs.isEmpty) return Center(child: Text('No seat available for $tripLabel trip'));

    final legKeys = legs.keys.toList()..sort();

    return DefaultTabController(
      length: legKeys.length,
      child: Column(
        children: [
          const SizedBox(height: 10),
          TabBar(
            isScrollable: true,
            labelColor: kWhite,
            labelStyle: kTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelColor: kBlueColor,
            indicatorColor: kPrimaryColor,
            indicator: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              shape: BoxShape.rectangle,
              color: kPrimaryColor,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              for (final k in legKeys) Tab(text: _legTitle(legs[k]!)),
            ],
          ),
          const Divider(),
          Expanded(
            child: TabBarView(
              children: [
                for (final k in legKeys)
                  _LegSeatView(
                    legKey:'$tripLabel-$k',
                    seats: legs[k]!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _legTitle(List<SeatItem> seats) {
    if (seats.isEmpty) return 'Leg';
    final s0 = seats.first;
    if (s0.origin.isNotEmpty && s0.destination.isNotEmpty) {
      return '${s0.origin} → ${s0.destination}';
    }
    return 'Leg';
  }
}

class _LegSeatView extends StatefulWidget {
  final String legKey;
  final List<SeatItem> seats;

  const _LegSeatView({required this.legKey, required this.seats});

  @override
  State<_LegSeatView> createState() => _LegSeatViewState();
}

class _LegSeatViewState extends State<_LegSeatView> {


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SeatMapProvider>();
    final searchProvider = context.read<SearchFlightProvider>();
    final totalPassengers = searchProvider.adultCount +
        searchProvider.childCount ;
    const double sidePadding = 10.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: sidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F6FB),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(36),
                ),
                border: Border.all(color: Colors.black12),
              ),
              padding: const EdgeInsets.fromLTRB(12, 18, 12,5),
              child: _SeatGrid(
                seats: widget.seats,
                onTapSeat: (seat) => provider.toggleRoundTripSeatSelection(
                  tripType: widget.legKey.split('-')[0],
                  legIndex: int.parse(widget.legKey.split('-')[1]),
                  seat:seat ,
                  totalPassengers: totalPassengers,
                ),
                isSelected: (s) => provider
                    .selectedSeatsForLeg(widget.legKey)
                    .contains(s.seatId),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SeatGrid extends StatelessWidget {
  final List<SeatItem> seats;
  final void Function(SeatItem) onTapSeat;
  final bool Function(SeatItem) isSelected;

  const _SeatGrid({
    required this.seats,
    required this.onTapSeat,
    required this.isSelected,
  });



  @override
  Widget build(BuildContext context) {
    const letters = ['A', 'B', 'C', 'D', 'E', 'F'];
    const double spacing = 8.0;
    const double aisleSpacing = 22.0;
    const double topLabelH = 20.0;
    const double sideLabelW = 18.0;

    // Extract rows and group seats by row
    final Map<String, List<SeatItem>> rows = {};
    for (final seat in seats) {
      final match = RegExp(r'^(\d+)').firstMatch(seat.seatName);
      if (match != null) {
        final rowNum = match.group(1)!;
        rows.putIfAbsent(rowNum, () => []).add(seat);
      }
    }
    final sortedRowKeys = rows.keys.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    SeatItem findSeat(String rowKey, String letter) {
      return rows[rowKey]?.firstWhere(
            (s) => s.seatName.endsWith(letter),
        orElse: () => SeatItem(
          seatName: '',
          seatType: SeatType.other,
          seatAmount: 0,
          availability: SeatAvailability.unknown,
          x: 0,
          y: 0,
          origin: '',
          destination: '',
          seatId: '',
        ),
      ) ?? SeatItem(
        seatName: '',
        seatType: SeatType.other,
        seatAmount: 0,
        availability: SeatAvailability.unknown,
        x: 0,
        y: 0,
        origin: '',
        destination: '', seatId: '',
      );
    }


    return LayoutBuilder(
      builder: (context, constraints) {
        final seatWidth = (constraints.maxWidth - sideLabelW * 2 - spacing * (letters.length - 2) - aisleSpacing) / letters.length;

        final seatSize = seatWidth;

        final canvasW = sideLabelW + letters.length * seatSize + spacing * (letters.length - 1) + aisleSpacing + sideLabelW;
        final canvasH = topLabelH + sortedRowKeys.length * (seatSize + spacing) + 8;

        double leftForLetter(String letter) {
          final index = letters.indexOf(letter);
          double pos = sideLabelW + index * (seatSize + spacing);
          if (index > 2) pos += aisleSpacing; // gap after C
          return pos;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: canvasW,
            height: canvasH,
            child: Stack(
              children: [
                // Column letters
                for (final letter in letters)
                  Positioned(
                    left: leftForLetter(letter) + seatSize / 2 - 6,
                    top: 0,
                    child: Text(letter, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),

                // Row numbers and seats
                for (int r = 0; r < sortedRowKeys.length; r++)
                  ...[
                    Positioned(
                      left: 0,
                      top: topLabelH + r * (seatSize + spacing) + seatSize / 2 - 8,
                      child: Text(sortedRowKeys[r], style: const TextStyle(fontSize: 12)),
                    ),
                    Positioned(
                      right: 0,
                      top: topLabelH + r * (seatSize + spacing) + seatSize / 2 - 8,
                      child: Text(sortedRowKeys[r], style: const TextStyle(fontSize: 12)),
                    ),
                    for (final letter in letters)
                      Positioned(
                        left: leftForLetter(letter),
                        top: topLabelH + r * (seatSize + spacing),
                        child: _SeatTile(
                          seat: findSeat(sortedRowKeys[r], letter),
                          size: seatSize,
                          selected: rows[sortedRowKeys[r]]?.any((s) => s.seatName.endsWith(letter) && isSelected(s)) ?? false,
                          onTap: () {
                            final seat = findSeat(sortedRowKeys[r], letter);
                            if (seat != null) onTapSeat(seat);
                          },
                        ),
                      ),
                  ],
              ],
            ),
          ),
        );
      },
    );
  }
}


class _SeatTile extends StatelessWidget {
  final SeatItem seat;
  final double size;
  final bool selected;
  final VoidCallback onTap;

  const _SeatTile({
    required this.seat,
    required this.size,
    required this.selected,
    required this.onTap,
  });

  Color _baseColor() {
    switch (seat.availability) {
      case SeatAvailability.open:
        return const Color(0xFF0FF10F);
      case SeatAvailability.closed:
        return Colors.red.shade900;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (seat.seatName.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Stack(
          children: [

            Positioned.fill(
              child: Transform.rotate(
                  angle: 45 * 3.1415926535 / 180, // 45 degrees in radians
                  child:const Divider()
              ),
            ),

            Positioned.fill(
              child: Transform.rotate(
                angle: -45 * 3.1415926535 / 180,
                child: const Divider(),
              ),
            ),
          ],
        ),
      );
    }

    final enabled = seat.availability == SeatAvailability.open;
    final bg = selected ? kBlueColor : _baseColor();
    final textColor = selected ? kWhite : Colors.black87;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              seat.seatName,
              style: kTextStyle.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),

            const SizedBox(height: 2,),

            Text(
              '₹${seat.seatAmount}',
              style: kTextStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 9,
                color: textColor
              ),
            )
          ],
        ),
      ),
    );
  }
}
