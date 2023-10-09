import 'dart:convert';

import 'package:emp_sys/statemanager/provider.dart';
import 'package:emp_sys/widgets/TimeTrackingEmployeGraphs/bubbleChart.dart';
import 'package:emp_sys/widgets/attendanceChart.dart';
import 'package:emp_sys/widgets/attendenceDataBox.dart';
import 'package:emp_sys/widgets/multi.dart';
import 'package:emp_sys/widgets/multiCentered.dart';
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

class AttendanceData extends StatefulWidget {
   AttendanceData({super.key});

  @override
  State<AttendanceData> createState() => _AttendanceDataState();
}

class _AttendanceDataState extends State<AttendanceData> {
  @override
  
 ScrollController _scrollController = ScrollController();

  List<TimeTrackingData> dataa=[];

  Future<List<TimeTrackingData>> generatedList()async{
    var response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    var decodedData = json.decode(response.body).cast<Map<String,dynamic>>();
     dataa = await decodedData.map<TimeTrackingData>((json)=>TimeTrackingData.fromJson(json)).toList();
    print(dataa);
    return dataa;
  }

List<AttendanceChartData1> graphData = [];
List<Timings> attendanceDataPdf = [];

var attendanceMonths = [];

var data2 = {};

String _selectedValue =  DateFormat('MMMM yyyy').format(DateTime.now());

Future fetchAttendanceMonths()async{
  final ref = FirebaseDatabase.instance.ref();
final snapshot = await ref.child('attendence').get();
if (snapshot.exists) {
    data2 = snapshot.value as Map<String,dynamic>;
   attendanceMonths= data2.keys.toList();
} else {
    print('No data available.');
}
return attendanceMonths;

}

DateTime convertStringToDateTime(String dateString) {
  // Define the date format
  DateFormat format = DateFormat("dd-MM-yyyy");

  // Parse the string into a DateTime object
  DateTime dt = format.parse(dateString);

  return dt;
}

Map<String, dynamic> sorting( Map<String, dynamic> uidData) {


  // Parse and sort the keys as DateTime objects
  List<String> sortedKeys = uidData.keys.toList()
    ..sort((a, b) {
      var aParts = a.split('-').map(int.parse).toList();
      var bParts = b.split('-').map(int.parse).toList();
      var aDate = DateTime(aParts[2], aParts[1], aParts[0]);
      var bDate = DateTime(bParts[2], bParts[1], bParts[0]);
      return aDate.compareTo(bDate);
    });

  // Create a new map with sorted keys
  Map<String, dynamic> sortedUidData = {};
  for (var key in sortedKeys) {
    sortedUidData[key] = uidData[key];
  }

  // Print the sorted map
  return sortedUidData;
}




String getTimeDifference(String startTimeStr, String endTimeStr) {
  List<int> startTimeParts = startTimeStr.split(':').map(int.parse).toList();
  List<int> endTimeParts = endTimeStr.split(':').map(int.parse).toList();

  DateTime startTime = DateTime(0, 1, 1, startTimeParts[0], startTimeParts[1], startTimeParts[2]);
  DateTime endTime = DateTime(0, 1, 1, endTimeParts[0], endTimeParts[1], endTimeParts[2]);

  Duration difference = endTime.difference(startTime);

  String twoDigits(int n) => n.toString().padLeft(2, '0');
  int hours = difference.inHours;
  int minutes = difference.inMinutes % 60;
  int seconds = difference.inSeconds % 60;

  return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
}







String? differenceShiftTime(String? time1, String? time2) {

  if (time1 ==null || time2 ==null) {
    return "null";
  } else {
     // Parse the string times into DateTime objects
  DateFormat format = DateFormat("HH:mm:ss");
  DateTime dateTime1 = format.parse(time1);
  DateTime dateTime2 = format.parse(time2);
 
  // Calculate the time difference
  Duration difference = dateTime2.difference(dateTime1);

  // Convert the time difference to hours
  String hoursDifference = (difference.inMinutes / 60.0).toString().substring(0,3);
    // Extract hours, minutes, and seconds from the time difference
  int hours = difference.inHours;
  int minutes = (difference.inMinutes % 60);
  int seconds = (difference.inSeconds % 60);

  // Format the time difference as "HH:mm:ss"
  String formattedDifference = '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

  return formattedDifference;

  }
  
}

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






















String? statusCategorization2(String dailyArrival) {
  String actualArrivalTime = "08:00:00 AM";

  String arrivalCategory = categorizeArrival2(actualArrivalTime, dailyArrival);
  return arrivalCategory;
}

String categorizeArrival2(String actualArrivalTime, String dailyArrival) {
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
    return "late";
  } 
  else if(timeDifference <= lateThreshold && timeDifference>Duration(minutes: 0,hours: 0,seconds: 0)){
    return "on Time";
  }
  else {
    return "early";
  }
}








































List<double> lateArrival = [];

List<double> onTimemArrival = [];

List<double> late15min = [];

int index = 0; 

  var attenData = [];

  var attenDates = [];

Future fetchFireBaseData()async{
  final ref = FirebaseDatabase.instance.ref();
final snapshot = await ref.child('attendence/${_selectedValue}/Day').get();
if (snapshot.exists) {
  final Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;

    // Initialize an empty Map to store the data for the specified UID
    final Map<String, dynamic> uidData = {};
    
    // Specify the UID you want to retrieve
    final desiredUid = "42U9MUNIkoSiv943azxqjCVV4xa2";

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

    final Map<String, dynamic> finalData = sorting(uidData);
    for (var i = 0; i < finalData.length; i++) {
      print("${finalData.keys.toList()[i]} ---> ${i}");
        attendanceDataPdf.add(Timings(checkin:finalData.values.toList()[i]['checkin']==null?"null":finalData.values.toList()[i]['checkin'], checkout:finalData.values.toList()[i]['checkout']==null?"null":finalData.values.toList()[i]['checkout'], date:finalData.keys.toList()[i].toString(), workingHours:finalData.values.toList()[i]['checkin']==null||finalData.values.toList()[i]['checkout']==null?"nil": getTimeDifference(finalData.values.toList()[i]['checkin'].toString(),finalData.values.toList()[i]['checkout'].toString()), status:finalData.values.toList()[i]['checkin']==null?"nil": statusCategorization2(finalData.values.toList()[i]['checkin'].toString())));

    }
    // Print the extracted data for the specified UID
    attenData=finalData.values.toList();
    attenDates = finalData.keys.toList();
    print(lateArrival);
    print(onTimemArrival);
    print(late15min);

    for (var i = 0; i < graphData.length; i++) {
      print("${graphData[i].early}  ${graphData[i].late}  ${graphData[i].late15}");
    }

   
    
} else {
    print('No data available.');
}





return attenData;
}





  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Provider11 = Provider.of<Provider1>(context, listen: true);
    return  Scrollbar(
      showTrackOnHover: true,
      child: ListView(
        primary: true,
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Multi(color: Colors.white, subtitle: "Attendance Record", weight: FontWeight.bold, size: 6),
                                              Container()
                                            ],
                                           ),
          ),
                                
                        SizedBox(height: 25,),
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              
                                             decoration: BoxDecoration(
                                      color: Color(0xff1F2123),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
              child: SingleChildScrollView(
                child: Padding(
                  padding:EdgeInsets.only(top:20,left:25,right: 25),
                  child: SingleChildScrollView(
                    child: Column(
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
                                  InkWell(
                                    onTap: (){
                                      Provider11.changeTimeTrackTab(1);
                                    },
                                    child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Image.network("https://cdn-icons-png.flaticon.com/128/126/126425.png",height: 14,width: 14,color:Provider11.activeTabTimeTracked==1?Colors.white:Color(0xff8F95A2),),
                                                            SizedBox(width: 5,),
                                                            Multi(color: Provider11.activeTabTimeTracked==1?Colors.white:Color(0xff8F95A2), subtitle: "Graphical Illustration", weight: FontWeight.w500, size: 3)
                                                          ],
                                                         ),
                                  ),
                                 
                                ],
                              ),
                               Row(
                                 children: [
      
      
      
      
                                  FutureBuilder(
                              
                                      future: fetchAttendanceMonths(),
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
                                    onTap: (){
                                      PdfService().printCustomersPdf(attendanceDataPdf);
                                    },
                                    child: Image.network("https://cdn-icons-png.flaticon.com/128/5261/5261933.png",height: 20,width: 20,color:Colors.white,)),
                                 ],
                               )
                            ],
                          ),
                         
                        SizedBox(height: 10,),
                        Provider11.activeTabTimeTracked==0?                             Padding(
                          padding:EdgeInsets.only(bottom: 20),
                          child: FutureBuilder(
                                
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
                                              final data = snapshot.data;
                                              return  GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4
                                            ,crossAxisSpacing: 15,
                                            mainAxisSpacing: 15,
                                            childAspectRatio:3
                                              
                                            ),
                                          itemCount: attenData.length,
                                          itemBuilder: (BuildContext context, int index) {
                                         
                                            return  GestureDetector(
                                              onTap: (){
                                             
                                              },
                                              child: AttendenceBox(checkin: attenData[index]['checkin'].toString(), checkout: attenData[index]['checkout'].toString(), hours: 
                                  ((attenData[index]['checkin'].toString()=="null") || (attenData[index]['checkout'].toString()=="null"))?  "null":  Provider11.differenceShiftTime(attenData[index]['checkin'].toString(),attenData[index]['checkout'].toString()), dates: attenDates[index].toString(), status:attenData[index]['checkin'].toString()=="null"?"null": Provider11.statusCategorization(attenData[index]['checkin'].toString()).toString(),)
                                            );
                                          },
                                        );
                                            }
                                          }
                              
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                    
                              ),
                        ):Container(),
                       Provider11.activeTabTimeTracked==1?Column(
                         children: [
      
      
      
      
      
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
                                            final data = snapshot.data;
                                            return  
      Container(
            height: 400,
            child: Column(
              children: [
                SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      //Hide the gridlines of x-axis
                      majorGridLines: MajorGridLines(width: 0),
                      //Hide the axis line of x-axis
                      axisLine: AxisLine(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                        //Hide the gridlines of y-axis
                        majorGridLines: MajorGridLines(width: 0),
                        //Hide the axis line of y-axis
                        axisLine: AxisLine(width: 0)),
                    enableAxisAnimation: true,
                    backgroundColor: Color(0xff1F2123),
                    series: <ChartSeries>[
                      BubbleSeries<AttendanceChartData1, String>(
                          dataSource: graphData,
                          color: Colors.amber,
                          sizeValueMapper: (AttendanceChartData1 data, _) => data.early,
                          xValueMapper: (AttendanceChartData1 data, _) => data.x,
                          yValueMapper: (AttendanceChartData1 data, _) => data.early),
                      BubbleSeries<AttendanceChartData1, String>(
                          dataSource: graphData,
                          color: Colors.red,
                          sizeValueMapper: (AttendanceChartData1 data, _) => data.late,
                          xValueMapper: (AttendanceChartData1 data, _) => data.x,
                          yValueMapper: (AttendanceChartData1 data, _) => data.late),
                      BubbleSeries<AttendanceChartData1, String>(
                          dataSource: graphData,
                          color: Colors.green,
                          sizeValueMapper: (AttendanceChartData1 data, _) => data.late15,
                          xValueMapper: (AttendanceChartData1 data, _) => data.x,
                          yValueMapper: (AttendanceChartData1 data, _) => data.late15),
                    
                    ]),
                       Container(
                    width: size.width/4,
      height: 30,
       decoration: BoxDecoration(
  color: Color(0xff424344),
  borderRadius: BorderRadius.circular(10)
),
child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    AttendanceChartLegends(legendColor: Colors.red, legendName: "Late Arrival"),
    AttendanceChartLegends(legendColor: Colors.green, legendName: "On Time"),
    AttendanceChartLegends(legendColor: Colors.amber, legendName: "Early Arrival"),
  ],
),
                )
              ],
            ));
      
      
                                    
                                          }
                                        }
                            
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                  
                            ),
      
      
      
      
      
      
      
                            
      
                           
                         ],
                       ):Container(),
              
              
                  
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
        
    
    
    ElevatedButton(onPressed: (){
      generatedList();
    }, child: Text("data"));
  }
}


class AttendanceChartData1 {
  var x;
  String? y;
  double? early;
  double? late;
  double? late15;
  AttendanceChartData1({required this.x,required this.y,required this.early,required this.late,required this.late15});
}


  class ChartData {
        ChartData(this.x,this.x2,this.x3, this.y);
        final int x;
        final int x2;
        final int x3;
        final double? y;

    }




























    class Timings{
      String? date;
  String? checkin;
  String? checkout;
  String? workingHours;
  String? status;
  
  Timings({
    required this.date,
    required this.checkin,
    required this.checkout,
    required this.workingHours,
    required this.status
    });
}



class PdfService {
  Future<void> printCustomersPdf(List<Timings> data) async {


//Create a new pdf document
PdfDocument document = PdfDocument();

 document.pageSettings.margins.all = 5;
// Define margins (left, top, right, bottom) with reduced values
final EdgeInsetsGeometry reducedMargins = EdgeInsets.fromLTRB(10, 10, 10, 10);

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



  // final ByteData assetData1 = await rootBundle.load('assets/images/footer.png');
  // final Uint8List imageBytes1 = assetData1.buffer.asUint8List();

  // final ByteData assetData2 = await rootBundle.load('assets/images/header.png');
  // final Uint8List imageBytes2 = assetData2.buffer.asUint8List();

  // // Create PdfBitmap objects from the asset images
  // final PdfBitmap image1 = PdfBitmap(imageBytes1);
  // final PdfBitmap image2 = PdfBitmap(imageBytes2);

  //Draw an image to the document.
  // footer.graphics.drawImage(
  //     image1,
  //     Rect.fromLTWH(
  //         0, 0, document.pageSettings.size.width, 80));
  // header.graphics.drawImage(
  //     image2,
  //     Rect.fromLTWH(
  //         0, 0, document.pageSettings.size.width, 100));


    final PdfPage page = document.pages.add();

     page.graphics.drawString(
          'ClientName',
          PdfStandardFont(PdfFontFamily.helvetica, 10,
              style: PdfFontStyle.bold),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(50, 50, 300, 50));

      page.graphics.drawString(
          'EmployeeName',
          PdfStandardFont(PdfFontFamily.helvetica, 10,
              style: PdfFontStyle.bold),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(50, 115, 300, 50));

      page.graphics.drawString(
          'Effective Date',
          PdfStandardFont(PdfFontFamily.helvetica, 10,
              style: PdfFontStyle.bold),
          brush: PdfBrushes.black,
          bounds: Rect.fromPoints(Offset(300, 110), Offset(300, 110))
          // bounds: Rect.fromLTWH(50, 130, 300, 50)
          );

      page.graphics.drawString(
          'Expiry Date',
          PdfStandardFont(PdfFontFamily.helvetica, 10,
              style: PdfFontStyle.bold),
          brush: PdfBrushes.black,
          bounds: Rect.fromPoints(Offset(420, 110), Offset(420, 110))
          // bounds: Rect.fromLTWH(50, 130, 300, 50)
          );





















//     //Create a new PDF document
//     PdfDocument document = PdfDocument();



    PdfGrid grid = PdfGrid();
    



    
    //Define number of columns in table
    grid.columns.add(count: 5);
    //Add header to the grid
    grid.headers.add(1);
    //Add the rows to the grid
    PdfGridRow header2 = grid.headers[0];
    header2.cells[0].value = "date";
    header2.cells[1].value = "checkin";
    header2.cells[2].value = "checkout";
    header2.cells[3].value = "working hr";
    header2.cells[4].value = "status";
    
    





    //Add header style
    header2.style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightGray,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );



    //Add rows to grid
    for (final customer in data) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = customer.date;
      row.cells[1].value = customer.checkin;
      row.cells[2].value = customer.checkout;
      row.cells[3].value = customer.workingHours;
      row.cells[4].value = customer.status;
      row.cells[4].style = PdfGridCellStyle(
  backgroundBrush: row.cells[4].value=="early"?PdfBrushes.yellow:PdfBrushes.white,
  textPen:  row.cells[4].value=="early"?PdfPens.white:PdfPens.black,
   font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
   
 
);
    }
    //Add rows style
    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 15, right: 15, top: 4, bottom: 5),
      
      backgroundBrush: PdfBrushes.white,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );
    
    //Draw the grid
    grid.draw(
        page: page, bounds: const Rect.fromLTWH(0, 100, 0, 0));    





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




