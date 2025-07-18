import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/models/country_list_model.dart';
import 'package:flightbooking/models/search_result_arguments.dart';
import 'package:flightbooking/screen/Authentication/splash%20screen/onboard.dart';
import 'package:flightbooking/screen/Authentication/splash%20screen/splash_screen.dart';
import 'package:flightbooking/screen/Authentication/welcome_screen.dart';
import 'package:flightbooking/screen/profile/setting/notification.dart';
import 'package:flightbooking/screen/search/search.dart';
import 'package:flightbooking/screen/search/search_result.dart';
import 'package:flutter/material.dart';

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


      default:
        AppLogger.log('⚠️ Route not found: ${settings.name}');
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text(
                      '404 - Page not found',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
                ));
    }
  }
}
