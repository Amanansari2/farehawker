import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../routes/route_generator.dart';
import '../../../widgets/constant.dart';
import '../welcome_screen.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;

class OnBoard extends StatefulWidget {
  const OnBoard({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  double percent = 0.33;

  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'images/logo/onboard_f3.png',
    },
    {
      "icon": 'images/logo/onboard_f2.png',
    },
    {
      "icon": 'images/logo/onboard_f1.png',
    },
  ];

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
        body: PageView.builder(
          itemCount: sliderList.length,
          // physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (int index){
            setState(() {
              switch(index){
                case 0 :
                {
                  percent=0.33;
                  currentIndexPage=0;
                }
                break;
                case 1:
                  {
                    percent=0.66;
                    currentIndexPage=1;
                  }
                  break;
                case 2:
                  {
                    percent=1;
                    currentIndexPage=2;
                  }
              }
            });
          },
          itemBuilder: (_, i) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () async {
                        final box = GetStorage();
                        await box.write('onBoardingShown', true);
                        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
                      },

                      child: Text(
                        lang.S.of(context).skipButton,
                        style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 260,
                      width: context.width(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              sliderList[i]['icon'],
                            ),
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),


                  const SizedBox(height: 20.0),
                  Container(
                    width: context.width(),
                    height: context.height(),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36.0),
                          topRight: Radius.circular(36.0),
                        ),
                        color: kWhite,
                        boxShadow: [BoxShadow(color: kDarkWhite, spreadRadius: 2, blurRadius: 7, offset: Offset(0, -2))]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25.0),
                          SmoothPageIndicator(
                            controller: pageController,
                            count: 3,
                            axisDirection: Axis.horizontal,
                            effect: ExpandingDotsEffect(
                                spacing: 8.0,
                                radius: 30.0,
                                dotWidth: 10.0,
                                dotHeight: 5.0,
                                paintStyle: PaintingStyle.fill,
                                strokeWidth: 1.5,
                                dotColor: kPrimaryColor.withOpacity(0.1),
                                activeDotColor: kPrimaryColor),
                          ),
                          const SizedBox(height: 25.0),
                          Text(
                            currentIndexPage == 0
                                ?  'Welcome to FareHawker'
                                : currentIndexPage == 1
                                    ? 'Easy Group & Charter Booking '
                                    : 'Best Deals & Dedicated Support',
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            currentIndexPage == 0
                                ?'Your one-stop partner for group flights. \nPlan trips for corporates, weddings, schools, or family vacations with ease.'
                              : currentIndexPage == 1
                              ?'Book for 10+ passengers hassle-free. \nBlock seats, and confirm names later—bulk travel made simple.'
                              :'Grab exclusive deals and 24/7 support. \nGet real-time alerts, flexible payments, and a smooth travel experience.',
                            style: kTextStyle.copyWith(
                              color: kSubTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40.0),
                          CircularPercentIndicator(
                            radius: 40.0,
                            lineWidth: 2.0,
                            percent: percent,
                            animation: true,
                            progressColor: kPrimaryColor,
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: kPrimaryColor.withOpacity(0.1),
                            center: GestureDetector(
                              onTap: ()  async {
                                // setState(
                                //   () {
                                    // currentIndexPage < 2
                                    //     ? pageController.nextPage(duration: const Duration(microseconds: 3000),
                                    //     curve: Curves.bounceInOut)
                                    //     : Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (context) => const WelcomeScreen(),
                                    //         ),
                                    //       );
                                //   },
                                // );

                                if(currentIndexPage < 2) {
                                  pageController.nextPage(duration: const Duration(milliseconds: 300),
                                  curve: Curves.bounceInOut);
                                }else{
                                  final box = GetStorage();
                                  await box.write('onBoardingShown', true);
                                  Navigator.pushReplacementNamed(context, AppRoutes.welcome);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor),
                                child: const Icon(
                                  FeatherIcons.chevronsRight,
                                  color: kWhite,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
