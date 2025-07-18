import 'package:flightbooking/providers/setup/provider_setup.dart';
import 'package:flightbooking/routes/route_generator.dart';
import 'package:flightbooking/screen/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:nb_utils/nb_utils.dart' hide S;
import 'package:provider/provider.dart';
import 'generated/l10n.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers:appProviders,
        child:
            Builder(builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            locale: Provider.of<LanguageChangeProvider>(context, listen: true)
                .currentLocale,
            localizationsDelegates:  const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            navigatorKey: AppRoutes.navigatorKey,
            supportedLocales: S.delegate.supportedLocales,
            title: 'Flight Booking',
            theme: ThemeData(fontFamily: 'Display'),
            initialRoute: AppRoutes.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        }));
  }
}
