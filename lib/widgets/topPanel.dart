import 'package:emp_sys/statemanager/provider.dart';
import 'package:emp_sys/widgets/upperTabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class TopPanel extends StatelessWidget {
  const TopPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final Provider11 = Provider.of<Provider1>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        UpperTabs(tabFor: "Call Break", color1: Color(0xff64FDC2), duration: "100", img: 'https://firebasestorage.googleapis.com/v0/b/zelleclients.appspot.com/o/phone-call.png?alt=media&token=36f62971-1774-48f9-b11d-b0125da7263a', active: Provider11.call_break, breakFor: '0', controller1: Provider11.call_break_controller,),
        UpperTabs(tabFor: "Namaz Break", color1: Color(0xffFFB976), duration: "100", img: 'https://firebasestorage.googleapis.com/v0/b/zelleclients.appspot.com/o/beads.png?alt=media&token=7c536bf9-d6f5-4acc-8ab6-f6ddf4b9d5bd', active: Provider11.namaz_break, breakFor: '1', controller1: Provider11.namaz_break_controller,),
        UpperTabs(tabFor: "Lunch Break", color1: Color(0xffAE8BFF), duration: "100", img:  'https://firebasestorage.googleapis.com/v0/b/zelleclients.appspot.com/o/breakfast.png?alt=media&token=1b059be2-fcbd-4556-acff-e9c790de755f', active: Provider11.lunch_break, breakFor: '2', controller1: Provider11.lunch_break_controller,),
        UpperTabs(tabFor: "Casual Break", color1: Color(0xff48A7FF), duration: "100", img: 'https://firebasestorage.googleapis.com/v0/b/zelleclients.appspot.com/o/other.png?alt=media&token=657c9d78-995c-4ded-9784-9cc1ab34a1ca', active: Provider11.casual_break, breakFor: '3', controller1: Provider11.casual_break_controller,),
        UpperTabs(tabFor: "Summit Break", color1: Color(0xff4832A2), duration: "100", img: 'https://firebasestorage.googleapis.com/v0/b/zelleclients.appspot.com/o/star.png?alt=media&token=b76f1221-7c00-4350-8064-e0b41fb9428c', active: Provider11.summit_break, breakFor: '4', controller1: Provider11.summit_break_controller,),
      ],
    );
  }
}