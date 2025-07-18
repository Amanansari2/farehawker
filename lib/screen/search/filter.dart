
import 'package:flightbooking/api_services/configs/app_configs.dart';
import 'package:flightbooking/providers/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:provider/provider.dart';

import '../../providers/country_provider.dart';
import '../../providers/search_flight_provider.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/custom_dialog.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {


  @override
  Widget build(BuildContext context) {
    
    final filter = context.watch<FilterProvider>();
    final searchProvider = context.watch<SearchFlightProvider>();
    return WillPopScope(
      onWillPop: ()async{
        if (searchProvider.isLoading) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kBlueColor,
          centerTitle: true,
          title: Text(lang.S.of(context).filter, style: kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold, fontSize: 30),),
          leading:searchProvider.isLoading
              ? const SizedBox()
              :  GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(FeatherIcons.x, color: kWhite),

          ),
          actions: [
            searchProvider.isLoading
                ? const SizedBox()
                :  TextButton(
              onPressed: () {
                context.read<FilterProvider>().resetFilters();
                toast('Filters reset successfully');
              },
              child: const Text(
                'Reset Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 10.0),

                /// Stop Options
                _buildStopsSection(filter),

                const SizedBox(height: 20.0),

                /// Departure Time
                _buildDepartureTimeSection(filter),

                const SizedBox(height: 20.0),

                /// Airlines Filter
                _buildAirlineFilterSection(filter),

                const SizedBox(height: 20.0),

                ///Refundable Filter
                _buildRefundableSection(filter),

                const SizedBox(height: 20.0),

                ///Class options
                _buildClassSection(filter),

                const SizedBox(height: 30.0),

                 searchProvider.isLoading
                      ?const Center(
                        child:  CircularProgressIndicator(
                          color: kPrimaryColor,
                          strokeWidth: 2.5,
                        ),
                      )
                      : ButtonGlobalWithoutIcon(
                    buttontext: lang.S.of(context).applyButton,
                    buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor),
                    onPressed: () async {
                      final searchProvider = context.read<SearchFlightProvider>();
                      final filter = context.read<FilterProvider>();
                      final filterProvider = context.read<FilterProvider>();
                      final countryProvider = context.read<CountryProvider>();

                      final bool noStopSelected = filter.selectedStopOption == null;
                      final bool noRefundableSelected = filter.selectedRefundableOptions == null;
                      final bool noDepartureSelected = filter.selectedDepartureTime == null;
                      final bool noAirlineSelected = filter.selectedAirlines.isEmpty;
                      final bool noClassOptionSelected = filter.selectedClassOptions == null;

                      if (noStopSelected && noRefundableSelected && noDepartureSelected && noAirlineSelected && noClassOptionSelected) {
                      if(!mounted) return;
                        showDialog(
                          context: context,
                          builder: (_) => CustomDialogBox(
                            title: 'Validation',
                            descriptions: 'Please select at least one filter before applying.',
                            text: 'OK',
                            titleColor: kRedColor,
                            img: 'images/dialog_error.png',
                            functionCall: () => Navigator.of(context).pop(),
                          ),
                        );
                        return;
                      }

                      bool success;
                      if(searchProvider.isRoundTrip){
                        success = await searchProvider.searchRoundTripFlight(
                          filterProvider: filterProvider,
                          countryProvider: countryProvider,
                          initialLoad: true,
                          stopOption: filter.selectedStopOption == 'all' ? null:filter.selectedStopOption,
                          refundableOption: filter.selectedRefundableOptions,
                          departureTime: filter.selectedDepartureTime,
                          selectedAirlines: filter.selectedAirlines.isNotEmpty ? filter.selectedAirlines.join(',') : null,
                          classOptions: filter.selectedClassOptions,
                        );
                      }else{
                        success = await searchProvider.searchFlight(
                          countryProvider: countryProvider,
                          filterProvider: filterProvider,
                          stopOption: filter.selectedStopOption == 'all' ? null:filter.selectedStopOption,
                          refundableOption: filter.selectedRefundableOptions,
                          departureTime: filter.selectedDepartureTime,
                          selectedAirlines: filter.selectedAirlines.isNotEmpty ? filter.selectedAirlines.join(',') : null,
                          classOptions: filter.selectedClassOptions ?? 'Economy',
                        );
                      }
                      if(!mounted) return;
                      if (success) {


                         Navigator.pop(context);
                      } else  {
                        if (!mounted) return;
                        showDialog(
                          context: context,
                          builder: (_) => CustomDialogBox(
                            title: 'Error',
                            descriptions: searchProvider.error!,
                            text: 'Retry',
                            titleColor: kRedColor,
                            img: 'images/dialog_error.png',
                            functionCall: () => Navigator.of(context).pop(),
                          ),
                        );
                      }
                    },

                    buttonTextColor: kWhite,
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStopsSection(FilterProvider filter) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: context.width(),
      decoration: _containerBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stops', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          HorizontalList(
            itemCount: filter.stopOptions.length,
            padding: EdgeInsets.zero,
            itemBuilder: (_, i) {
              final key = filter.stopOptions.keys.elementAt(i);
              final label = filter.stopOptions[key]!;
              return Row(
                children: [
                  Radio(
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    value: key,
                    groupValue: filter.selectedStopOption,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {

                        filter.selectStopOption(value.toString());

                    },
                  ),
                  Text(label, style: kTextStyle.copyWith(color: kSubTitleColor)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClassSection(FilterProvider filter) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: context.width(),
      decoration: _containerBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Class Options', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Wrap(
              spacing: 12,
              runSpacing: 8,
            // itemCount: filter.classOptions.length,
            // padding: EdgeInsets.zero,
             children: List.generate(filter.classOptions.length, (i){
               final key = filter.classOptions.keys.elementAt(i);
               final label = filter.classOptions[key]!;
               return Row(
                 children: [
                   Radio(
                     visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                     value: key,
                     groupValue: filter.selectedClassOptions,
                     activeColor: kPrimaryColor,
                     onChanged: (value) {
                       filter.selectClassOption(value.toString());
                     },
                   ),
                   Text(label, style: kTextStyle.copyWith(color: kSubTitleColor)),
                 ],
               );
             })

          ),
        ],
      ),
    );
  }


  Widget _buildRefundableSection(FilterProvider filter) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: context.width(),
      decoration: _containerBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Refundable Options', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          HorizontalList(
            itemCount: filter.refundableOptions.length,
            padding: EdgeInsets.zero,
            itemBuilder: (_, i) {
              final key = filter.refundableOptions.keys.elementAt(i);
              final label = filter.refundableOptions[key]!;
              return Row(
                children: [
                  Radio(
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    value: key,
                    groupValue: filter.selectedRefundableOptions,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {

                        filter.selectRefundableOption(value.toString());

                    },
                  ),
                  Text(label, style: kTextStyle.copyWith(color: kSubTitleColor)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDepartureTimeSection(FilterProvider filter) {
    return Container(
      decoration: _containerBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20),
            child: Row(
              children: [
                Transform.rotate(angle: 45, child: const Icon(Icons.flight)),
                const SizedBox(width: 5),
                Text(
                  'Departure Time',
                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15.0),

          /// Time Chips
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: HorizontalList(
              padding: EdgeInsets.zero,
              spacing: 0,
              itemCount: filter.departureTimeOptions.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) {
                final key = filter.departureTimeOptions.keys.elementAt(i);
                final label = filter.departureTimeOptions[key]!;
                final isSelected = filter.selectedDepartureTime == key;
                return GestureDetector(
                  onTap: (){
                    filter.selectDepartureTime(key);
                    },
                  child: Container(
                    width: 79,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryColor : kWhite,
                      border: Border.all(color: isSelected ? kPrimaryColor : kBorderColorTextField),
                      borderRadius: i == 0
                          ? const BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))
                          : i == 3
                          ? const BorderRadius.only(topRight: Radius.circular(4.0), bottomRight: Radius.circular(4.0))
                          : BorderRadius.zero,
                    ),
                    child: Column(
                      children: [
                        Icon(filter.departureIcons[i], color: isSelected ? kWhite : kSubTitleColor),
                        Divider(thickness: 1.0, color: isSelected ? kWhite : kBorderColorTextField),
                        Text(
                         label,
                          style: kTextStyle.copyWith(color: isSelected ? kWhite : kSubTitleColor, fontSize: 10.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirlineFilterSection(FilterProvider filter) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: _containerBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Airlines', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),

          /// Select All
          ListTileTheme(
            minLeadingWidth: 10,
            child: ListTile(
              dense: true,
              horizontalTitleGap: 10,
              contentPadding: EdgeInsets.zero,
              title: Text('Select All', style: kTextStyle.copyWith(color: kSubTitleColor)),
              leading: Icon(
                filter.areAllAirlinesSelected()
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color:  filter.areAllAirlinesSelected() ? kPrimaryColor : kSubTitleColor,
              ),
              onTap: filter.toggleSelectAllAirlines,

            ),
          ),

          /// Show Alliances
          ListTile(
            dense: true,
            horizontalTitleGap: 10,
            contentPadding: EdgeInsets.zero,
            title: Text('Show Alliances', style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
            trailing: Switch(
              activeColor: kPrimaryColor,
              inactiveThumbColor: kSubTitleColor,
              value: filter.showAlliances,
              onChanged: filter.toggleAlliance,
            ),
          ),
          const Divider(thickness: 1.0, height: 1, color: kBorderColorTextField),

          /// Airline List
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount:  filter.airlineOptions.length,
            itemBuilder: (_, i) {
              final airline  = filter.airlineOptions[i];
              final isSelected = filter.isAirlineSelected(airline.code);
              return Column(
                children: [
                  ListTileTheme(
                    minLeadingWidth: 10,
                    child: ListTile(
                      dense: true,
                      horizontalTitleGap: 10,
                      contentPadding: EdgeInsets.zero,
                      onTap: () => filter.toggleAirline(airline.code),
                      leading: Icon(
                        isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        color: isSelected ? kPrimaryColor : kSubTitleColor,
                      ),
                      title: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: airline.logo != null && airline.logo.isNotEmpty
                                    ? NetworkImage("${AppConfigs.mediaUrl}${airline.logo}")
                                    :const AssetImage('images/indigo.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(airline.name, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const Divider(thickness: 1.0, height: 1, color: kBorderColorTextField),
                ],
              );
            },
          ).visible(filter.showAlliances),
        ],
      ),
    );
  }

  /// Shared container decoration for cards
  BoxDecoration _containerBoxDecoration() {
    return BoxDecoration(
      color: kWhite,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: kBorderColorTextField),
      boxShadow: const [
        BoxShadow(
          color: kBorderColorTextField,
          blurRadius: 5.0,
          spreadRadius: 1.0,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}
