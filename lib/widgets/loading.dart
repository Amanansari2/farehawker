import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlightTakeoffAnimation extends StatefulWidget {
  const FlightTakeoffAnimation({super.key});

  @override
  State<FlightTakeoffAnimation> createState() => _FlightTakeoffAnimationState();
}

class _FlightTakeoffAnimationState extends State<FlightTakeoffAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));



    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child:  SlideTransition(
        position: _offsetAnimation,
        child: const Icon(
          Icons.flight,
          color: kBlueColor,
          size: 120,
        ),
      ),
    );
  }
}
