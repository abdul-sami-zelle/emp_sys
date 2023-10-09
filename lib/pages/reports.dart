import 'package:emp_sys/widgets/reportCards.dart';
import 'package:emp_sys/widgets/stackLineChartReports.dart';
import 'package:flutter/material.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView(
      children: [
        Container(
          height: 100,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               ReportCards(imgAddress: 'assets/images/totalHours.png', value: '123', heading: 'Total Working Hours', subHeading: 'hours',),
               SizedBox(width: 5,),
               ReportCards(imgAddress: 'assets/images/in.png', value: '657', heading: 'Total Late Arrivals', subHeading: 'arrivals',),
               SizedBox(width: 5,),
               ReportCards(imgAddress: 'assets/images/in.png', value: '567', heading: 'On Times', subHeading: 'arrivals',),
               SizedBox(width: 5,),
               ReportCards(imgAddress: 'assets/images/in.png', value: '567', heading: 'Total Early Arrivals', subHeading: 'arrivals',),
               SizedBox(width: 5,),
               ReportCards(imgAddress: 'assets/images/totalHours.png', value: '01', heading: 'Total Offs', subHeading: 'days',),
               SizedBox(width: 5,),
               ReportCards(imgAddress: 'assets/images/totalHours.png', value: '03', heading: 'Total Leaves', subHeading: 'days',),
               SizedBox(width: 5,),
            ],
          )
        ),
        SizedBox(height: 30,),
        Row(
          children: [
            Container(
              width:size.width/2,
              child: StackLineChart()),
            Container(
              width:size.width/4,
              ),
          ],
        ),
      ],
    );
  }
}