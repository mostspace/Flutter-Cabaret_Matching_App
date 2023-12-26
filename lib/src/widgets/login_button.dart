import 'package:flutter/material.dart';

import 'package:datingapp/src/constants/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// button types used in login course.
enum LoginButtonType {
  startBtn,
  privacyBtn,
  workBtn,
  hireBtn,
  checkBtn,
  imgUploadBtn,
  saveBtn,
  addScheduleBtn,
  scheduleSaveBtn
}

class LoginButton extends StatefulWidget {
  final LoginButtonType btnType;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoginButton({
    Key? key,
    required this.btnType,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    String btnTitle;
    switch (widget.btnType) {
      case LoginButtonType.startBtn:
        btnTitle = "サインイン";
        break;
      case LoginButtonType.privacyBtn:
        btnTitle = "18歳以上";
        break;
      case LoginButtonType.workBtn:
        btnTitle = "お店で働いている";
        break;
      case LoginButtonType.hireBtn:
        btnTitle = "お店に遊びに行く";
        break;
      case LoginButtonType.checkBtn:
        btnTitle = "次へ";
        break;
      case LoginButtonType.imgUploadBtn:
        btnTitle = "プロフィール設定完了";
        break;
      case LoginButtonType.saveBtn:
        btnTitle = "保存";
        break;
      case LoginButtonType.addScheduleBtn:
        btnTitle = "セット登録する";
        break;
      case LoginButtonType.scheduleSaveBtn:
        btnTitle = "予約一覧";
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
              'assets/images/button/button.png',
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
