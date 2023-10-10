import 'package:emp_sys/pages/attendanceData.dart';
import 'package:emp_sys/statemanager/provider.dart';
import 'package:emp_sys/widgets/multi.dart';
import 'package:emp_sys/widgets/multiCentered.dart';
import 'package:emp_sys/widgets/reportCards.dart';
import 'package:emp_sys/widgets/stackLineChartReports.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'dart:html';
import 'dart:ui';
import 'package:http/http.dart' show get;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;



class Reports extends StatefulWidget {
   Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
String _selectedValue =  DateFormat('MMMM yyyy').format(DateTime.now());

String? statusCategorization(String dailyArrival) {
  String actualArrivalTime = "08:00:00 AM";

  String arrivalCategory = categorizeArrival(actualArrivalTime, dailyArrival);
  return arrivalCategory;
}

String categorizeArrival(String actualArrivalTime, String dailyArrival) {
  // Parse the actual and daily arrival times
  DateFormat format = DateFormat("hh:mm:ss a");
  DateTime actualTime = format.parse(actualArrivalTime);

  // Extract hours, minutes, and seconds from the daily arrival
  List<String> dailyArrivalParts = dailyArrival.split(":");
  int dailyHours = int.parse(dailyArrivalParts[0]);
  int dailyMinutes = int.parse(dailyArrivalParts[1]);
  int dailySeconds = int.parse(dailyArrivalParts[2]);

  // Create a DateTime object for the daily arrival time
  DateTime dailyTime = DateTime(
    actualTime.year,
    actualTime.month,
    actualTime.day,
    dailyHours,
    dailyMinutes,
    dailySeconds,
  );

  // Define a threshold of 15 minutes
  Duration lateThreshold = Duration(minutes: 15);

  // Calculate the time difference
  Duration timeDifference = dailyTime.difference(actualTime);

  if (timeDifference > lateThreshold) {
    lateArrival.add(double.parse(timeDifference.inMinutes.toString()));
    late15min.add(0);
    onTimemArrival.add(0);
    return timeDifference.inMinutes.toString();
  } 
  else if(timeDifference <= lateThreshold && timeDifference>Duration(minutes: 0,hours: 0,seconds: 0)){
    lateArrival.add(0);
    onTimemArrival.add(0);
    late15min.add(double.parse(timeDifference.inMinutes.toString()));
    return timeDifference.inMinutes.toString();
  }
  else {
    print(timeDifference);
    lateArrival.add(0);
    late15min.add(0);
    onTimemArrival.add(double.parse(timeDifference.inMinutes<0?(timeDifference.inMinutes*-1).toString():timeDifference.inMinutes.toString()));
    return timeDifference.inMinutes.toString();
  }
}

List<int>? imgGraph;

   Future<List?> _renderChartAsImage() async {
  final double pixelRatio = 2.0; // Try using a lower pixel ratio (e.g., 2.0)
  final ui.Image data = await _cartesianChartKey.currentState!.toImage(pixelRatio: pixelRatio);
  final ByteData? bytes = await data.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List imageBytes = bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  imgGraph=imageBytes;
  print(imgGraph);
  return imageBytes;
}

List<double> lateArrival = [];

List<double> onTimemArrival = [];

List<double> late15min = [];

int index = 0; 

var attenData = [];

var attenDates = [];

late GlobalKey<SfCartesianChartState> _cartesianChartKey;

String? totalTime;

String? totalLate;

String? totalEarly;

String? onTime;

  List<AttendanceChartData1> graphData = [];

List<Timings> attendanceDataPdf = [];

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
     final Provider11 = Provider.of<Provider1>(context, listen: true);

_cartesianChartKey = GlobalKey();
      Future fetchFireBaseData()async{
        index=0;
        attendanceDataPdf = [];
graphData = [];
         attenData = [];
 lateArrival = [];
 var dataFinal = {};
 onTimemArrival = [];

 late15min = [];
   attenDates = [];
  final ref = FirebaseDatabase.instance.ref();
final snapshot = await ref.child('attendence/${_selectedValue}/Day').get();
if (snapshot.exists) {
  final Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;

    // Initialize an empty Map to store the data for the specified UID
    final Map<String, dynamic> uidData = {};
    
    // Specify the UID you want to retrieve
    final desiredUid = "2dCXtkkraFST33jeRvgG4WWkT9i2";

    // Loop through the data and extract data for the desired UID
    data.forEach((date, dateData) {
      if (dateData.containsKey(desiredUid)) {
        index++;
       
        uidData[date] = dateData[desiredUid];
       
        print(uidData[date]['checkin'].toString());
        uidData[date]['checkin']==null?index--:graphData.add(AttendanceChartData1(x: date, y:statusCategorization(uidData[date]['checkin']), early: onTimemArrival[index-1], late: lateArrival[index-1], late15:late15min[index-1]));
      }
    });
    print("${uidData} data is herere");

    final Map<String, dynamic> finalData = Provider11.sorting(uidData);
    for (var i = 0; i < finalData.length; i++) {
      print("${finalData.keys.toList()[i]} ---> ${i}");
        attendanceDataPdf.add(Timings(checkin:finalData.values.toList()[i]['checkin']==null?"null":finalData.values.toList()[i]['checkin'], checkout:finalData.values.toList()[i]['checkout']==null?"null":finalData.values.toList()[i]['checkout'], date:finalData.keys.toList()[i].toString(), workingHours:finalData.values.toList()[i]['checkin']==null||finalData.values.toList()[i]['checkout']==null?"00:00:00": Provider11.getTimeDifference(finalData.values.toList()[i]['checkin'].toString(),finalData.values.toList()[i]['checkout'].toString()), status:finalData.values.toList()[i]['checkin']==null?"00:00:00": Provider11.statusCategorization2(finalData.values.toList()[i]['checkin'].toString()), serial: i+1));

    }
    // Print the extracted data for the specified UID
    attenData=finalData.values.toList();
    attenDates = finalData.keys.toList();
    dataFinal =finalData;
    print(lateArrival);
    print(onTimemArrival);
    print(late15min);

    for (var i = 0; i < graphData.length; i++) {
      print("${graphData[i].early}  ${graphData[i].late}  ${graphData[i].late15} ${graphData[i].x}");
    }
   












    int totalHours = 0;
  int totalMinutes = 0;
  int totalSeconds = 0;

  for (int i = 0; i < attendanceDataPdf.length; i++) {
    String timeString = attendanceDataPdf[i].workingHours!;
    List<String> timeParts = timeString.split(':');
    if (timeParts.length == 3) {
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      int seconds = int.parse(timeParts[2]);

      totalHours += hours;
      totalMinutes += minutes;
      totalSeconds += seconds;
    } else {
      print('Invalid time format for element $i: $timeString');
    }
  }

  // Adjust totalMinutes and totalSeconds for overflow
  totalMinutes += totalSeconds ~/ 60;
  totalSeconds %= 60;
  totalHours += totalMinutes ~/ 60;
  totalMinutes %= 60;
   double fractionalHours = totalHours + (totalMinutes / 60.0);

 totalTime ='${fractionalHours.toStringAsFixed(1)}';

  print('Total Time: $totalHours hours, $totalMinutes minutes, $totalSeconds seconds');
    
} else {
    print('No data available.');
}

  // Create a Map to store the counts
  Map<String, int> countMap = {};

  for (int i = 0; i < attendanceDataPdf.length; i++) {
    String? status = attendanceDataPdf[i].status!;
   if (status != null) {
      countMap[status] = (countMap[status] ?? 0) + 1;
    }
  }
  print(countMap);
  // Print the counts
  countMap.forEach((status, count) {
    print('$status: $count');
  });

  onTime = countMap['on Time'].toString();
  totalEarly = countMap['early'].toString();
  totalLate = countMap['late'].toString();
  

return attenData;
}
    return ListView(
      scrollDirection: Axis.vertical,
      primary: true,
      children: [
        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Provider11.changeTimeTrackTab(0);
                                    },
                                    child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Image.network("https://cdn-icons-png.flaticon.com/128/25/25617.png",height: 14,width: 14,color:Provider11.activeTabTimeTracked==0?Colors.white: Color(0xff8F95A2),),
                                                            SizedBox(width: 5,),
                                                            Multi(color: Provider11.activeTabTimeTracked==0?Colors.white:Color(0xff8F95A2), subtitle: "Table View", weight: FontWeight.w500, size: 3)
                                                          ],
                                                         ),
                                  ),
                                  SizedBox(width: 15,),
                                  
                                 
                                ],
                              ),
                               Row(
                                 children: [
      
      
      
      
                                  FutureBuilder(
                              
                                      future: Provider11.fetchAttendanceMonths(),
                                      initialData: "Code sample",
                                      builder: (BuildContext context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.deepPurpleAccent,
                                            ),
                                          );
                                        }
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                'An ${snapshot.error} occurred',
                                                style: const TextStyle(fontSize: 18, color: Colors.red),
                                              ),
                                            );
                                          } else if (snapshot.hasData) {
                                            final data = snapshot.data;
                                         List<DropdownMenuItem<String>> dropdownItems = data.map<DropdownMenuItem<String>>((month) {
      return DropdownMenuItem<String>(
      value: month,
      child: Text(
      month,
      style: TextStyle(color: Colors.white),
      ),
      );
      }).toList();
                                            print("${data} data is here");
                                            return  
      Container(
                              width: 230,
                              child: DropdownButton(
                                isExpanded: true,
                                dropdownColor: Colors.black,
                                icon: null,
                                iconEnabledColor: Colors.white,
                                hint: Multi(
                                    color: Colors.white,
                                    subtitle: "",
                                    weight: FontWeight.normal,
                                    size: 3),
                                value: _selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    attendanceDataPdf = [];
                                    _selectedValue = value!;      
                                  });
                                  print(_selectedValue);
                                },
                                items:dropdownItems,
                              ),
                            );
      
      
                                    
                                          }
                                        }
                            
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                  
                            ),
      
      
      
      
      
      
      
      
      
      
      
      
      
      
                                
                                   GestureDetector(
                                    onTap: () async{
                                    //  await _renderChartAsImage();
                                    //   PdfService().printCustomersPdf(attendanceDataPdf,imgGraph);
                                    },
                                    child: Image.network("https://cdn-icons-png.flaticon.com/128/5261/5261933.png",height: 20,width: 20,color:Colors.white,)),
                                 ],
                               )
                            ],
                          ),
                         
                        SizedBox(height: 10,),

        FutureBuilder(
                              
                                      future: fetchFireBaseData(),
                                      initialData: "Code sample",
                                      builder: (BuildContext context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.deepPurpleAccent,
                                            ),
                                          );
                                        }
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                'An ${snapshot.error} occurred',
                                                style: const TextStyle(fontSize: 18, color: Colors.red),
                                              ),
                                            );
                                          } else if (snapshot.hasData) {
                                          
                                            return ListView(
                                              shrinkWrap: true,
                                              primary: true,
                                              scrollDirection: Axis.vertical,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                     decoration: BoxDecoration(
              color: Color(0xff1F2123), borderRadius: BorderRadius.circular(10)),
                  height: 400,
                  child: Padding(
                    padding:EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Multi(color: Colors.white, subtitle: "Cummulative Stats", weight: FontWeight.bold, size: 3.5),
                        SizedBox(height: 20,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                              ReportCards(imgAddress: 'assets/images/totalHours.png', value: '$totalTime', heading: 'Total Working Hours', subHeading: 'hours',),
                              SizedBox(width: 10,),
                              ReportCards(imgAddress: 'assets/images/in.png', value: '$totalLate', heading: 'Total Late Arrivals', subHeading: 'arrivals',),
                              SizedBox(width: 10,),
                              ReportCards(imgAddress: 'assets/images/in.png', value: '$onTime', heading: 'On Times', subHeading: 'arrivals',),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                              ReportCards(imgAddress: 'assets/images/in.png', value: '$totalEarly', heading: 'Total Early Arrivals', subHeading: 'arrivals',),
                              SizedBox(width: 10,),
                              ReportCards(imgAddress: 'assets/images/off.png', value: '00', heading: 'Total Offs', subHeading: 'days',),
                              SizedBox(width: 10,),
                              ReportCards(imgAddress: 'assets/images/leave.png', value: '00', heading: 'Total Leaves', subHeading: 'days',),
                              ],
                            )
                             
                          ],
                        ),
                      ],
                    ),
                  )
                ),
                SizedBox(height: 30,),
                Container(
                  height: 400,
                  width:size.width/2.3,
                  child:Container(
                decoration: BoxDecoration(
              color: Color(0xff1F2123), borderRadius: BorderRadius.circular(10)),
                 child: Column(
                   children: [
          SizedBox(height: 20,),
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
          
          
                Multi(color: Colors.white, subtitle: "Arrival Graph", weight: FontWeight.bold, size: 3.5),
          
          
          
          
                Row(
                  children: [
                            Row(
                              children: [
                                Radio(
                  fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                  activeColor: Colors.amber,
                  value: 1,
                  groupValue: selectedOption,
                  onChanged: (value) {
                   
                  },
                
              ),
              Multi(color: Colors.white, subtitle: "last 7 days", weight: FontWeight.w500, size: 2.5),
                              ],
                            ),
                SizedBox(width: 5,),
            Row(
              children: [
                Radio(
                  fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      activeColor: Colors.amber,
                      value: 2,
                      groupValue: selectedOption,
                      onChanged: (value) {
                      
                      },
                    
                  ),
                Multi(color: Colors.white, subtitle: "last 15 days", weight: FontWeight.w500, size: 2.5),
              ],
            ),
            SizedBox(width: 5,),
              Row(
                children: [
                  Radio(
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      activeColor: Colors.amber,
                      value: 3,
                      groupValue: selectedOption,
                      onChanged: (value) {
                       
                      },
                    ),
                  Multi(color: Colors.white, subtitle: "last 30 days", weight: FontWeight.w500, size: 2.5),
                ],
              ),
              
                  ],
                ),
              ],
            ),
          ),
  SizedBox(height: 20,),
                     SfCartesianChart(
                       key: _cartesianChartKey,
                         primaryXAxis: CategoryAxis(
                              //Hide the gridlines of x-axis 
                              title: AxisTitle(
                                text: "Dates",
                                textStyle: TextStyle(
                                  color: Colors.white
                                )
                              ),
             majorGridLines: MajorGridLines(width: 0), 
             //Hide the axis line of x-axis 
             axisLine: AxisLine(width: 0), 
                         ),
                          primaryYAxis: NumericAxis(
                              //Hide the gridlines of x-axis 
                              title: AxisTitle(
                                text: "Minutes",
                                textStyle: TextStyle(
                                  color: Colors.white
                                )
                              ),
             majorGridLines: MajorGridLines(width: 0), 
             //Hide the axis line of x-axis 
             axisLine: AxisLine(width: 0), 
                         ),
                         series: <ChartSeries>[
                           
                             ColumnSeries<AttendanceChartData1, String>(
                                markerSettings: MarkerSettings(
                                  color: Colors.amber,
                                 isVisible: true
                                ),
                                color: Colors.amber,
                                 dataSource: graphData,
                                 xValueMapper: (AttendanceChartData1 data, _) => data.x,
                                 yValueMapper: (AttendanceChartData1 data, _) => data.early
                             ),
                             ColumnSeries<AttendanceChartData1, String>(
                               markerSettings: MarkerSettings(
                                color: Colors.red,
                                 isVisible: true
                                ),
                                 color: Colors.red,
                                 dataSource: graphData,
                                 xValueMapper: (AttendanceChartData1 data, _) => data.x,
                                 yValueMapper: (AttendanceChartData1 data, _) => data.late
                             ),
                              ColumnSeries<AttendanceChartData1, String>(
                               markerSettings: MarkerSettings(
                                color: Colors.green,
                                 isVisible: true
                                ),
                                color: Colors.green,
                                 dataSource: graphData,
                                 xValueMapper: (AttendanceChartData1 data, _) => data.x,
                                 yValueMapper: (AttendanceChartData1 data, _) => data.late15
                             ),
                           
                         ]
                     ),
                    
                   ],
                 )
             )
                  ),
              ],
            ),
            SizedBox(height: 40,),
            Padding(
              padding:EdgeInsets.only(left:20 ),
              child: Multi(color: Colors.white, subtitle: "Attendence Record", weight: FontWeight.bold, size: 3.5),
            ),
            SizedBox(height: 20,),
            DataTable(
                                              columnSpacing: 17,
                                              headingRowHeight: 70,
                                              columns: [
                                                
                                                DataColumn(
                                                
                                                  label: Multi(color: Color(0xff8F95A2), subtitle: "S No.", weight: FontWeight.bold, size: 3)
                                                  ),
                                                DataColumn(
                                                  label: Multi(color: Color(0xff8F95A2), subtitle: "Date", weight: FontWeight.bold, size: 3)
                                                  ),
                                                DataColumn(
                                                  label: Multi(color: Color(0xff8F95A2), subtitle: "Actual Check in", weight: FontWeight.bold, size: 3)
                                                  ),
                                                  DataColumn(
                                                  label: Multi(color: Color(0xff8F95A2), subtitle: "Actual Check Out", weight: FontWeight.bold, size: 3)
                                                  ),
                                              
                                                  DataColumn(
                                                  label: Multi(color: Color(0xff8F95A2), subtitle: "Check in", weight: FontWeight.bold, size: 3)
                                                  ),
                                                  DataColumn(
                                                  label: Multi(color: Color(0xff8F95A2), subtitle: "Check Out", weight: FontWeight.bold, size: 3)
                                                  ),
                                                  DataColumn(
                                                  label: Multi(color: Color(0xff8F95A2), subtitle: "Working Hours", weight: FontWeight.bold, size: 3)
                                                  ),
                                                      DataColumn(
                                                  label: Multi(color: Color(0xff8F95A2), subtitle: "Status", weight: FontWeight.bold, size: 3)
                                                  ),
                                                
                                              ], 
                                              rows: attendanceDataPdf.map((e)=>DataRow(
                                                cells: [
                                                DataCell(Multi(color: Color(0xff8F95A2), subtitle: e.serial.toString(), weight: FontWeight.normal, size: 3)),
                                                DataCell(Multi(color: Color(0xff8F95A2), subtitle: e.date.toString(), weight: FontWeight.normal, size: 3)),                                               
                                                DataCell(Multi(color: Color(0xff8F95A2), subtitle: "08:00", weight: FontWeight.normal, size: 3)),
                                                DataCell(Multi(color: Color(0xff8F95A2), subtitle: "17:00", weight: FontWeight.normal, size: 3)),
                                                DataCell(Multi(color: Color(0xff8F95A2), subtitle:  e.checkin.toString(), weight: FontWeight.normal, size: 3)),
                                                DataCell(Multi(color: Color(0xff8F95A2), subtitle: e.checkout.toString(), weight: FontWeight.normal, size: 3)),
                                                DataCell(Multi(color: Color(0xff8F95A2), subtitle: e.workingHours.toString(), weight: FontWeight.normal, size: 3)),
                                                DataCell(Multi(color: Color(0xff8F95A2), subtitle:e.status.toString(), weight: FontWeight.normal, size: 3)),
                                              ])).toList()
                                              )
          

            
          ],
        );
                                          }
                                        }
                            
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                  
                            ),
      ],
    );
  }
}


















































  






class ChartData {
        ChartData(this.x,this.x2,this.x3, this.y);
        final int x;
        final int x2;
        final int x3;
        final double? y;

    }
class Timings{
      int? serial;
      String? date;
      String? checkin;
      String? checkout;
      String? workingHours;
      String? status;
  
  Timings({
    required this.serial,
    required this.date,
    required this.checkin,
    required this.checkout,
    required this.workingHours,
    required this.status
    });
}

class AttendanceChartData1 {
  var x;
  String? y;
  double? early;
  double? late;
  double? late15;
  AttendanceChartData1({required this.x,required this.y,required this.early,required this.late,required this.late15});
}