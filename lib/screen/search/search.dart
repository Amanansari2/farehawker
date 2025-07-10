import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../models/country_list_model.dart';
import '../../providers/country_provider.dart';
import '../../widgets/constant.dart';

class Search extends StatefulWidget {

  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  List<City> filteredCities = [];

  @override
  void initState() {
    super.initState();
    final cities = Provider.of<CountryProvider>(context, listen: false).countries;
    filteredCities = cities;

  }
  @override
  Widget build(BuildContext context) {
    final cities = Provider.of<CountryProvider>(context, listen: false).countries;
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBlueColor,
        centerTitle: true,
        title: Text(lang.S.of(context).searchScreenTitle, style: const TextStyle(color: kWhite),),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            FeatherIcons.x,
            color: kWhite,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (val) {
                setState(() {
                  filteredCities = cities.where((c) {
                    final query = val.toLowerCase();
                    return c.city.toLowerCase().contains(query) ||
                        c.cityCode.toLowerCase().contains(query) ||
                        c.country.toLowerCase().contains(query);
                  }).toList();
                });
              },
              decoration: kInputDecoration.copyWith(
                prefixIcon: const Icon(FeatherIcons.search, color: kSubTitleColor),
                hintText: 'Country, city or airport',
                hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
              ),
            ),



            const SizedBox(height: 20),
            Text(
              lang.S.of(context).recentPlaceTitle,
              style: kTextStyle.copyWith(
                color: kSubTitleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1.0, color: kBorderColorTextField),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCities.length,
                itemBuilder: (_, i) {
                  final city = filteredCities[i];
                  return Column(
                    children: [
                      ListTile(
                        onTap: () => Navigator.pop(context, city),
                        dense: true,
                        visualDensity: const VisualDensity(vertical: -2),
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColor.withOpacity(0.1),
                          ),
                          child: const Icon(Icons.flight, color: kPrimaryColor),
                        ),
                        title: Text(city.city, style: kTextStyle.copyWith(fontWeight: FontWeight.bold)),
                        subtitle: Text('${city.cityCode}, ${city.country}',
                            style: kTextStyle.copyWith(color: kSubTitleColor)),
                      ),
                      const Divider(thickness: 1.0, color: kBorderColorTextField),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),


    );
  }
}
