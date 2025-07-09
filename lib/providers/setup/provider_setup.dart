import 'package:flightbooking/api_services/internet_status.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../api_services/api_request/get_request.dart';
import 'package:flightbooking/api_services/api_request/post_service.dart';
import '../../repository/country_repo.dart';
import '../../repository/group_booking_repo.dart';
import '../../screen/provider/providers.dart';
import '../country_provider.dart';
import '../group_booking_provider.dart';
import '../search_flight_provider.dart';

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider<InternetMonitorProvider>(
      create: (_) => InternetMonitorProvider()..startMonitoring()),

  /// Language provider
  ChangeNotifierProvider<LanguageChangeProvider>(
    create: (_) => LanguageChangeProvider(),
  ),

  /// API services
  ChangeNotifierProvider<PostService>(
    create: (context) => PostService(),
  ),

  Provider<GetService>(
    create: (_) => GetService(),
  ),


  /// Country and location providers
  Provider<CountryRepository>(
    create: (context) => CountryRepository(
      Provider.of<GetService>(context, listen: false),
    ),
  ),
  ChangeNotifierProvider<CountryProvider>(
    create: (context) {
      final repo = Provider.of<CountryRepository>(context, listen: false);
      return CountryProvider(repo);
    },
  ),


  ChangeNotifierProvider<SearchFlightProvider>(
    create: (_) => SearchFlightProvider(),
  ),


  /// Group booking providers
  Provider<GroupBookingRepository>(
    create: (context) => GroupBookingRepository(
      Provider.of<PostService>(context, listen: false),
    ),
  ),
  ChangeNotifierProvider<GroupBookingController>(
    create: (context) => GroupBookingController(
      Provider.of<GroupBookingRepository>(context, listen: false),
    ),
  ),
];