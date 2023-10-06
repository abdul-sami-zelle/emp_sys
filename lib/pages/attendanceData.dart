import 'dart:convert';

import 'package:emp_sys/statemanager/provider.dart';
import 'package:emp_sys/widgets/TimeTrackingEmployeGraphs/bubbleChart.dart';
import 'package:emp_sys/widgets/multi.dart';
import 'package:emp_sys/widgets/multiCentered.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AttendanceData extends StatelessWidget {
   AttendanceData({super.key});

  @override
  List<TimeTrackingData> dataa=[];
  Future<List<TimeTrackingData>> generatedList()async{
    var response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    var decodedData = json.decode(response.body).cast<Map<String,dynamic>>();
     dataa = await decodedData.map<TimeTrackingData>((json)=>TimeTrackingData.fromJson(json)).toList();
    print(dataa);
    return dataa;
  }


  
var attendanceMonths = [];
var data2 = {};
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





  var attenData = [];
Future fetchFireBaseData()async{
  final ref = FirebaseDatabase.instance.ref();
final snapshot = await ref.child('attendence/October 2023/Day').get();
if (snapshot.exists) {
  final Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;

    // Initialize an empty Map to store the data for the specified UID
    final Map<String, dynamic> uidData = {};

    // Specify the UID you want to retrieve
    final desiredUid = "DuUvP5T3GINqQT1E8Wy9OSang332";

    // Loop through the data and extract data for the desired UID
    data.forEach((date, dateData) {
      if (dateData.containsKey(desiredUid)) {
        uidData[date] = dateData[desiredUid];
      }
    });

    // Print the extracted data for the specified UID
    attenData=uidData.values.toList();
    
} else {
    print('No data available.');
}

return attenData;
}





  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Provider11 = Provider.of<Provider1>(context, listen: true);
    return  SingleChildScrollView(
      child: Column(
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
                               Image.network("https://cdn-icons-png.flaticon.com/128/5261/5261933.png",height: 20,width: 20,color:Colors.white,)
                            ],
                          ),
                        SizedBox(height: 10,),
                        Provider11.activeTabTimeTracked==1?  BubbleChart():Container(),
                       Provider11.activeTabTimeTracked==0?Row(
                         children: [
                          Expanded(
                            flex: 3,
                            child: FutureBuilder(
                              future: fetchAttendanceMonths(), 
                              builder: (BuildContext context, snapshot){
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
                                             
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: attendanceMonths.length,
                                                itemBuilder: (context, index){
                                                return Multi(color: Colors.white, subtitle: attendanceMonths[index].toString(), weight: FontWeight.bold, size: 3);
                                              });
                                            }
                                          }
                                           return const Center(
                                            child: CircularProgressIndicator(),
                                          );

                              })
                            ),
                           Expanded(
                            flex: 7,
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
                                              return DataTable(
                                                columnSpacing: 17,
                                                headingRowHeight: 70,
                                                columns: [
                                                  
                                                  DataColumn(
                                                  
                                                    label: Multi(color: Color(0xff8F95A2), subtitle: "S No.", weight: FontWeight.bold, size: 3)
                                                    ),
                                                  DataColumn(
                                                    label: Multi(color: Color(0xff8F95A2), subtitle: "date", weight: FontWeight.bold, size: 3)
                                                    ),
                                                  DataColumn(
                                                    label: Multi(color: Color(0xff8F95A2), subtitle: "Check In", weight: FontWeight.bold, size: 3)
                                                    ),
                                                    DataColumn(
                                                    label: Multi(color: Color(0xff8F95A2), subtitle: "Check Out", weight: FontWeight.bold, size: 3)
                                                    ),
                                                 
                                                ], 
                                                rows: attenData.map((e)=>DataRow(cells: [
                                                  DataCell(MultiCentered(color: Color(0xff8F95A2), subtitle:e.toString(), weight: FontWeight.normal, size: 3)),
                                                  DataCell(Multi(color: Color(0xff8F95A2), subtitle: "", weight: FontWeight.normal, size: 3)),
                                                  DataCell(Multi(color: Color(0xff8F95A2), subtitle:e['checkin'].toString(), weight: FontWeight.normal, size: 3)),
                                                  DataCell(Multi(color: Color(0xff8F95A2), subtitle:e['checkout'].toString(), weight: FontWeight.normal, size: 3)),
                                                  
                                                ])).toList()
                                                );
                                            }
                                          }
                              
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                    
                              ),
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