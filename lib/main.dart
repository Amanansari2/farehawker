import 'package:flightbooking/providers/country_provider.dart';
import 'package:flightbooking/providers/group_booking_provider.dart';
import 'package:flightbooking/providers/setup/provider_setup.dart';
import 'package:flightbooking/repository/auth_repo.dart';
import 'package:flightbooking/repository/country_repo.dart';
import 'package:flightbooking/repository/group_booking_repo.dart';
import 'package:flightbooking/routes/route_generator.dart';
import 'package:flightbooking/screen/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'api_services/api_request/get_request.dart';
import 'api_services/api_request/post_service.dart';
import 'api_services/app_logger.dart';
import 'api_services/internet_status.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // AppLogger.log("🔥 AppLogger is working");
  // final auth = AuthRepository();
  // await auth.loginIfNeeded();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers:appProviders,


        // [
        //   ChangeNotifierProvider<InternetMonitorProvider>(
        //     create: (_) => InternetMonitorProvider()..startMonitoring(),
        //   ),
        //
        //   ChangeNotifierProvider<LanguageChangeProvider>(
        //     create: (context) => LanguageChangeProvider(),
        //   ),
        //
        //   ChangeNotifierProvider<PostService>(
        //     create: (context) => PostService(),
        //   ),
        //
        //   Provider<GetService>(
        //     create: (_) => GetService(),
        //   ),
        //
        //   Provider<CountryRepository>(
        //     create: (context) => CountryRepository(
        //       Provider.of<GetService>(context, listen: false),
        //     ),
        //   ),
        //   ChangeNotifierProvider<CountryProvider>(
        //     create: (context) {
        //       final repo = Provider.of<CountryRepository>(context, listen: false);
        //       return  CountryProvider(repo);
        //
        //     },
        //   ),
        //
        //
        //
        //   ////////////////////////////////////////////////////////////////////
        //   Provider<GroupBookingRepository>(
        //     create: (context) => GroupBookingRepository(
        //       Provider.of<PostService>(context, listen: false),
        //     ),
        //   ),
        //
        //   ChangeNotifierProvider<GroupBookingController>(
        //     create: (context) => GroupBookingController(
        //       Provider.of<GroupBookingRepository>(context, listen: false),
        //     ),
        //   ),
        //
        //   /////////////////////////////////////////////////////
        // ],
        child:

            // Builder(
            //     builder: (context) => GetMaterialApp(
            //       debugShowCheckedModeBanner: false,
            //       locale: Provider.of<LanguageChangeProvider>(context, listen: true).currentLocale,
            //       localizationsDelegates:  const [
            //         S.delegate,
            //         GlobalMaterialLocalizations.delegate,
            //         GlobalWidgetsLocalizations.delegate,
            //         GlobalCupertinoLocalizations.delegate,
            //       ],
            //       supportedLocales: S.delegate.supportedLocales,
            //       title: 'Flight Booking',
            //       theme: ThemeData(fontFamily: 'Display'),
            //       home: const SplashScreen(),
            //     ),
            //   ),

            Builder(builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: Provider.of<LanguageChangeProvider>(context, listen: true)
                .currentLocale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            title: 'Flight Booking',
            theme: ThemeData(fontFamily: 'Display'),
            initialRoute: AppRoutes.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        }));
  }
}
