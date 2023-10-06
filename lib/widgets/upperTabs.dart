import 'package:drop_shadow/drop_shadow.dart';
import 'package:emp_sys/statemanager/provider.dart';
import 'package:emp_sys/widgets/multi.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_switch/sliding_switch.dart';

class UpperTabs extends StatelessWidget {
  String? tabFor;
  Color color1;
  String? duration;
  String? img;
  bool? active;
  String? breakFor;
  final controller1;
  UpperTabs(
      {super.key,
      required this.tabFor,
      required this.color1,
      required this.duration,
      required this.img,
      required this.active,
      required this.breakFor,
      required this.controller1});

  @override
  Widget build(BuildContext context) {
    final Provider11 = Provider.of<Provider1>(context, listen: true);
    final _controller = ValueNotifier<bool>(active!);
    final size = MediaQuery.of(context).size;
    return Container(
      height: 160,
      width: (size.width < 1320 && size.width > 1161)
          ? 220
          : (size.width < 1161)
              ? 190
              : (size.width > 1600)
                  ? 270
                  : 250,
      decoration: BoxDecoration(
          color: Color(0xff1F2123), borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Container(
          height: 130,
          width: 240,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: color1),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Container(
              height: 125,
              width: 195,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff1F2123)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: -2.5,
                    left: -2.5,
                    child: Container(
                      height: 110,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: Color(0xff1F2123)),
                    ),
                  ),
                  Positioned(
                      child: Padding(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              "${img}",
                              height: 35,
                              width: 35,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Multi(
                                        color: Colors.white,
                                        subtitle: "100",
                                        weight: FontWeight.w600,
                                        size: 7),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Multi(
                                        color: color1,
                                        subtitle: "sec",
                                        weight: FontWeight.w300,
                                        size: 3),
                                  ],
                                ),
                                SizedBox(
                                  width: 1,
                                ),
                                Multi(
                                    color: Color(0xff8F95A2),
                                    subtitle: "$tabFor",
                                    weight: FontWeight.w300,
                                    size: 3),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Stack(
                      children: [
// AdvancedSwitch(
//                           controller: controller1,
//                           activeColor: color1,

//                           inactiveColor: Color(0xff424344),
//                           activeChild: Text('ON'),
//                           inactiveChild: Text('OFF'),
//                           borderRadius: BorderRadius.all(const Radius.circular(15)),
//                           width: 60.0,
//                           height: 30.0,
//                           enabled: true,
//                           disabledOpacity: 0.5,

//                         )
                        SlidingSwitch(
                          value: active!,
                          width: 60,
                          onChanged: (bool value) {
                            null;
                          },
                          height: 30,
                          animationDuration: const Duration(milliseconds: 100),
                          onTap: () {
                            Provider11.changeActiveBreakIndex(breakFor!);
                          },
                          onDoubleTap: () {
                            Provider11.changeActiveBreakIndex(breakFor!);
                          },
                          onSwipe: () {
                            Provider11.changeActiveBreakIndex(breakFor!);
                          },
                          textOff: "Off",
                          textOn: "On",
                          contentSize: 9,
                          colorOn: color1,
                          colorOff: const Color(0xff6682c0),
                          background:
                              active == true ? color1 : Color(0xff424344),
                          buttonColor: const Color(0xfff7f5f7),
                          inactiveColor: Colors.white,
                        ),
                        //  active==true?Container():Positioned(
                        //     top: -5,
                        //     child: DropShadow(
                        //       blurRadius: 2,
                        //       child: Container(
                        //         width: 60.0,
                        //         height: 40.0,
                        //         decoration: BoxDecoration(
                        //           gradient: LinearGradient(
                        //             colors: [Colors.transparent, Colors.transparent],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                  active == true
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 35,
                            width: 35,
                            child: LoadingIndicator(
                                indicatorType: Indicator.ballScaleMultiple,
                                colors: [color1],
                                strokeWidth: 0.5,
                                backgroundColor: Colors.transparent,
                                pathBackgroundColor: Colors.black),
                          ))
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
