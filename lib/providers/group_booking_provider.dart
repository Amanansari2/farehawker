import 'package:flutter/material.dart';

import '../models/group_booking_model.dart';
import '../repository/group_booking_repo.dart'; // Adjust the import path

class GroupBookingController extends ChangeNotifier {
  final GroupBookingRepository repository;

  GroupBookingController(this.repository);



  Future<void> submitForm(BuildContext context, GroupBooking booking) async {
    await repository.submitGroupBooking(context, booking);
  }
}
