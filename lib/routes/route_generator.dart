import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/screen/Authentication/forgot_password.dart';
import 'package:flightbooking/screen/Authentication/login_screen.dart';
import 'package:flightbooking/screen/Authentication/splash%20screen/onboard.dart';
import 'package:flightbooking/screen/Authentication/splash%20screen/splash_screen.dart';
import 'package:flightbooking/screen/Authentication/welcome_screen.dart';
import 'package:flightbooking/screen/book%20proceed/book_proceed.dart';
import 'package:flightbooking/screen/book%20proceed/round_trip_book_proceed.dart';
import 'package:flightbooking/screen/home/home_screen.dart';
import 'package:flightbooking/screen/notifications/notification.dart';
import 'package:flightbooking/screen/payment/payment.dart';
import 'package:flightbooking/screen/pricing/oneway/round_trip_pricing.dart';
import 'package:flightbooking/screen/profile/my_profile/my_profile.dart';
import 'package:flightbooking/screen/profile/privacy_policy/privacy_policy.dart';
import 'package:flightbooking/screen/profile/refund_policy/refund_policy.dart';
import 'package:flightbooking/screen/profile/reset_password/reset_password.dart';
import 'package:flightbooking/screen/profile/terms_condition/terms_condition.dart';
import 'package:flightbooking/screen/search/filter.dart';
import 'package:flightbooking/screen/search/flight_details.dart';
import 'package:flightbooking/screen/search/round_trip_flight_details.dart';
import 'package:flightbooking/screen/search/search.dart';
import 'package:flightbooking/screen/search/search_result.dart';
import 'package:flightbooking/screen/seat_map_screen/seat_map_round_trip_screen.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/material.dart';

import '../models/flight_details_model.dart';
import '../screen/home/home.dart';
import '../screen/pricing/oneway/one_way_pricing.dart';
import '../screen/profile/profile_screen.dart';
import '../screen/search/round_trip_search_result.dart';
import '../screen/seat_map_screen/seat_map_screen_for_one_way.dart';

class AppRoutes {

 static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const String splash = "/";
  static const String onBoard = "/OnBoard";
  static const String welcome = "/WelcomeScreen";
  static const String login = "/LogInScreen";
  static const String home = "/HomeScreen";
  static const String profile = "/Profile";
  static const String myProfile = "/MyProfile";
  static const String resetPassword = "/ResetPassword";
  static const String forgotPassword = "/ForgotPassword";
  static const String termsCondition = "/TermsConditions";
  static const String privacyPolicy = "/PrivacyPolicy";
  static const String refundPolicy = "/RefundPolicy";
  static const String notification = "/NotificationSc";
  static const String search = "/Search";
  static const String searchResult = "/SearchResult";
  static const String searchRoundTripResult = "/SearchRoundTripResult";
  static const String filter = "/Filter";
  static const String flightDetails = "/FlightDetails";
  static const String roundTripFlightDetails = "/RoundTripFlightDetails";
  static const String pricingRules = "/PricingTabView";
  static const String roundTripPricingRules = "/RoundTripPricingTabView";
  static const String bookProceed = "/BookProceed";
  static const String roundTripBookProceed = "/RoundTripBookProceed";
 static const String payment = "/Payment";
 static const String seatMap = "/SeatMap";
 static const String roundTripSeatMap = "/RoundTripSeatMapScreen";
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

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LogIn());

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) =>   Home());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const Profile());

      case AppRoutes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPassword());

      case AppRoutes.myProfile:
        return MaterialPageRoute(builder: (_) => const MyProfile());

      case AppRoutes.termsCondition:
        return MaterialPageRoute(builder: (_) => const TermsConditions());

      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicy());

      case AppRoutes.refundPolicy:
        return MaterialPageRoute(builder: (_) => const RefundPolicy());

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

      case AppRoutes.pricingRules:
        final args = settings.arguments;
        if(args is FlightDetail) {
        return MaterialPageRoute(
            builder: (_) => PricingTabView(flight: args,),
          );
        }
        return _errorRoute("Invalid or missing Details ");

      case AppRoutes.roundTripPricingRules:
        final args = settings.arguments;
        if(args is Map<String, dynamic>){
          final onwardp = args['onwardFlight'];
          final returnp = args['returnFlight'];
        if(onwardp is FlightDetail && returnp is FlightDetail){
    return MaterialPageRoute(
    builder: (_) =>  RoundTripPricingTabView(onwardFlight: onwardp,
    returnFlight: returnp,));
        }
        }
        return _errorRoute("Invalid or Missing RoundTripBookProceed arguments");




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

      case AppRoutes.seatMap:
        
        final args = settings.arguments;
        if(args is FlightDetail) {
          return MaterialPageRoute(
            builder: (_) => SeatMapScreen(flight: args,),
            // builder: (_) => NewSeatMapScreen(),
          );
        }
        return _errorRoute("Invalid or missing FlightDetail for SeatMap");
          
      case AppRoutes.roundTripSeatMap:
        final args = settings.arguments;
        if(args is Map<String, dynamic>){
          final onwardm = args['onwardFlight'];
          final returnm = args['returnFlight'];
          if(onwardm is FlightDetail && returnm is FlightDetail){
            return MaterialPageRoute(
                builder: (_) => RoundTripSeatMapScreen(
                  onwardFlight: onwardm, returnFlight: returnm,
                ));
          }
        }

        return _errorRoute("Invalid or missing Round trip meal details");


      case AppRoutes.payment:
        final args = settings.arguments;
        if(args is FlightDetail){
          return MaterialPageRoute(builder: (_) => Payment(onwardFlight: args));
        }else if(args is Map<String, dynamic>){
          final onward = args['onwardFlight'];
          final returnF = args['returnFlight'];
          if(onward is FlightDetail){
            return MaterialPageRoute(builder: (_) => Payment(onwardFlight: onward, returnFlight: returnF is FlightDetail ? returnF : null,));
          }
        }
        return _errorRoute("Invalid or missing payment arguments");


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
