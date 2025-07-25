import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/screen/Authentication/splash%20screen/onboard.dart';
import 'package:flightbooking/screen/Authentication/splash%20screen/splash_screen.dart';
import 'package:flightbooking/screen/Authentication/welcome_screen.dart';
import 'package:flightbooking/screen/book%20proceed/book_proceed.dart';
import 'package:flightbooking/screen/book%20proceed/round_trip_book_proceed.dart';
import 'package:flightbooking/screen/profile/setting/notification.dart';
import 'package:flightbooking/screen/search/filter.dart';
import 'package:flightbooking/screen/search/flight_details.dart';
import 'package:flightbooking/screen/search/round_trip_flight_details.dart';
import 'package:flightbooking/screen/search/search.dart';
import 'package:flightbooking/screen/search/search_result.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/material.dart';

import '../models/flight_details_model.dart';
import '../screen/profile/profile_screen.dart';
import '../screen/search/round_trip_search_result.dart';

class AppRoutes {

 static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const String splash = "/";
  static const String onBoard = "/OnBoard";
  static const String welcome = "/WelcomeScreen";
  static const String profile = "/Profile";
  static const String notification = "/NotificationSc";
  static const String search = "/Search";
  static const String searchResult = "/SearchResult";
  static const String searchRoundTripResult = "/SearchRoundTripResult";
  static const String filter = "/Filter";
  static const String flightDetails = "/FlightDetails";
  static const String roundTripFlightDetails = "/RoundTripFlightDetails";
  static const String bookProceed = "/BookProceed";
  static const String roundTripBookProceed = "/RoundTripBookProceed";
}


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    debugPrint("Navigating to  ---->>${settings.name}");
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.onBoard:
        return MaterialPageRoute(builder: (_) => const OnBoard());

      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const Profile());

      case AppRoutes.notification:
        return MaterialPageRoute(builder: (_) => const NotificationSc());

      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const Search());

      case AppRoutes.searchResult:
        return MaterialPageRoute(builder: (_) => const SearchResult());

      case AppRoutes.searchRoundTripResult:
        return MaterialPageRoute(builder: (_) => const RoundTripSearchResult());

      case AppRoutes.filter:
        return MaterialPageRoute(builder: (_) => const Filter());

      case AppRoutes.flightDetails:
        final args = settings.arguments;
        if(args is FlightDetail) {
          return MaterialPageRoute(
              builder: (_) =>  FlightDetails(flight: args));
        }
        return _errorRoute("Invalid or missing FlightDetails ");


      case AppRoutes.roundTripFlightDetails:
        final args = settings.arguments;
        if(args is Map<String, dynamic>){
          final onward = args['onwardFlight'];
          final returnF = args['returnFlight'];
          if(onward != null && returnF != null){
            return MaterialPageRoute(
                builder: (_) => RoundTripFlightDetails(
                    flight: onward,
                    returnFlight: returnF,
                ));
          }
        }
          return _errorRoute("Invalid round trip Details");


      case AppRoutes.bookProceed:
        final args = settings.arguments;
        if(args is FlightDetail){
          return MaterialPageRoute(
              builder: (_) => BookProceed(flight: args));
        }
        return _errorRoute("Invalid or Missing Information");

      case AppRoutes.roundTripBookProceed:
        final args = settings.arguments;
        if(args is Map<String, dynamic>){
          final onward = args['onwardFlight'];
          final returnF = args['returnFlight'];
          if(onward is FlightDetail && returnF is FlightDetail){
            return MaterialPageRoute(
                builder: (_) => RoundTripBookProceed(
                  onwardFlight: onward,
                  returnFlight: returnF,
                ));
          }
        }
        return _errorRoute("Invalid or Missing RoundTripBookProceed arguments");


      default:
        AppLogger.log('⚠️ Route not found: ${settings.name}');
        return _errorRoute("404 - Page not found");

    }

  }
           static MaterialPageRoute _errorRoute(String message){
    return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text(
              message,
              style: const TextStyle(fontSize: 18, color: kRedColor),
            ),
          ),
        ));
           }
}
