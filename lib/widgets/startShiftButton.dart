import 'package:emp_sys/statemanager/provider.dart';
import 'package:emp_sys/widgets/multi.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
     final Provider11 = Provider.of<Provider1>(context, listen: true);
    return  Padding(
      padding:EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 10,),
           Padding(
        padding:EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Multi(color: Colors.white, subtitle: "Shift Buttons", weight: FontWeight.w400, size: 4),
          ],
        ),
      ),
      SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                    child: NeumorphicButton(
                  onTap: () {
                   Provider11.shiftStarted==false? Provider11.startShiftTime():null;
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/128/159/159607.png',
                          height: size.width<1250?50:60,
                          color: Provider11.shiftStarted==true? Color.fromARGB(255, 29, 237, 36):Colors.grey[700]!,
                        ),
                        SizedBox(height: 10,),
                        Multi(color:  Provider11.shiftStarted==true? Color.fromARGB(255, 29, 237, 36):Colors.grey[700]!, subtitle: "Shift Start", weight: FontWeight.bold, size:size.width<1250?2.5: 3)
                      ],
                    ),
                
                  ),
                  bottomRightShadowBlurRadius: 15,
                  bottomRightShadowSpreadRadius: 1,
                  borderWidth: 5,
                  backgroundColor: Colors.grey.shade900,
                  topLeftShadowBlurRadius: 15,
                  topLeftShadowSpreadRadius: 1,
                  topLeftShadowColor: const Color.fromARGB(255, 48, 48, 48),
                  bottomRightShadowColor: Colors.black,
                  height: size.width<1250?100:120,
                  width: size.width<1250?100:120,
                  padding: EdgeInsets.only(top:5,bottom: 5),
                  bottomRightOffset: Offset(5, 5),
                  topLeftOffset: Offset(-5, -5),
                )
              ),
              
              Center(
                    child: NeumorphicButton(
                  onTap: () {
                    Provider11.endShiftTime();
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/128/2/2914.png',
                          height: size.width<1250?50:60,
                          color: Colors.grey[700],
                        ),
                        SizedBox(height: 10,),
                        Multi(color: Colors.grey[700]!, subtitle: "Shift End", weight: FontWeight.bold, size:size.width<1250?2.5: 3)
                      ],
                    ),
                
                  ),
                  bottomRightShadowBlurRadius: 15,
                  bottomRightShadowSpreadRadius: 1,
                  borderWidth: 5,
                  backgroundColor: Colors.grey.shade900,
                  topLeftShadowBlurRadius: 15,
                  topLeftShadowSpreadRadius: 1,
                  topLeftShadowColor: const Color.fromARGB(255, 48, 48, 48),
                  bottomRightShadowColor: Colors.black,
                  height: size.width<1250?100:120,
                  width: size.width<1250?100:120,
                  padding: EdgeInsets.only(top:5,bottom: 5),
                  bottomRightOffset: Offset(5, 5),
                  topLeftOffset: Offset(-5, -5),
                )
              ),
             Center(
                    child: NeumorphicButton(
                  onTap: () {
                   
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/128/50/50037.png',
                         height: size.width<1250?50:60,
                          color: Colors.grey[700],
                        ),
                        SizedBox(height: 10,),
                        Multi(color: Colors.grey[700]!, subtitle: "Early Leave", weight: FontWeight.bold, size:size.width<1250?2.5: 3)
                      ],
                    ),
                
                  ),
                  bottomRightShadowBlurRadius: 15,
                  bottomRightShadowSpreadRadius: 1,
                  borderWidth: 5,
                  backgroundColor: Colors.grey.shade900,
                  topLeftShadowBlurRadius: 15,
                  topLeftShadowSpreadRadius: 1,
                  topLeftShadowColor: const Color.fromARGB(255, 48, 48, 48),
                  bottomRightShadowColor: Colors.black,
                  height: size.width<1250?100:120,
                  width: size.width<1250?100:120,
                  padding: EdgeInsets.only(top:5,bottom: 5),
                  bottomRightOffset: Offset(5, 5),
                  topLeftOffset: Offset(-5, -5),
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}