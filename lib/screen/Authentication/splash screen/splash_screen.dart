import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../../providers/country_provider.dart';
import '../../../repository/auth_repo.dart';
import '../../../routes/route_generator.dart';
import '../../../widgets/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final countryProvider =
          Provider.of<CountryProvider>(context, listen: false);
      countryProvider.loadCountries();
      countryProvider.loadAirlines();
      countryProvider.loadAirport();
    });
    init();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));

    final hasSeenOnBoarding = box.read('onBoardingShown') ?? false;
    final  token = box.read('token');
    final storedProfile  = box.read('profile');



    if (token != null && storedProfile != null) {
      final int userId = storedProfile['id'];
      AppLogger.log("User ID: $userId");
      AppLogger.log("Token -->>> $token");

      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
   final success =   await loginProvider.fetchAndStoreProfile(userId, context: context);
   if(success && mounted) {
     Navigator.pushReplacementNamed(context, AppRoutes.home);
     AppLogger.log("get User profile fetched");
   }
   if(mounted){
     Navigator.pushReplacementNamed(context, AppRoutes.login);
   }

    } else if (hasSeenOnBoarding) {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onBoard);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
        body: Center(
          child: Container(
            width: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/logo/farehawker_logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
