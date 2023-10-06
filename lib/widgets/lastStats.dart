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
                                          Image.network("https://firebasestorage.googleapis.com/v0/b/zelleclients.appspot.com/o/in.png?alt=media&token=cd3a80bc-0efd-4a40-ac40-3e4609d7a5a3",height: 35,width: 35,),
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
                                          Image.network("https://firebasestorage.googleapis.com/v0/b/zelleclients.appspot.com/o/out1.png?alt=media&token=7d2a1348-032e-41fd-a1b4-ade453a7e528",height: 35,width: 35,),
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
                                          Image.network("https://firebasestorage.googleapis.com/v0/b/zelleclients.appspot.com/o/shiftStart.png?alt=media&token=29a61c0e-7330-4324-82ef-e0ad4273f71c",height: 30,width: 30,),
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
                                          Image.network("https://firebasestorage.googleapis.com/v0/b/zelleclients.appspot.com/o/shiftend.png?alt=media&token=99e1ed36-6cfd-42de-b5c1-cd48d0b4c770",height: 30,width: 30,),
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