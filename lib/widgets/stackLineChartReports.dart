import 'package:emp_sys/widgets/multi.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackLineChart extends StatefulWidget {
  const StackLineChart({super.key});

  @override
  State<StackLineChart> createState() => _StackLineChartState();
}
  int? selectedOption;
class _StackLineChartState extends State<StackLineChart> {
@override
    Widget build(BuildContext context) {
      List<ChartData> chartData = [
        ChartData("this", 2, 4, 6),
        ChartData("that", 7, 3, 2),
        ChartData("thos", 2, 4, 5),
        ChartData("ws", 3, 6, 7),
        ChartData("wer", 6, 4, 7),
        ChartData("ref", 2, 6, 0),
        ChartData("wfc", 4, 5, 6),


      ];
    
         return  Container(
            decoration: BoxDecoration(
          color: Color(0xff1F2123), borderRadius: BorderRadius.circular(10)),
             child: Column(
               children: [
               ListTile(
      
      title: Multi(color: Colors.white, subtitle: "last month", weight: FontWeight.bold, size: 2.5),
      leading: Radio(
        activeColor: Colors.amber,
        value: 1,
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value!;
          });
        },
      ),
    ),
   ListTile(
      
      title: Multi(color: Colors.white, subtitle: "last 15 days", weight: FontWeight.bold, size: 2.5),
      leading: Radio(
        activeColor: Colors.amber,
        value: 2,
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value!;
          });
        },
      ),
    ),
    ListTile(
      
      title: Multi(color: Colors.white, subtitle: "last 7 days", weight: FontWeight.bold, size: 2.5),
      leading: Radio(
        activeColor: Colors.amber,
        value: 3,
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value!;
          });
        },
      ),
    ),

                 SfCartesianChart(
                     primaryXAxis: CategoryAxis(
                          //Hide the gridlines of x-axis 
         majorGridLines: MajorGridLines(width: 0), 
         //Hide the axis line of x-axis 
         axisLine: AxisLine(width: 0), 
                     ),
                     series: <ChartSeries>[
                       
                         StackedLineSeries<ChartData, String>(
                            markerSettings: MarkerSettings(
                             isVisible: true
                            ),
                             dataSource: chartData,
                             xValueMapper: (ChartData data, _) => data.x,
                             yValueMapper: (ChartData data, _) => data.y1
                         ),
                         StackedLineSeries<ChartData, String>(
                           markerSettings: MarkerSettings(
                             isVisible: true
                            ),
                             dataSource: chartData,
                             xValueMapper: (ChartData data, _) => data.x,
                             yValueMapper: (ChartData data, _) => data.y2
                         ),
                          StackedLineSeries<ChartData, String>(
                           markerSettings: MarkerSettings(
                             isVisible: true
                            ),
                             dataSource: chartData,
                             xValueMapper: (ChartData data, _) => data.x,
                             yValueMapper: (ChartData data, _) => data.y3
                         ),
                       
                     ]
                 ),
               ],
             )
         );
    }
}



    class ChartData {
        ChartData(this.x,this.y1,this.y2, this.y3);
        String x;
        final int y1;
        final int y2;
        final int? y3;

    }
