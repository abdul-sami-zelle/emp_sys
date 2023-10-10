import 'package:emp_sys/widgets/digitalText.dart';
import 'package:emp_sys/widgets/multi.dart';
import 'package:flutter/material.dart';

class LastStatis extends StatelessWidget {
  const LastStatis({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child:Row(
                                children: [
                                   Expanded(
                              flex: 2,
                              child: Padding(
                                padding:EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                           Multi(
                                  color: Color(0xff8F95A2),
                                  subtitle: "Last Check in",
                                  weight: FontWeight.bold,
                                  size: 3.5),
                                          Image.asset("assets/images/in.png",height: 35,width: 35,),
                                        ],
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
                                      size: 5),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Multi(
                                      color: Colors.white,
                                      subtitle: "sec",
                                      weight: FontWeight.w300,
                                      size: 3),
                                ],
                                                          ),
                                                          SizedBox(
                                width: 1,
                                                          ),
                                                         
                                        ],
                                      )
                                    ],
                                  ) ,
                                ),
                              ) 
                            ),
                             Expanded(
                              flex: 2,
                              child:Padding(
                                padding:EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                           Multi(
                                  color: Color(0xff8F95A2),
                                  subtitle: "Last Check Out",
                                  weight: FontWeight.bold,
                                  size: 3.5),
                                          Image.asset("assets/images/out1.png",height: 35,width: 35,),
                                        ],
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
                                      size: 5),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Multi(
                                      color: Colors.white,
                                      subtitle: "sec",
                                      weight: FontWeight.w300,
                                      size: 3),
                                ],
                                                          ),
                                                          SizedBox(
                                width: 1,
                                                          ),
                                                         
                                        ],
                                      )
                                    ],
                                  ) ,
                                ),
                              )  
                            )
                                ],
                              ) 
                            ),
                             Expanded(
                              flex: 2,
                              child:Row(
                                children: [
                                   Expanded(
                              flex: 2,
                              child:Padding(
                                padding:EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                           Multi(
                                  color: Color(0xff8F95A2),
                                  subtitle: "Last Shift Start",
                                  weight: FontWeight.bold,
                                  size: 3.5),
                                          Image.network("assets/images/shiftStart.png",height: 30,width: 30,),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Digital(
                                      color: Colors.white,
                                      subtitle: "08:00:40",
                                      weight: FontWeight.w600,
                                      size: 5),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Multi(
                                      color: Colors.white,
                                      subtitle: "",
                                      weight: FontWeight.w300,
                                      size: 3),
                                ],
                                                          ),
                                                          SizedBox(
                                width: 1,
                                                          ),
                                                         
                                        ],
                                      )
                                    ],
                                  ) ,
                                ),
                              )  
                            ),
                             Expanded(
                              flex: 2,
                              child:Padding(
                                padding:EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                           Multi(
                                  color: Color(0xff8F95A2),
                                  subtitle: "Last Shift End",
                                  weight: FontWeight.bold,
                                  size: 3.5),
                                          Image.network("assets/images/shiftend.png",height: 30,width: 30,),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Digital(
                                      color: Colors.white,
                                      subtitle: "18:00:40",
                                      weight: FontWeight.w600,
                                      size: 5),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Multi(
                                      color: Colors.white,
                                      subtitle: "",
                                      weight: FontWeight.w300,
                                      size: 3),
                                ],
                                                          ),
                                                          SizedBox(
                                width: 1,
                                                          ),
                                                         
                                        ],
                                      )
                                    ],
                                  ) ,
                                ),
                              )  
                            )
                                ],
                              ) 
                            ),
                          ],
                        );
  }
}