
import 'package:flutter/material.dart';


class MyiconButtonWidget extends StatelessWidget {
  final IconData icon;
  final double? radius;
  final Color? color;
  final Color? iconColor;
  
 MyiconButtonWidget({super.key,
   required this.icon, 
  this.radius,
   this.color =Colors.white, this.iconColor= Colors.black});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      child: Center(
        child: Icon(icon,color: iconColor,),
      ),
    );
  }
}
