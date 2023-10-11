import 'package:emp_sys/pages/attendanceData.dart';
import 'package:emp_sys/statemanager/provider.dart';
import 'package:emp_sys/widgets/multi.dart';
import 'package:emp_sys/widgets/multiCentered.dart';
import 'package:emp_sys/widgets/reportCards.dart';
import 'package:emp_sys/widgets/stackLineChartReports.dart';
import 'package:fl_chart/fl_chart.dart';
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

late GlobalKey<SfCircularChartState> _cartesianChartKey;

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



String? totalTime;

String? totalLate;

String? totalEarly;

String? onTime;



  List<AttendanceChartData1> graphData = [];

List<Timings> attendanceDataPdf = [];

  Widget build(BuildContext context) {
_cartesianChartKey = GlobalKey();
    final size = MediaQuery.of(context).size;
     final Provider11 = Provider.of<Provider1>(context, listen: true);




List<DougnutChartData> categoryChart = [

];


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
  categoryChart = [
  DougnutChartData("on Time", onTime.toString()=="null"?0:int.parse(onTime.toString()), Color.fromRGBO(13, 81, 139, 1)),
  DougnutChartData("Early", totalEarly.toString()=="null"?0:int.parse(totalEarly.toString()), Color.fromRGBO(9, 55, 95, 1)),
  DougnutChartData("late", totalLate.toString()=="null"?0:int.parse(totalLate.toString()), Color.fromRGBO(69, 160, 237, 1)),
  DougnutChartData("total offs", 2, Color.fromRGBO(230, 121, 47, 1)),
  DougnutChartData("total Leaves", 1, const Color.fromARGB(255, 200, 20, 7)),
  ];
 final list1 = [onTime,totalEarly,totalLate];
 print(list1);
  
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
                                     await _renderChartAsImage();
                                    //  attendanceDataPdf,imgGraph
                                      PdfService().printCustomersPdf(attendanceDataPdf,imgGraph,(attendanceDataPdf.length*9).toString() , totalTime, "1", "2", totalEarly, totalTime, totalLate);
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
                  width:size.width/3.5,
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
          
          
          
          
              
              ],
            ),
          ),
  SizedBox(height: 20,),
            //          SfCartesianChart(
            //            key: _cartesianChartKey,
            //              primaryXAxis: CategoryAxis(
            //                   //Hide the gridlines of x-axis 
            //                   title: AxisTitle(
            //                     text: "Dates",
            //                     textStyle: TextStyle(
            //                       color: Colors.white
            //                     )
            //                   ),
            //  majorGridLines: MajorGridLines(width: 0), 
            //  //Hide the axis line of x-axis 
            //  axisLine: AxisLine(width: 0), 
            //              ),
            //               primaryYAxis: NumericAxis(
            //                   //Hide the gridlines of x-axis 
            //                   title: AxisTitle(
            //                     text: "Minutes",
            //                     textStyle: TextStyle(
            //                       color: Colors.white
            //                     )
            //                   ),
            //  majorGridLines: MajorGridLines(width: 0), 
            //  //Hide the axis line of x-axis 
            //  axisLine: AxisLine(width: 0), 
            //              ),
            //              series: <ChartSeries>[
                           
            //                  ColumnSeries<AttendanceChartData1, String>(
            //                     markerSettings: MarkerSettings(
            //                       color: Colors.amber,
            //                      isVisible: true
            //                     ),
            //                     color: Colors.amber,
            //                      dataSource: graphData,
            //                      xValueMapper: (AttendanceChartData1 data, _) => data.x,
            //                      yValueMapper: (AttendanceChartData1 data, _) => data.early
            //                  ),
            //                  ColumnSeries<AttendanceChartData1, String>(
            //                    markerSettings: MarkerSettings(
            //                     color: Colors.red,
            //                      isVisible: true
            //                     ),
            //                      color: Colors.red,
            //                      dataSource: graphData,
            //                      xValueMapper: (AttendanceChartData1 data, _) => data.x,
            //                      yValueMapper: (AttendanceChartData1 data, _) => data.late
            //                  ),
            //                   ColumnSeries<AttendanceChartData1, String>(
            //                    markerSettings: MarkerSettings(
            //                     color: Colors.green,
            //                      isVisible: true
            //                     ),
            //                     color: Colors.green,
            //                      dataSource: graphData,
            //                      xValueMapper: (AttendanceChartData1 data, _) => data.x,
            //                      yValueMapper: (AttendanceChartData1 data, _) => data.late15
            //                  ),
                           
            //              ]
            //          ),

            SfCircularChart(
              key: _cartesianChartKey,
              legend: Legend(
                    isVisible: true,
                    
                  ),
                        series: <CircularSeries>[
                           
                            DoughnutSeries<DougnutChartData, String>(
                                dataSource: categoryChart,
                                pointColorMapper:(DougnutChartData data,  _) => data.color,
                                xValueMapper: (DougnutChartData data, _) => data.x,
                                yValueMapper: (DougnutChartData data, _) => data.y
                            )
                        ]
                    )

           
                    
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














































class PdfService {
  Future<void> printCustomersPdf(List<Timings> data,
  var graphData,
  String? actualTime,
  String? paidTime,
  String? totalOffs,
  String? totalLeaves,
  String? earlyArrival,
  String? totalOntime,
  String? lateArrival,

  ) async {


//Create a new pdf document
PdfDocument document = PdfDocument();

 document.pageSettings.margins.all = 5;

//Create the header with specific bounds
PdfPageTemplateElement header = PdfPageTemplateElement(
    Rect.fromLTWH(0, 0, document.pageSettings.size.width, 100));

//Create the footer with specific bounds
PdfPageTemplateElement footer = PdfPageTemplateElement(
    Rect.fromLTWH(0, 0, document.pageSettings.size.width, 80));




//Add the header at top of the document
document.template.top = header;


//Add the footer at the bottom of the document
document.template.bottom = footer;
  


  final ByteData assetData1 = await rootBundle.load('assets/images/footer.png');
  final Uint8List imageBytes1 = assetData1.buffer.asUint8List();

  final ByteData assetData2 = await rootBundle.load('assets/images/header.png');
  final Uint8List imageBytes2 = assetData2.buffer.asUint8List();

  // Create PdfBitmap objects from the asset images
  final PdfBitmap image1 = PdfBitmap(imageBytes1);
  final PdfBitmap image2 = PdfBitmap(imageBytes2);




  footer.graphics.drawImage(
      image1,
      Rect.fromLTWH(
          0, 0, document.pageSettings.size.width, 80));

  header.graphics.drawImage(
      image2,
      Rect.fromLTWH(
          0, 0, document.pageSettings.size.width, 100));







 

    final PdfPage page = document.pages.add();





  // page.graphics.drawString(
  //         'Name :',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(40, 10), Offset(40, 10))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  // page.graphics.drawString(
  //         'Abdul Sami',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(80, 10), Offset(80, 10))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  // page.graphics.drawString(
  //         'Emp Id :',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(220, 10), Offset(220, 10))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  // page.graphics.drawString(
  //         '1001',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(260, 10), Offset(260, 10))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );


  // page.graphics.drawString(
  //         'Designation :',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(360, 10), Offset(360, 10))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  // page.graphics.drawString(
  //         'Flutter Developer',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(430, 10), Offset(430, 10))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );







// cummulative statistics



  // page.graphics.drawString(
  //         'Cummulative Statistics',
  //         PdfStandardFont(PdfFontFamily.helvetica, 15,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(0, 50), Offset(0, 50))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );




     
  // page.graphics.drawString(
  //         'Actual Working Hours',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(20, 80), Offset(20, 80))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  // page.graphics.drawString(
  //         'Paid Working Hours',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(20, 100), Offset(20, 100))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  //  page.graphics.drawString(
  //         'Total Offs',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(20, 120), Offset(20, 120))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  //  page.graphics.drawString(
  //         'Total Leaves',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(20, 140), Offset(20, 140))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  //  page.graphics.drawString(
  //         'Total Early Arrival',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(20, 160), Offset(20, 160))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  //  page.graphics.drawString(
  //         'Total On Time Arrivals',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(20, 180), Offset(20, 180))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  //    page.graphics.drawString(
  //         'Total Late Arrivals',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(20, 200), Offset(20, 200))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );
















  // page.graphics.drawString(
  //         ':      $actualTime',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(160, 80), Offset(160, 80))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  // page.graphics.drawString(
  //         ':      $paidTime',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(160,100), Offset(160, 100))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  //  page.graphics.drawString(
  //         ':      $totalOffs',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(160, 120), Offset(160, 120))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  //  page.graphics.drawString(
  //         ':      $totalLeaves',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(160, 140), Offset(160, 140))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  //  page.graphics.drawString(
  //         ':      $earlyArrival',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(160, 160), Offset(160, 160))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

  //  page.graphics.drawString(
  //         ':      $totalOntime',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(160, 180), Offset(160, 180))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );
  //   page.graphics.drawString(
  //         ':      $lateArrival',
  //         PdfStandardFont(PdfFontFamily.helvetica, 10,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(160, 200), Offset(160, 200))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );




   
     final PdfBitmap image3 = PdfBitmap(graphData);
       page.graphics.drawImage(
           image3,
      Rect.fromLTWH(
          300, 50, 250, 180),
         
          );









  // page.graphics.drawString(
  //         'Attendence Record',
  //         PdfStandardFont(PdfFontFamily.helvetica, 15,
  //             style: PdfFontStyle.bold),
  //         brush: PdfBrushes.black,
  //         bounds: Rect.fromPoints(Offset(0, 220), Offset(0, 220))
  //         // bounds: Rect.fromLTWH(50, 130, 300, 50)
  // );

















  

   
    final PdfGraphics graphics = page.graphics;

    
    graphics.drawRectangle(
      
        pen: PdfPen(PdfColor(2, 158, 222)),
        brush: PdfSolidBrush(PdfColor(2, 158, 222)),
        bounds: Rect.fromPoints(Offset(0, 10), Offset(190, 50)));

    graphics.drawString(
              'Employee Name',
              PdfStandardFont(PdfFontFamily.helvetica, 8,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(10, 10), Offset(190, 35)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );
     graphics.drawString(
              'Abdul Sami',
              PdfStandardFont(PdfFontFamily.helvetica, 13,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(10, 15), Offset(190, 55)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );










    graphics.drawRectangle(
      
        pen: PdfPen(PdfColor(2, 158, 222)),
        brush: PdfSolidBrush(PdfColor(2, 158, 222)),
        bounds: Rect.fromPoints(Offset(200, 10), Offset(390, 50)));

    graphics.drawString(
              'Employee Id',
              PdfStandardFont(PdfFontFamily.helvetica, 8,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(210, 10), Offset(390, 35)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );
     graphics.drawString(
              'ZELLE-123',
              PdfStandardFont(PdfFontFamily.helvetica, 13,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(210, 15), Offset(390, 55)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );

      



    graphics.drawRectangle(
      
        pen: PdfPen(PdfColor(2, 158, 222)),
        brush: PdfSolidBrush(PdfColor(2, 158, 222)),
        bounds: Rect.fromPoints(Offset(400, 10), Offset(590, 50)));

    graphics.drawString(
              'Employee Designation',
              PdfStandardFont(PdfFontFamily.helvetica, 8,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(410, 10), Offset(590, 35)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );
     graphics.drawString(
              'Flutter Developer',
              PdfStandardFont(PdfFontFamily.helvetica, 13,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(410, 15), Offset(590, 55)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );

      






    graphics.drawRectangle(
      
        pen: PdfPen(PdfColor(2, 158, 222)),
        brush: PdfSolidBrush(PdfColor(2, 158, 222)),
        bounds: Rect.fromPoints(Offset(0, 60), Offset(90, 120)));
  


    graphics.drawString(
              'Actual Hours',
              PdfStandardFont(PdfFontFamily.helvetica, 8,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(10, 65), Offset(80, 105)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.top)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );
    graphics.drawString(
              '100 hrs',
              PdfStandardFont(PdfFontFamily.helvetica, 20,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(10, 75), Offset(80, 110)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );




    graphics.drawRectangle(
      
        pen: PdfPen(PdfColor(2, 158, 222)),
        brush: PdfSolidBrush(PdfColor(2, 158, 222)),
        bounds: Rect.fromPoints(Offset(100, 60), Offset(190, 120)));
  


    graphics.drawString(
              'Actual Hours',
              PdfStandardFont(PdfFontFamily.helvetica, 8,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(110, 65), Offset(180, 105)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.top)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );
    graphics.drawString(
              '100 hrs',
              PdfStandardFont(PdfFontFamily.helvetica, 20,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(110, 75), Offset(180, 110)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );















    graphics.drawRectangle(
      
        pen: PdfPen(PdfColor(2, 158, 222)),
        brush: PdfSolidBrush(PdfColor(2, 158, 222)),
        bounds: Rect.fromPoints(Offset(0, 130), Offset(90, 190)));
  


    graphics.drawString(
              'Actual Hours',
              PdfStandardFont(PdfFontFamily.helvetica, 8,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(10, 135), Offset(80, 175)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.top)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );
    graphics.drawString(
              '100 hrs',
              PdfStandardFont(PdfFontFamily.helvetica, 20,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(10, 155), Offset(80, 180)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );


















          graphics.drawRectangle(
      
        pen: PdfPen(PdfColor(2, 158, 222)),
        brush: PdfSolidBrush(PdfColor(2, 158, 222)),
        bounds: Rect.fromPoints(Offset(100, 130), Offset(190, 190)));
  


    graphics.drawString(
              'Actual Hours',
              PdfStandardFont(PdfFontFamily.helvetica, 8,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(110, 135), Offset(180, 175)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.top)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );
    graphics.drawString(
              '100 hrs',
              PdfStandardFont(PdfFontFamily.helvetica, 20,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(110, 155), Offset(180, 180)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );










    graphics.drawRectangle(
      
        pen: PdfPen(PdfColor(2, 158, 222)),
        brush: PdfSolidBrush(PdfColor(2, 158, 222)),
        bounds: Rect.fromPoints(Offset(0, 200), Offset(90, 260)));
  


    graphics.drawString(
              'Actual Hours',
              PdfStandardFont(PdfFontFamily.helvetica, 8,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(10, 205), Offset(80, 245)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.top)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );
    graphics.drawString(
              '100 hrs',
              PdfStandardFont(PdfFontFamily.helvetica, 20,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(10, 215), Offset(80, 250)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );





    graphics.drawRectangle(
      
        pen: PdfPen(PdfColor(2, 158, 222)),
        brush: PdfSolidBrush(PdfColor(2, 158, 222)),
        bounds: Rect.fromPoints(Offset(100, 200), Offset(190, 260)));
  


    graphics.drawString(
              'Actual Hours',
              PdfStandardFont(PdfFontFamily.helvetica, 8,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(110, 205), Offset(180, 245)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.top)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );
    graphics.drawString(
              '100 hrs',
              PdfStandardFont(PdfFontFamily.helvetica, 20,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.white,
              bounds: Rect.fromPoints(Offset(110, 215), Offset(180, 250)),
               format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
              // bounds: Rect.fromLTWH(50, 130, 300, 50)
      );




















    PdfGrid grid = PdfGrid();
  
    //Define number of columns in table
    grid.columns.add(count: 8);
    //Add header to the grid
    grid.headers.add(1);
    
    //Add the rows to the grid
    PdfGridRow header2 = grid.headers[0];
    header2.cells[0].value = "s.no";
    header2.cells[1].value = "Date";
    header2.cells[2].value = "Act Checkin";
    header2.cells[3].value = "Act Checkout";
    header2.cells[4].value = "Checkin";
    header2.cells[5].value = "Checkout";
    header2.cells[6].value = "Working Hrs";
    header2.cells[7].value = "status";
    
    

   



    //Add header style
    PdfGridCellStyle gridcell = PdfGridCellStyle(
  borders: PdfBorders(
        left: PdfPens.black,
        right: PdfPens.black,
        top: PdfPens.black,
        bottom: PdfPens.black
      ),
  backgroundBrush: PdfBrushes.black,
  textBrush: PdfBrushes.wheat,
   font: PdfStandardFont(PdfFontFamily.helvetica, 9,style:PdfFontStyle.bold),
    );

 

 PdfGridStyle gridStyle = PdfGridStyle(
 
  cellSpacing: 2,
  cellPadding: PdfPaddings(left: 8, right: 0, top: 8, bottom: 5),
  borderOverlapStyle: PdfBorderOverlapStyle.overlap,

);
grid.headers.applyStyle(gridcell);
grid.rows.applyStyle(gridStyle);
    //Add rows to grid
    for (final customer in data) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = customer.serial.toString();
      row.cells[1].value = customer.date;
      row.cells[2].value = "08:00 AM";
      row.cells[3].value = "05:00 PM";
      row.cells[4].value = customer.checkin;
      row.cells[5].value = customer.checkout;
      row.cells[6].value = customer.workingHours;
      row.cells[7].value = customer.status;
      row.cells[7].style = PdfGridCellStyle(
  backgroundBrush:
   row.cells[7].value=="early"?
   PdfSolidBrush( PdfColor(9, 55, 95))
   :
   row.cells[7].value=="on Time"?
   PdfSolidBrush( PdfColor(13, 81, 139))
   :
   row.cells[7].value=="Late"?
   PdfSolidBrush( PdfColor(69, 160, 237))
   :
   PdfBrushes.white,
  textBrush: PdfBrushes.white

   
 
);
    }
    //Add rows style
   
    
   // Draw the grid
    grid.draw(
        page: page, bounds: const Rect.fromLTWH(0, 300, 0, 0));    





List<int> bytes = await document.save();



    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "report.pdf")
      ..click();

    //Dispose the document
    document.dispose();
  }
}













    class DougnutChartData {
        DougnutChartData(this.x, this.y, this.color);
            final String x;
            final int y;
            final Color color;
    }