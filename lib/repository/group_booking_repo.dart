import 'package:flutter/material.dart';

import '../api_services/api_request/post_service.dart';
import '../api_services/configs/urls.dart';
import '../models/group_booking_model.dart';
import '../widgets/custom_dialog.dart';

class GroupBookingRepository {
  final PostService postService;

  GroupBookingRepository(this.postService);

  Future<void> submitGroupBooking(BuildContext context, GroupBooking booking) async {


    final postData = {
      'direction': booking.direction.toString(),
      'group_booking': booking.groupBooking,
      'origin': booking.origin,
      'destination': booking.destination,
      'dep_date': booking.depDate,
      'ret_date': booking.retDate,
      'adult': booking.adult,
      'child': booking.child,
      'infant': booking.infant,
      'c_num': booking.contactNumber,
      'c_email': booking.contactEmail,
    };
    print('Post Data: $postData');

    await postService.postFormMethod(
      context,
      groupBooking,
      postData,
      false,
                (context, success, response) {
        if(success){
         showDialog(
             context: context,
             builder: (BuildContext context){
               return CustomDialogBox(
                 title: "success",
                 descriptions: "Your booking has been successfully submitted",
                 text: "Okay",
                 img: "images/dialog_success.png",
                 titleColor: Colors.green,
                 functionCall: (){
                   Navigator.of(context).pop();
                 },
               );
             });
        } else{
          showDialog(
              context: context,
              builder: (BuildContext context){
                return CustomDialogBox(
                  title: "Failed",
                  descriptions: "Failed to submit Your booking. Please try again.",
                  text: "Retry",
                  img: "images/dialog_error.png",
                  titleColor: Colors.red,
                  functionCall: (){
                    Navigator.of(context).pop();
                  },
                );
              });
        }
      },
    );
  }
}
