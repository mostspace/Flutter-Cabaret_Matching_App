import 'package:flutter/material.dart';

import 'package:datingapp/src/constants/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// button types used in login course.
enum LogoutButtonType {
  outBtn
}

class LogoutButton extends StatefulWidget {
  final LogoutButtonType btnType;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LogoutButton({
    Key? key,
    required this.btnType,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    String btnTitle;
    switch (widget.btnType) {
      case LogoutButtonType.outBtn:
        btnTitle = "18歳未満";
        break;
      default:
        btnTitle = "Unknown";
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
          child: SizedBox(
            width: kTextfieldW /1.05,
            child: Image.asset(
              'assets/images/button/button6.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned.fill(
          child: TextButton(
            style: TextButton.styleFrom(
              shape: const StadiumBorder(),
              foregroundColor: Colors.white,
              textStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 45.sp,
              ),
            ),
            onPressed: widget.onPressed,
            child: Text(btnTitle),
          ),
        ),
      ],
    );
  }
}
