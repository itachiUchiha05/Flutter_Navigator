import 'package:flutter/material.dart';
import 'package:flutter_navigator/utils/constant.dart';

class RadioButton extends StatelessWidget {
  final String value;
  final String groupvalue;
  final String title;
  final Function onchanged;
  const RadioButton({Key? key,required this.title, required this.groupvalue,required this.value,required this.onchanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(value: value, groupValue: groupvalue, onChanged: (value) {
          onchanged(value);
        }),
         Text(title,style: TextStyle(
            fontSize: 14,
            color: KDarkAppBarColor
        ),)
      ],
    );
  }
}
