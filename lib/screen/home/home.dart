
import 'package:flightbooking/screen/History_Screen/history_screen.dart';
import 'package:flightbooking/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flightbooking/generated/l10n.dart' as lang;
import 'package:get_storage/get_storage.dart';
import '../../widgets/constant.dart';
import '../../widgets/custom_dialog.dart';
import '../Authentication/login_screen.dart';
import '../group screen/group_screen.dart';
import '../my_boking_screen/my_boking.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
   Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
//
// class _HomeState extends State<Home> {
//   int _currentPage = 0;
//
//   static const List<Widget> _widgetOptions = <Widget>[
//     HomeScreen(),
//     GroupBookingScreen(),
//     MyBooking(),
//     // History(),
//      Profile(),
//
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _widgetOptions.elementAt(_currentPage),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.only(bottom: 10.0),
//         child: BottomNavigationBar(
//           elevation: 0.0,
//           selectedItemColor: kBlueColor,
//           unselectedItemColor:  kPrimaryColor,
//           backgroundColor: Colors.white,
//           showUnselectedLabels: true,
//           items: [
//             /// Home
//             BottomNavigationBarItem(
//               icon: const Icon(IconlyBold.home),
//               label: lang.S.of(context).navBarTitle1,
//             ),
//
//             BottomNavigationBarItem(
//               icon: const Icon(IconlyBold.user3),
//               label: lang.S.of(context).navBarTitle5,
//             ),
//
//             BottomNavigationBarItem(
//               icon: const Icon(IconlyBold.bookmark),
//               label: lang.S.of(context).navBarTitle2,
//             ),
//
//             // BottomNavigationBarItem(
//             //   icon: const Icon(IconlyBold.document),
//             //   label: lang.S.of(context).navBarTitle3,
//             // ),
//
//             BottomNavigationBarItem(
//               icon: const Icon(IconlyBold.profile),
//               label: lang.S.of(context).navBarTitle4,
//             ),
//           ],
//           onTap: (int index) {
//             setState(() => _currentPage = index);
//           },
//           currentIndex: _currentPage,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMyBookingOrDialog() {
//     final token = box.read('token');
//     if (token != null) {
//       return const MyBooking();
//     }
//     return const SizedBox(); // Fallback empty widget
//   }
// }


class _HomeState extends State<Home> {
  final box = GetStorage();
  int _currentPage = 0;

  final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const GroupBookingScreen(),
    Container(), // Placeholder for MyBooking
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage == 2
          ? _buildMyBookingOrDialog()
          : _widgetOptions.elementAt(_currentPage),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: BottomNavigationBar(
          elevation: 0.0,
          selectedItemColor: kBlueColor,
          unselectedItemColor: kPrimaryColor,
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(IconlyBold.home),
              label: lang.S.of(context).navBarTitle1,
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconlyBold.user3),
              label: lang.S.of(context).navBarTitle5,
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconlyBold.bookmark),
              label: lang.S.of(context).navBarTitle2,
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconlyBold.profile),
              label: lang.S.of(context).navBarTitle4,
            ),
          ],
          onTap: (int index) {
            if (index == 2) {
              final token = box.read('token');
              if (token == null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialogBox(
                      title: 'Login Required',
                      descriptions: 'Please login first to view your profile.',
                      text: 'ok',
                      img: "images/dialog_error.png",
                      titleColor: kRedColor,
                      functionCall: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogIn(),
                          ),
                        );
                      },
                    );
                  },
                );
                return;
              }
            }

            setState(() {
              _currentPage = index;
            });
          },
          currentIndex: _currentPage,
        ),
      ),
    );
  }

  Widget _buildMyBookingOrDialog() {
    final token = box.read('token');
    if (token != null) {
      return const MyBooking();
    }
    return const SizedBox(); // Fallback empty widget
  }
}





