import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/models/flight_details_model.dart';
import 'package:flightbooking/providers/pricing_request%20_provider.dart';
import 'package:flightbooking/routes/route_generator.dart';
import 'package:flightbooking/widgets/button_global.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:flightbooking/providers/seat_map_provider.dart';
import 'package:flightbooking/models/seat_map_model/seat_map_model.dart';
import 'package:intl/intl.dart';


import '../../providers/hidden_booking_provider.dart';
import '../../providers/search_flight_provider.dart';
import '../../widgets/custom_dialog.dart';

class SeatMapScreen extends StatefulWidget {
  final FlightDetail flight;
  const SeatMapScreen({super.key, required this.flight});

  @override
  State<SeatMapScreen> createState() => _SeatMapScreenState();
}

class _SeatMapScreenState extends State<SeatMapScreen> {
  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchFlightProvider>();

    return Consumer<SeatMapProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (provider.error != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Seat Map')),
            body: Center(child: Text(provider.error!)),
          );
        }

        final legs = provider.seatMap?.legs ?? {};
        if (legs.isEmpty) {
          return  Scaffold(
            appBar: AppBar(title: const Text('Seat Map')),
            body: const Center(child: Text('No seat available')),
          );
        }

        final legKeys = legs.keys.toList()..sort();
        final bool showContinue = provider.selectedSeats.isNotEmpty;

        return DefaultTabController(
          length: legKeys.length,
          child: Scaffold(
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

                const SizedBox(height: 10,),
                TabBar(
                  isScrollable: true,
                  labelColor: kWhite,
                  labelStyle: kTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  unselectedLabelColor: kBlueColor,
                  indicatorColor: kPrimaryColor,
                  indicator:
                  const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                     shape: BoxShape.rectangle,
                    color: kPrimaryColor,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    for (final k in legKeys)
                      Tab(
                        text: _legTitle(legs[k]!),
                      ),
                  ],
                ),

                const Divider(),
                Expanded(
                  child: TabBarView(
                    children: [
                      for (final k in legKeys)
                        _LegSeatView(
                          legKey: k.toString(),
                          seats: legs[k]!,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(12),
                child:ButtonGlobalWithoutIcon(
                    buttontext: showContinue ? "Continue" : "Skip",
                    buttonDecoration: kButtonDecoration.copyWith(
                        color: showContinue? kPrimaryColor : kSubTitleColor,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    // onPressed: () async {
                    //   final bookingProvider = context.read<HiddenBookingProvider>();
                    //   final pricingProvider = context.read<PricingProvider>();
                    //
                    //
                    //   if(showContinue){
                    //     AppLogger.log("Continue pressed");
                    //     await bookingProvider.sendBookingRequest(
                    //         context,
                    //         flight: widget.flight,
                    //     overrideFlightIds: pricingProvider.latestFlightIds
                    //     );
                    //     if (bookingProvider.error != null) {
                    //       final apiError = bookingProvider
                    //           .response?["data"]?["Status"]?["Error"]
                    //           ?.toString();
                    //
                    //       if(apiError != null && apiError.isNotEmpty) {
                    //         AppLogger.log("Booking failed: $apiError");
                    //         showCustomErrorDialog(context, apiError);
                    //       } else {
                    //         AppLogger.log("Booking failed (fallback): ${bookingProvider.error}");
                    //         showCustomErrorDialog(context, bookingProvider.error!);
                    //       }
                    //     }else{
                    //       final apiError = bookingProvider.response?["data"]?["Status"]?["Error"]?.toString();
                    //       if (apiError != null && apiError.isNotEmpty) {
                    //         AppLogger.log("Booking failed: $apiError");
                    //         showCustomErrorDialog(context, apiError);
                    //       } else {
                    //         AppLogger.log("Booking success ✅");
                    //       }
                    //     }
                    //   } else {
                    //     AppLogger.log("skip Pressed");
                    //
                    //     await bookingProvider.sendBookingRequest(
                    //         context,
                    //         flight: widget.flight,
                    //         overrideFlightIds: pricingProvider.latestFlightIds
                    //     );
                    //     if (bookingProvider.error != null) {
                    //       final apiError = bookingProvider
                    //           .response?["data"]?["Status"]?["Error"]
                    //           ?.toString();
                    //
                    //       if (apiError != null && apiError.isNotEmpty) {
                    //         AppLogger.log(
                    //             "Booking failed:(from API): $apiError");
                    //         showCustomErrorDialog(context, apiError);
                    //       }
                    //       else {
                    //         AppLogger.log("Booking failed (fallback): ${bookingProvider.error}");
                    //         showCustomErrorDialog(context, bookingProvider.error!);
                    //       }
                    //     }
                    //       else {
                    //       final apiError = bookingProvider
                    //           .response?["data"]?["Status"]?["Error"]
                    //           ?.toString();
                    //       if (apiError != null && apiError.isNotEmpty) {
                    //         AppLogger.log("Booking failed: $apiError");
                    //         showCustomErrorDialog(context, apiError);
                    //       } else {
                    //         AppLogger.log("Booking success ✅");
                    //       }
                    //     }
                    //   }
                    // },
                    onPressed: (){
                      Navigator.pushNamed(context, AppRoutes.payment, arguments:widget.flight );
                    },
                    buttonTextColor: kWhite),
                )),
          ),
        );
      },
    );
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


  String _legTitle(List<SeatItem> seats) {
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

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: sidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F6FB),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(36),
              ),
              border: Border.all(color: Colors.black12),
            ),
            padding: const EdgeInsets.fromLTRB(12, 18, 12, 24),
            child: _SeatGrid(
              seats: widget.seats,
              onTapSeat: (seat) => provider.toggleSeatSelection(widget.legKey,
                  seat, totalPassengers: totalPassengers),
              isSelected: (s) =>  provider.selectedSeatsForLeg(widget.legKey).contains(s.seatId),
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

        return SizedBox(
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
                        selected: isSelected(findSeat(sortedRowKeys[r], letter)),
                        onTap: () {
                          final seat = findSeat(sortedRowKeys[r], letter);
                          if (seat != null) onTapSeat(seat);
                        },
                      ),
                    ),
                ],
            ],
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
        return  Colors.red.shade900;
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
    final textColor = selected ? kWhite: Colors.black87;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
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
              style:kTextStyle.copyWith(
                fontWeight : FontWeight.w600,
                fontSize: 11,
                color: textColor
              )
            ),
            const SizedBox(height: 2),
            Text(
              '₹${seat.seatAmount}',
              style: kTextStyle.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }


}


