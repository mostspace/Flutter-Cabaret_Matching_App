import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String type;

  const HeaderWidget({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items at the start and end of the row
        children: [
          Expanded(
            child: Container(
              child: Image.asset(
                'assets/images/icon/dot.png',
                height: 30,
              ),
            ),
          ),
          Spacer(),
          Expanded(
            child: Container(
              child: Image.asset(
                'assets/images/icon/text.png',
                height: 30,
              ),
            ),
          ),
          Spacer(),
          type == "add"?
          Expanded(
            child: InkWell(
              onTap: () {
              },
              child: Container(
                child: Image.asset(
                  'assets/images/icon/send_btn.png',
                  height: 30,
                ),
              ),
            )
          ): Expanded(
            child: Container(
              child: Image.asset(
                'assets/images/icon/notification.png',
                height: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
