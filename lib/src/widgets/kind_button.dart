import 'package:flutter/material.dart';

import 'package:datingapp/src/constants/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// button types used in login course.
enum KindButtonType {
  appleLogin,
  googleLogin,
  twitterLogin,
  facebookLogin
}

class KindButton extends StatefulWidget {
  final KindButtonType btnType;
  final bool isLoading;
  final VoidCallback? onPressed;

  const KindButton({
    Key? key,
    required this.btnType,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<KindButton> createState() => _KindButtonState();
}

class _KindButtonState extends State<KindButton> {
  @override
  Widget build(BuildContext context) {
    String btnTitle;
    String imageType = "";
    Color? colorType;
    switch (widget.btnType) {
      case KindButtonType.appleLogin:
        btnTitle = "Appleでサインイン";
        imageType = "assets/images/button/button5.png";
        colorType = Color.fromARGB(255, 255, 255, 255);
        break;
      case KindButtonType.googleLogin:
        btnTitle = "Googleでサインイン";
        imageType = "assets/images/button/button4.png";
        colorType = Color.fromARGB(255, 0, 0, 0);
        break;
      case KindButtonType.twitterLogin:
        btnTitle = "Twitterでサインイン";
        imageType = "assets/images/button/button3.png";
        colorType = Color.fromARGB(255, 255, 255, 255);
        break;
      case KindButtonType.facebookLogin:
        btnTitle = "Facebookでサインイン";
        imageType = "assets/images/button/button2.png";
        colorType = Color.fromARGB(255, 255, 255, 255);
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
              imageType,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned.fill(
          child: TextButton(
            style: TextButton.styleFrom(
              shape: const StadiumBorder(),
              foregroundColor: colorType,
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
