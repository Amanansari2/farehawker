import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../widgets/constant.dart';
import '../../../widgets/notifications.dart';

class NotificationSc extends StatefulWidget {
  const NotificationSc({Key? key}) : super(key: key);

  @override
  State<NotificationSc> createState() => _NotificationScState();
}

class _NotificationScState extends State<NotificationSc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kBlueColor,
        iconTheme: const IconThemeData(color: kWhite),
        title: Text(
          'Notification',
          style: kTextStyle.copyWith(
            color: kWhite,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            padding: EdgeInsets.zero,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('All Clear').onTap(() => Navigator.pop(context)),
              ),
              // popupmenu item 2
            ],
            offset: const Offset(0, 30),
            color: kWhite,
            elevation: 1.0,
          )
        ],
      ),
      body: const Notifications(),
    );
  }
}

