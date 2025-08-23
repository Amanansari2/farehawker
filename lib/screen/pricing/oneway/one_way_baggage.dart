import 'package:flightbooking/main.dart';
import 'package:flightbooking/models/pricing_rules_model/pricing_response_model.dart';
import 'package:flightbooking/providers/search_flight_provider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../api_services/app_logger.dart';
import '../../../providers/fare_rule_provider.dart';
import '../../../widgets/constant.dart';

class BaggageListView extends StatefulWidget {
  final List<Bagg> baggage;
  final ValueChanged<bool>? onSelectionChanged;
  const BaggageListView({super.key, required this.baggage, this.onSelectionChanged});

  @override
  State<BaggageListView> createState() => _BaggageListViewState();
}



class _BaggageListViewState extends State<BaggageListView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySelection);

  }

  void _notifySelection() {
    if(widget.onSelectionChanged == null) return;
    final anySelected = widget.baggage.any((b) => b.quantity > 0);
    widget.onSelectionChanged!(anySelected);
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.read<SearchFlightProvider>();
    int maxBags = provider.adultCount + provider.childCount + provider.infantCount;
    int getTotalSelectedBaggage() {
      return widget.baggage.fold<int>(0, (sum, b) => sum + b.quantity);
    }

    void _bump(VoidCallback op){
      setState(op);
      _notifySelection();
    }


    return ListView.builder(
        itemCount: widget.baggage.length,
        itemBuilder: (context, index){
          final baggage = widget.baggage[index];
          return BaggageCard(
              description: baggage.description,
              amount: double.tryParse(baggage.amount) ?? 0,
              quantity: baggage.quantity,
              baggageText: baggage.baggageText,
              onAdd: () {
                _bump((){
                  if(getTotalSelectedBaggage() < maxBags){
                    baggage.quantity++;
                    AppLogger.log("baggage Added: ${baggage.description}, New Quantity: ${baggage.quantity}");

                    if(baggage.quantity == 1){
                      final bookingProvider = context.read<BookProceedProvider>();
                      bookingProvider.travellers[0].selectedBagg?.add(baggage);
                      AppLogger.log("Baggage added to selected Baggage : ${baggage.description}");
                    }
                  }else{
                    toast("You can select up to $maxBags Baggage only for this flight");
                  }
                });
              },
              onRemove: (){
                _bump((){
                  if(baggage.quantity > 0){
                    baggage.quantity--;
                    AppLogger.log("baggage Removed: ${baggage.description}, New Quantity: ${baggage.quantity}");
                    if(baggage.quantity == 0){
                      final bookingProvider = context.read<BookProceedProvider>();
                      bookingProvider.travellers[0].selectedBagg?.remove(baggage);
                      AppLogger.log("baggage removed from selectedBaggage: ${baggage.description}");
                    }
                  }else{
                    toast("You can't remove a baggage that has quantity 0");
                  }
                });
              },
              onTapAdd: (){
                final bookingProvider = context.read<BookProceedProvider>();
                if (getTotalSelectedBaggage() < maxBags) {
                  _bump(() => baggage.quantity = 1);
                  bookingProvider.travellers[0].selectedBagg?.add(baggage);
                  AppLogger.log("baggage Selected: ${baggage.description}, Amount: ₹${baggage.amount}, Quantity: ${baggage.quantity}");
                } else {
                  toast("You can select up to $maxBags baggage only for this flight");
                }
              }
              );
        }
    );
  }
}


class BaggageCard extends StatelessWidget{
  final String description;
  final double amount;
  final int quantity;
  final String baggageText;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onTapAdd;

  const BaggageCard({
    Key? key,
    required this.description,
    required this.amount,
    required this.quantity,
    required this.baggageText,
    required this.onAdd,
    required this.onRemove,
    required this.onTapAdd,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhite,
      elevation: 2,
      shadowColor: kSubTitleColor,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child:  Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                      ),
                    ),
                    if (baggageText.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        baggageText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
            ),

            const SizedBox(width: 5,),


            quantity > 0
            ? Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: onRemove,
                  color: kPrimaryColor,
                ),
                Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold,)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onAdd,
                  color: kPrimaryColor,
                ),
              ],
            )
                :  ElevatedButton(

              onPressed: onTapAdd,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                  backgroundColor: kPrimaryColor
              ),
              child:  Text('Add', style: kTextStyle.copyWith(color: kWhite, fontSize: 14),),
            )
          ],
        ),
      ),
    );
  }
}