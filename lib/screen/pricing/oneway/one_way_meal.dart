

import 'package:flightbooking/providers/search_flight_provider.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../api_services/app_logger.dart';
import '../../../models/pricing_rules_model/pricing_response_model.dart';
import '../../../providers/fare_rule_provider.dart';

class MealListView extends StatefulWidget {
  final List<Meal> meals;
  final ValueChanged<bool>? onSelectionChanged;
  const MealListView({Key? key, required this.meals, this.onSelectionChanged}) : super(key: key);

  @override
  State<MealListView> createState() => _MealListViewState();
}

class _MealListViewState extends State<MealListView> {

  late Map<String, List<Meal>> routeMealMap;
  late List<String> routes;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _prepareRouteMeals();

  WidgetsBinding.instance.addPostFrameCallback((_) => _notifySelection);

  }

  void _prepareRouteMeals() {
    routeMealMap = {};
    for (var meal in widget.meals) {
      final route = "${meal.origin}_${meal.destination}";
      if(!routeMealMap.containsKey(route)){
        routeMealMap[route] = [];
      }
      routeMealMap[route]!.add(meal);
    }
    routes = routeMealMap.keys.toList();
    }


    void _notifySelection(){
    if(widget.onSelectionChanged == null) return;
    final anySelected = widget.meals.any((m) => m.quantity > 0);
    widget.onSelectionChanged!(anySelected);
    }



  @override
  Widget build(BuildContext context) {
    if(routes.length == 1){
      return _MealList(
          meals: routeMealMap[routes.first]!,
          onChanged: _notifySelection,
      );
    }
    return Column(
      children: [
        // Custom pill-style route selector
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(routes.length, (i) {
              final split = routes[i].split('_');
              final from = split[0];
              final to = split[1];
              final selected = selectedIndex == i;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = i;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? kPrimaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: selected ? kPrimaryColor : kBlueColor,
                        width: 1.3,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          from,
                          style: TextStyle(
                            color: selected ? Colors.white : kBlueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.flight, size: 18, color: selected ? Colors.white : kBlueColor),
                        const SizedBox(width: 6),
                        Text(
                          to,
                          style: TextStyle(
                            color: selected ? Colors.white : kBlueColor,
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
          child: _MealList(
            meals: routeMealMap[routes[selectedIndex]]!,
               onChanged: _notifySelection,
          ),
        ),
      ],
    );
  }
}

class _MealList extends StatefulWidget {
  final List<Meal> meals;
  final VoidCallback? onChanged;
  const _MealList({Key? key, required this.meals, this.onChanged}) : super(key: key);

  @override
  State<_MealList> createState() => __MealListState();
}

class __MealListState extends State<_MealList> {
  @override
  Widget build(BuildContext context) {

    final provider = context.read<SearchFlightProvider>();
    final int maxMeals = provider.adultCount + provider.childCount + provider.infantCount;

    int getTotalSelectedMeals() {
      return widget.meals.fold<int>(0, (sum, meal) => sum + meal.quantity);
    }

    void _bump(VoidCallback op){
      setState(op);
      widget.onChanged?.call();
    }

    return ListView.separated(
      separatorBuilder: (context, index) => const Divider().paddingOnly(left: 30, right: 30),
      itemCount: widget.meals.length,
      itemBuilder: (context, index) {
        final meal = widget.meals[index];
        return MealCard(
          description: meal.description,
          amount: double.tryParse(meal.amount) ?? 0,
          quantity: meal.quantity,

          onAdd: () {
            _bump(() {
              if (getTotalSelectedMeals() < maxMeals) {
                meal.quantity++;
                AppLogger.log("Meal Added: ${meal.description}, New Quantity: ${meal.quantity}");


                if (meal.quantity == 1) {
                  final bookingProvider = context.read<BookProceedProvider>();
                  bookingProvider.travellers[0].selectedMeal?.add(meal); // Set the selected meal
                  AppLogger.log("Meal added to selectedMeal: ${meal.description}");
                }
              } else {
                toast("You can select up to $maxMeals meals only for this flight");
              }
            });
          },

          onRemove: () {
            _bump(() {
              if (meal.quantity > 0) {
                meal.quantity--;
                AppLogger.log("Meal Removed: ${meal.description}, New Quantity: ${meal.quantity}");


                if (meal.quantity == 0) {
                  final bookingProvider = context.read<BookProceedProvider>();
                  bookingProvider.travellers[0].selectedMeal?.remove(meal); // Remove the meal from selectedMeal
                  AppLogger.log("Meal removed from selectedMeal: ${meal.description}");
                }
              } else {
                toast("You can't remove a meal that has quantity 0");
              }
            });
          },

          onTapAdd: () {
            final bookingProvider = context.read<BookProceedProvider>();
    if (getTotalSelectedMeals() < maxMeals) {
      _bump(() => meal.quantity = 1);
      bookingProvider.travellers[0].selectedMeal?.add(meal) ;
      AppLogger.log("Meal Selected: ${meal.description}, Amount: ₹${meal.amount}, Quantity: ${meal.quantity}");

    }else{
      toast("You can select up to $maxMeals meals only for this flight");
    }
          },
        );
      },
    );
  }
}


class MealCard extends StatelessWidget {
  final String description;
  final double amount;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onTapAdd;


  const MealCard({
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
            // Main details
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
              ),
            ),
            const SizedBox(width: 5,),
            // Counter or Add Button
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
                : ElevatedButton(
              onPressed: onTapAdd,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                backgroundColor: kPrimaryColor
              ),
              child:  Text('Add', style: kTextStyle.copyWith(color: kWhite, fontSize: 14),),
            ),
          ],
        ),
      ),
    );
  }
}
