import 'package:emp_sys/widgets/multi.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class EmployeeProfile extends StatelessWidget {
  const EmployeeProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding:EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        primary: true,
        scrollDirection: Axis.vertical,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: size.height/1.2,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DetailedInfo(),
                      SizedBox(height: 20,),
                      TaskStats()
                    ],
                  ),
                ),
              ),
              ProgressDetails()
            ],
          )
        ],
      ),
    );
  }
}





class DetailedInfo extends StatelessWidget {
  const DetailedInfo({super.key});

  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    return Container(
      width: size.width/1.6,
      height: size.height/2.85,
      decoration: BoxDecoration(
        color: Color(0xff1F2123),
                                    borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20,top: 10),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(),
                SizedBox(width: 30,),
                Container(
                  height:size.height/3.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Multi(color: Colors.white, subtitle: "Abdul Sami", weight: FontWeight.bold, size: 6),
                   
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Multi(color: Colors.white, subtitle: "Position", weight: FontWeight.w500, size: 3),
                        SizedBox(width: 30,),
                        Multi(color: Colors.white, subtitle: "     Flutter Developer", weight: FontWeight.w500, size: 3),
                      ],),
                   
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Multi(color: Colors.white, subtitle: "Role", weight: FontWeight.w500, size: 3),
                        SizedBox(width: 30,),
                        Multi(color: Colors.white, subtitle: "            User", weight: FontWeight.w500, size: 3),
                      ],),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Multi(color: Colors.white, subtitle: "Email", weight: FontWeight.w500, size: 3),
                        SizedBox(width: 30,),
                        Multi(color: Colors.white, subtitle: "          abdulsami.zellesolutions@gmail.com", weight: FontWeight.w500, size: 3),
                      ],),
                   
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Multi(color: Colors.white, subtitle: "Phone", weight: FontWeight.w500, size: 3),
                        SizedBox(width: 30,),
                        Multi(color: Colors.white, subtitle: "        7703171707283", weight: FontWeight.w500, size: 3),
                      ],),
                   
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Multi(color: Colors.white, subtitle: "Company", weight: FontWeight.w500, size: 3),
                        SizedBox(width: 30,),
                        Multi(color: Colors.white, subtitle: "   Zelle Solutions", weight: FontWeight.w500, size: 3),
                      ],),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: 10,
              right: 20,
              child: Row(
                children: [
                  Image.network("https://cdn-icons-png.flaticon.com/128/3536/3536505.png",width:20,height:20,),
                  SizedBox(width: 10,),
                  Image.network("https://cdn-icons-png.flaticon.com/128/1409/1409946.png",width:20,height:20,),
                  SizedBox(width: 10,),
                  Image.network("https://cdn-icons-png.flaticon.com/128/733/733547.png",width:20,height:20,),
                ],
              ))
          ],
        ),
      ),
    );
  }
}



class ProgressDetails extends StatelessWidget {
  const ProgressDetails({super.key});

  @override
  Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;
         final List<ChartData> chartData = [
            ChartData('David', 25, Color(0xff0DEEFF)),
            ChartData('Steve', 38, Color(0xff086EDC)),
            ChartData('Jack', 34, Color(0xff0E2D6D)),
          
        ];
    return Container(
      width:
      (size.width<1201&&size.width>1000)?size.width/3.55
      :(size.width<1001&&size.width>899)?size.width/3.7
      :(size.width<900&&size.width>700)?size.width/3.9
      :size.width/3.45,
      height: size.height/1.2,
      decoration: BoxDecoration(
        color: Color(0xff1F2123),
                                    borderRadius: BorderRadius.circular(10)
      ),
      child:Container(
   
        child: Padding(
          padding:EdgeInsets.all(25),
          child: Column(
            children: [
              Container(
                    
                child: SfCircularChart(
                 legend: Legend(
                
                  isResponsive: true,
                  position: LegendPosition.top,
                  isVisible: true
                 ),
                
                    annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            
                            widget: 
                              Container(
                                height:size.width/12.5,
                    width: size.width/12.5,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage("https://res.cloudinary.com/diecwxxmm/image/upload/v1697084087/zellesolutions%20portal/nh5ub0ynyfwvi5c9wnac.jpg"),fit:BoxFit.cover),
                color: Colors.red,
                shape: BoxShape.circle,
                      
                    ),
                              ),
                          )
                        ],
                                series: <CircularSeries>[
                                    RadialBarSeries<ChartData, String>(
                                      radius: '145',
                                      trackBorderWidth: 30,
                                      
                                      gap: "5",
                                      strokeColor: Color(0xff1F2123),
                                        dataSource: chartData,
                                        trackColor: Color(0xff414243),
                                        pointColorMapper:(ChartData data, _) => data.color ,
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.y,
                                        // Corner style of radial bar segment
                                        cornerStyle: CornerStyle.bothCurve
                                    )
                                ]
                            ),
              ),

              CircularPercentIndicator(
                  radius: 30,
                  lineWidth: 10.0,
                  percent: 0.4,
                  circularStrokeCap: CircularStrokeCap.round,
                  center:  Text("100%"),
                  progressColor:Colors.amber
                )
            ],
          ),
        )
      ),
    );
  }
}


class TaskStats extends StatelessWidget {
  const TaskStats({super.key});

  @override
  Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;
    return Container(
      width:  size.width/1.6,
      height: size.height/2.2,
      decoration: BoxDecoration(
        color: Color(0xff1F2123),
                                    borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}




class CircleAvatar extends StatelessWidget {
  const CircleAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right:-5 ,
          bottom: -5,
          child:  Container(
          height:size.height/3.7,
          width: size.height/3.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20)
            ),
            border: Border.all(width: 1,color: Colors.white),
            
            shape: BoxShape.rectangle,
              
                                        
          ),
        ),
          ),
            Positioned(
          right:-4 ,
          bottom: -4,
          child:  Container(
          height:size.height/3.7,
          width: size.height/3.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20)
            ),
           color: Color(0xff1F2123),
            
            shape: BoxShape.rectangle,
              
                                        
          ),
        ),
          ),
        Container(
          height:size.height/3.5,
          width: size.height/3.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          
            shape: BoxShape.rectangle,
              
                                        image: DecorationImage(image: NetworkImage("https://res.cloudinary.com/diecwxxmm/image/upload/v1697084087/zellesolutions%20portal/nh5ub0ynyfwvi5c9wnac.jpg"),fit:BoxFit.cover),
          ),
        ),

        
      ],
    );
  }
}


 class ChartData {
        ChartData(this.x, this.y, this.color);
            final String x;
            final double y;
            final Color color;
    }