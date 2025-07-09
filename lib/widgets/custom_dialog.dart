import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constant.dart';

class CustomDialogBox extends StatefulWidget {
  final String? title, descriptions, text;
  final String? img;
  final Color? titleColor;
  final Function? functionCall;

  const CustomDialogBox(
      {super.key,
        this.title,
        this.descriptions,
        this.text,
        this.img,
        this.titleColor,
        this.functionCall});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                widget.title == null
                    ? const SizedBox()
                    : Center(
                  child: Text(
                    widget.title!,
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: widget.titleColor),
                  ),
                ),
                widget.title == null
                    ? const SizedBox()
                    : const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.descriptions!,
                  //style: AppTextStyles.bodyTextStyle2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 22,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () => widget.functionCall!(),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        // height: 47,
                        width: MediaQuery.of(context).size.width * .5,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            widget.text!,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Constants.avatarRadius)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: widget.img != null
                      ? Image.asset(
                    widget.img!,
                    fit: BoxFit.cover,
                  )
                      : const SizedBox(),
                )),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}
