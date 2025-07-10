import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../providers/country_provider.dart';
import '../../../routes/route_generator.dart';
import '../../../widgets/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      final countryProvider = Provider.of<CountryProvider>(context, listen: false);
      countryProvider.loadCountries();
      countryProvider.loadAirlines();
    });
    init();
  }


  
  Future<void> init() async {
    await  Future.delayed(const Duration(seconds: 2));
    
    final box = GetStorage();
    final hasSeenOnBoarding = box.read('onBoardingShown') ?? false;
    
    if(hasSeenOnBoarding){
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
