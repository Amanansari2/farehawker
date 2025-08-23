import 'dart:ui';

import 'package:flightbooking/main.dart';
import 'package:flightbooking/providers/search_flight_provider.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../api_services/app_logger.dart';
import '../../../models/pricing_rules_model/pricing_response_model.dart';
import '../../../providers/fare_rule_provider.dart';


class OtherServiceListView extends StatefulWidget {
  final List<OtherService> otherService;
  final ValueChanged<bool>? onSelectionChanged;
  const OtherServiceListView({super.key, required this.otherService, this.onSelectionChanged});

  @override
  State<OtherServiceListView> createState() => _OtherServiceListViewState();
}

class _OtherServiceListViewState extends State<OtherServiceListView> {

  late Map<String, List<OtherService>> routeServiceMap;
  late List<String> serviceRoutes;
  int serviceSelectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _prepareRouteOtherService();
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySelection);

  }

  void _prepareRouteOtherService() {
    routeServiceMap = {};
    for (var otherService in widget.otherService ){
      final routes = "${otherService.origin}_${otherService.destination}";
      if(!routeServiceMap.containsKey(routes)){
        routeServiceMap[routes] = [];
      }
      routeServiceMap[routes]!.add(otherService);
    }
    serviceRoutes = routeServiceMap.keys.toList();
  }

  void _notifySelection(){
    if(widget.onSelectionChanged == null) return;
    final anySelected = widget.otherService.any((o) => o.quantity > 0);
    widget.onSelectionChanged!(anySelected);
  }

  @override
  Widget build(BuildContext context) {

    if(serviceRoutes.length == 1){
      return _OtherServiceList(
          otherService: routeServiceMap[serviceRoutes.first]!,
          onChanged : _notifySelection
      );
    }

    return Column(
      children: [
        Container(
          padding: const  EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(serviceRoutes.length, (i){
              final serviceSplits = serviceRoutes[i].split('_');
              final serviceFrom = serviceSplits[0];
              final serviceTo = serviceSplits[1];
              final serviceSelected = serviceSelectedIndex == i;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      serviceSelectedIndex = i;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: serviceSelected ? kPrimaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: serviceSelected ? kPrimaryColor : kBlueColor,
                        width: 1.3,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          serviceFrom,
                          style: TextStyle(
                          color: serviceSelected ? Colors.white : kBlueColor,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.flight, size: 18, color: serviceSelected ? Colors.white : kBlueColor),
                        const SizedBox(width: 6),
                        Text(
                          serviceTo,
                          style: TextStyle(
                            color: serviceSelected ? Colors.white : kBlueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
            child: _OtherServiceList(
                otherService: routeServiceMap[serviceRoutes[serviceSelectedIndex]]!,
               onChanged: _notifySelection,
            ),
        )
      ],
    );
  }
}



class _OtherServiceList extends StatefulWidget {
  final List<OtherService> otherService;
  final VoidCallback? onChanged;
  const _OtherServiceList({super.key, required this.otherService, this.onChanged});

  @override
  State<_OtherServiceList> createState() => _OtherServiceListState();
}

class _OtherServiceListState extends State<_OtherServiceList> {
  @override
  Widget build(BuildContext context) {

    final provider = context.read<SearchFlightProvider>();
    final int maxService = provider.adultCount + provider.childCount + provider.infantCount;
    int getTotalSelectedService(){
      return widget.otherService.fold<int>(0, (sum, service) => sum + service.quantity );
    }

    void _bump(VoidCallback op){
      setState(op);
      widget.onChanged?.call();
    }
    return ListView.separated(
         separatorBuilder: (context, index) => const Divider().paddingOnly(left: 30, right :30),
         itemCount: widget.otherService.length,
         itemBuilder: (context, index){
           final otherService = widget.otherService[index];
           return OtherServiceCard(
               description: otherService.description,
               amount: double.tryParse(otherService.amount) ?? 0,
               quantity: otherService.quantity,
               onAdd: () {
                 _bump((){
                   if(getTotalSelectedService() < maxService){
                     otherService.quantity++;
                     AppLogger.log("otherService Added: ${otherService.description}, New Quantity: ${otherService.quantity}");

                     if(otherService.quantity == 1){
                       final bookingProvider = context.read<BookProceedProvider>();
                       bookingProvider.travellers[0].selectedOther?.add(otherService);
                       AppLogger.log("otherService added to selectedOtherService: ${otherService.description}");
                     }
                   }else{
                     toast("You can select up to $maxService Services only for this flight");
                   }
                 });
                 },
               onRemove: () {
                 _bump(() {
                   if(otherService.quantity > 0) {
                     otherService.quantity--;
                     AppLogger.log("otherService Removed: ${otherService.description}, New Quantity: ${otherService.quantity}");

                     if(otherService.quantity == 0){
                       final bookingProvider = context.read<BookProceedProvider>();
                       bookingProvider.travellers[0].selectedOther?.remove(otherService);
                       AppLogger.log("otherService removed from selectedOtherService: ${otherService.description}");

                     }
                   }else{
                     toast("You can't remove a otherService that has quantity 0");
                   }
                 });
               },
               onTapAdd: (){
             final bookingProvider = context.read<BookProceedProvider>();

                 if(getTotalSelectedService() < maxService) {
                   _bump(() => otherService.quantity = 1);
                   bookingProvider.travellers[0].selectedOther?.add(otherService);
                   AppLogger.log("otherService Selected: ${otherService.description}, Amount: ₹${otherService.amount}, Quantity: ${otherService.quantity}");

                 }else{
                   toast("You can select up to $maxService Service only for this flight");
                 }
           }
           );
         },

    );
  }
}


class OtherServiceCard extends StatelessWidget {
  final String description;
  final double amount;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onTapAdd;

  const OtherServiceCard({
    Key? key,
    required this.description,
    required this.amount,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.onTapAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhite,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      elevation: 2,
      shadowColor: kSubTitleColor,
      child: Padding(
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
                          fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15
                      ),
                    ),
                  ],
                )
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
