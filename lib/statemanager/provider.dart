import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
import '../pages/landingPage.dart';

// import 'dart:js' as js;
// import 'package:firebase_auth_web/firebase_auth_web.dart';

class Provider1 extends ChangeNotifier {
  var dataExist;
  String? name_;
  String? age_;
  String? email_;
  Duration timeInSec = Duration(seconds: 0);
  bool isRunning = false;
  String formattedHours = "00";
  String formattedMinutes = "00";
  String formattedSeconds = "00";
  bool? startbuttonenabled = null;
  String? lastAction = null;
  String? callbutton;
  var namazBreakHistory = {};
  var namazBreak = [];
  var callBreakHistory = {};
  var callBreak = [];
  var lunchBreakHistory = {};
  var lunchBreak = [];
  var casualLeaveHistory = {};
  var casualLeave = [];
  var summitLeaveHistory = {};
  var summitLeave = [];
  var shiftTimeHistory = {};
  var shiftTime = [];

  final TextEditingController _textController = TextEditingController();
  String? savedText = '';
  Timer? timer;

  void saveText() {
    savedText = _textController.text;
  }

  void startTimer() {
    if (lastAction == 'call break') {
      var endTime = DateTime.now().toString().substring(10, 19);
      callBreakHistory['endTime'] = endTime.toString();
      //print(endTime);
      lastAction = null;
      notifyListeners();
      callBreak.add(callBreakHistory);
      callBreakHistory = {};
      print(callBreak);
      print(callBreakHistory);
      lastAction = null;
    }
    if (lastAction == 'summit leave') {
      var endTime = DateTime.now().toString().substring(10, 19);
      summitLeaveHistory['endTime'] = endTime.toString();
      //print(endTime);
      lastAction = null;
      notifyListeners();
      summitLeave.add(summitLeaveHistory);
      summitLeaveHistory = {};
      print(summitLeave);
      print(summitLeaveHistory);
    }
    if (lastAction == 'casual leave') {
      var endTime = DateTime.now().toString().substring(10, 19);
      casualLeaveHistory['endTime'] = endTime.toString();
      //print(endTime);
      lastAction = null;
      notifyListeners();
      casualLeave.add(casualLeaveHistory);
      casualLeaveHistory = {};
      print(casualLeave);
      print(casualLeaveHistory);
    }
    if (lastAction == 'lunch break') {
      var endTime = DateTime.now().toString().substring(10, 19);
      lunchBreakHistory['endTime'] = endTime.toString();
      //print(endTime);
      lastAction = null;
      notifyListeners();

      lunchBreak.add(lunchBreakHistory);
      lunchBreakHistory = {};
      print(lunchBreak);
      print(lunchBreakHistory);
      lastAction = null;
    }
    if (lastAction == 'namaz break') {
      //print("${namazBreakHistory['startTime']}  start time is here");
      var endTime = DateTime.now().toString().substring(10, 19);
      namazBreakHistory['endTime'] = endTime.toString();
      //print(endTime);
      lastAction = null;
      notifyListeners();

      namazBreak.add(namazBreakHistory);
      namazBreakHistory = {};
      print(namazBreak);
      print(namazBreakHistory);
    }
    if (startbuttonenabled == true) {
      var startTime = DateTime.now().toString().substring(10, 19);
      shiftTimeHistory['StartTime'] = startTime.toString();
      startbuttonenabled = false;
      notifyListeners();
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeInSec = timeInSec + Duration(seconds: 1);
      notifyListeners();
    });
    isRunning = true;
    notifyListeners();
  }

  void stopTimer() {
    if (lastAction == 'namaz break') {
      var startTime = DateTime.now().toString().substring(10, 19);
      namazBreakHistory['startTime'] = startTime.toString();
      //print(startTime);
      print(namazBreakHistory);
    }
    if (lastAction == 'casual leave') {
      var startTime = DateTime.now().toString().substring(10, 19);
      casualLeaveHistory['startTime'] = startTime.toString();
      //print(startTime);
      print(casualLeaveHistory);
    }
    if (lastAction == 'summit leave') {
      var startTime = DateTime.now().toString().substring(10, 19);
      summitLeaveHistory['startTime'] = startTime.toString();
      //print(startTime);
      print(summitLeaveHistory);
    }
    if (lastAction == 'call break') {
      var startTime = DateTime.now().toString().substring(10, 19);
      callBreakHistory['startTime'] = startTime.toString();
      //print(startTime);
      print(callBreakHistory);
    }
    if (lastAction == 'lunch break') {
      var startTime = DateTime.now().toString().substring(10, 19);
      lunchBreakHistory['startTime'] = startTime.toString();
      //print(startTime);
      print(lunchBreakHistory);
    }
    isRunning = false;
    timer?.cancel();
    notifyListeners();
  }

  void resetTimer() {
    if (startbuttonenabled == false) {
      var endTime = DateTime.now().toString().substring(10, 19);
      shiftTimeHistory['endTime'] = endTime.toString();
      shiftTime.add(shiftTimeHistory);
      print(shiftTimeHistory);
      shiftTimeHistory = {};
      print(shiftTime);
      print(shiftTimeHistory);
    }
    isRunning = false;
    timeInSec = Duration(seconds: 0);
    timer?.cancel();
    notifyListeners();
  }

  // void buttonCheck() {
  //   if (lastAction == 'break') {
  //     callbutton = 'enabeled';
  //   }
  // }

  @override
  notifyListeners();

  //login user//
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? uid;
  String? shift_;
  String? empId_;
  String? hours_;
  String? in_;
  String? out_;
  String? profile_;
  String? userEmail;
  String? histShiftStart;

  ResetPassword(String email) async {
    await Firebase.initializeApp();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  bool loginState = false;

  changeStateTrue() {
    loginState = true;
    notifyListeners();
  }

  changeStateFalse() {
    loginState = false;
    notifyListeners();
  }

  Future<User?> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    await Firebase.initializeApp();
    User? user;

    try {
      await changeStateTrue();
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Employes')
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;
            uid = user!.uid;
            name_ = data['name'];
            hours_ = data['hours'];
            empId_ = data['empID'];
            in_ = data['in'];
            out_ = data['out'];
            profile_ = data['profile'];
            shift_ = data['shift'];

            FirebaseFirestore.instance
                .collection('morning_Shift')
                .doc(user.uid)
                .collection(DateTime.now().toString().substring(0, 10))
                .doc(user.uid)
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                startbuttonenabled = false;
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                histShiftStart = data['startShift'].toString().substring(
                      11,
                    );
                print(histShiftStart);
              } else {
                print("not exists");
              }
            });

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LandingPage()));
          } else {
            print('Document does not exist on the database');
          }
        });
        uid = user.uid;
        userEmail = user.email;
        print(uid);
        await changeStateFalse();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
      await changeStateFalse();
    }

    return user;
  }

  CollectionReference morning_Shift =
      FirebaseFirestore.instance.collection('morning_Shift');
  Future<void> checkData() async {
    final collectionName = DateTime.now().toString().substring(0, 10);
    final collectionReference =
        morning_Shift.doc(uid).collection(collectionName);

    // Check if the collection exists
    final collectionSnapshot = await collectionReference.get();
    dataExist = collectionSnapshot;
  }

  Future<void> addemployeeData() async {
    notifyListeners();
    final collectionName = DateTime.now().toString().substring(0, 10);
    final collectionReference =
        morning_Shift.doc(uid).collection(collectionName);

    // Check if the collection exists
    final collectionSnapshot = await collectionReference.get();

    if (collectionSnapshot.docs.isEmpty) {
      // Collection doesn't exist, create a new one
      return collectionReference.doc(uid).set({
        'startShift': DateTime.now().toString(),
        'endShift': "",
        "namazBreak": [],
        // 'callBreak':[],
        "lunchBreak": [],
        "Break": [],
        "casualLeave": [],
        "summitLeave": [],
        'reason': "",
      });
    } else {
      // Collection exists, update it
      // return collectionReference.doc(uid).update({
      //   'startShift': DateTime.now().toString(),
      //}
      //);
    }
  }

  Future<void> endShiftDataBase() {
    notifyListeners();
    return morning_Shift
        .doc(uid)
        .collection(DateTime.now().toString().substring(0, 10))
        .doc(uid)
        .update({
      'endShift': DateTime.now().toString(),
    });
  }

  var lastList = [];
  // Future<void> callBreakDataBase() {
  //   notifyListeners();
  //   return morning_Shift
  //       .doc(uid)
  //       .collection(DateTime.now().toString().substring(0, 10))
  //       .doc(uid)
  //       .update({
  //     "callBreak":callBreak,
  //   });
  // }
  Future<void> BreakDataBase() {
    notifyListeners();
    return morning_Shift
        .doc(uid)
        .collection(DateTime.now().toString().substring(0, 10))
        .doc(uid)
        .update({
      "Break": callBreak,
    });
  }

  Future<void> reasonDataBase() {
    notifyListeners();
    return morning_Shift
        .doc(uid)
        .collection(DateTime.now().toString().substring(0, 10))
        .doc(uid)
        .update({
      "reason": savedText,
    });
  }

  Future<void> namazBreakDataBase() {
    return morning_Shift
        .doc(uid)
        .collection(DateTime.now().toString().substring(0, 10))
        .doc(uid)
        .update({
      "namazBreak": namazBreak,
    });
  }

  Future<void> lunchBreakDataBase() {
    return morning_Shift
        .doc(uid)
        .collection(DateTime.now().toString().substring(0, 10))
        .doc(uid)
        .update({
      "lunchBreak": lunchBreak,
    });
  }

  Future<void> casualLeaveDataBase() {
    return morning_Shift
        .doc(uid)
        .collection(DateTime.now().toString().substring(0, 10))
        .doc(uid)
        .update({
      "casualLeave": casualLeave,
    });
  }

  Future<void> summitLeaveDataBase() {
    return morning_Shift
        .doc(uid)
        .collection(DateTime.now().toString().substring(0, 10))
        .doc(uid)
        .update({
      "summitLeave": summitLeave,
    });
  }

  String findTimeDifference(String startTime, String endTime) {
    // Define a time format pattern to parse the time strings
    final timeFormat = DateFormat("HH:mm:ss");

    try {
      // Trim the input strings to remove leading and trailing spaces
      startTime = startTime.trim();
      endTime = endTime.trim();

      // Parse the time strings into DateTime objects
      final start = timeFormat.parse(startTime);
      final end = timeFormat.parse(endTime);

      // Calculate the time difference
      final difference = end.difference(start);

      // Convert the duration to a string in "HH:mm:ss" format
      final durationFormatted =
          "${difference.inHours}:${difference.inMinutes.remainder(60).toString().padLeft(2, '0')}:${difference.inSeconds.remainder(60).toString().padLeft(2, '0')}";

      return durationFormatted;
    } catch (e) {
      // Handle any parsing errors here
      print("Error parsing time: $e");
      return ""; // Return an empty string in case of an error
    }
  }









































// 

// String getTimeDifference(String startTimeStr, String endTimeStr) {
//   List<int> startTimeParts = startTimeStr.split(':').map(int.parse).toList();
//   List<int> endTimeParts = endTimeStr.split(':').map(int.parse).toList();

//   DateTime startTime = DateTime(0, 1, 1, startTimeParts[0], startTimeParts[1], startTimeParts[2]);
//   DateTime endTime = DateTime(0, 1, 1, endTimeParts[0], endTimeParts[1], endTimeParts[2]);

//   Duration difference = endTime.difference(startTime);

//   String twoDigits(int n) => n.toString().padLeft(2, '0');
//   int hours = difference.inHours;
//   int minutes = difference.inMinutes % 60;
//   int seconds = difference.inSeconds % 60;

//   return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
// }







// String? differenceShiftTime(String? time1, String? time2) {

//   if (time1 ==null || time2 ==null) {
//     return "null";
//   } else {
//      // Parse the string times into DateTime objects
//   DateFormat format = DateFormat("HH:mm:ss");
//   DateTime dateTime1 = format.parse(time1);
//   DateTime dateTime2 = format.parse(time2);
 
//   // Calculate the time difference
//   Duration difference = dateTime2.difference(dateTime1);

//   // Convert the time difference to hours
//   String hoursDifference = (difference.inMinutes / 60.0).toString().substring(0,3);
//     // Extract hours, minutes, and seconds from the time difference
//   int hours = difference.inHours;
//   int minutes = (difference.inMinutes % 60);
//   int seconds = (difference.inSeconds % 60);

//   // Format the time difference as "HH:mm:ss"
//   String formattedDifference = '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

//   return formattedDifference;

//   }
  
// }

// String? statusCategorization(String dailyArrival) {
//   String actualArrivalTime = "08:00:00 AM";

//   String arrivalCategory = categorizeArrival(actualArrivalTime, dailyArrival);
//   return arrivalCategory;
// }

// String categorizeArrival(String actualArrivalTime, String dailyArrival) {
//   // Parse the actual and daily arrival times
//   DateFormat format = DateFormat("hh:mm:ss a");
//   DateTime actualTime = format.parse(actualArrivalTime);

//   // Extract hours, minutes, and seconds from the daily arrival
//   List<String> dailyArrivalParts = dailyArrival.split(":");
//   int dailyHours = int.parse(dailyArrivalParts[0]);
//   int dailyMinutes = int.parse(dailyArrivalParts[1]);
//   int dailySeconds = int.parse(dailyArrivalParts[2]);

//   // Create a DateTime object for the daily arrival time
//   DateTime dailyTime = DateTime(
//     actualTime.year,
//     actualTime.month,
//     actualTime.day,
//     dailyHours,
//     dailyMinutes,
//     dailySeconds,
//   );

//   // Define a threshold of 15 minutes
//   Duration lateThreshold = Duration(minutes: 15);

//   // Calculate the time difference
//   Duration timeDifference = dailyTime.difference(actualTime);

//   if (timeDifference > lateThreshold) {
//     lateArrival.add(double.parse(timeDifference.inMinutes.toString()));
//     late15min.add(0);
//     onTimemArrival.add(0);
//     return timeDifference.inMinutes.toString();
//   } 
//   else if(timeDifference <= lateThreshold && timeDifference>Duration(minutes: 0,hours: 0,seconds: 0)){
//     lateArrival.add(0);
//     onTimemArrival.add(0);
//     late15min.add(double.parse(timeDifference.inMinutes.toString()));
//     return timeDifference.inMinutes.toString();
//   }
//   else {
//     print(timeDifference);
//     lateArrival.add(0);
//     late15min.add(0);
//     onTimemArrival.add(double.parse(timeDifference.inMinutes<0?(timeDifference.inMinutes*-1).toString():timeDifference.inMinutes.toString()));
//     return timeDifference.inMinutes.toString();
//   }
// }






















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

































































bool loaderEnable = false;
enablingLoader(){
  loaderEnable = true;
  notifyListeners();
}


disablingLoader(){
  loaderEnable = false;
  notifyListeners();
}







List<AttendanceChartData1> graphData = [];
List<Timings> attendanceDataPdf = [];







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




















// fetch all months:

var data2 = {};
var attendanceMonths = [];

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




//fetch attendance data 


void increament(){
  index++;

}

void decreament(){
  index--;
  
}

List<double> lateArrival = [];

List<double> onTimemArrival = [];

List<double> late15min = [];

int index = 0; 

  var attenData = [];

  var attenDates = [];

  late GlobalKey<SfCartesianChartState> _cartesianChartKey;

Future fetchFireBaseData(String selectedValue)async{
  final ref = FirebaseDatabase.instance.ref();
final snapshot = await ref.child('attendence/${selectedValue}/Day').get();
if (snapshot.exists) {
  final Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;

    // Initialize an empty Map to store the data for the specified UID
    final Map<String, dynamic> uidData = {};
    
    // Specify the UID you want to retrieve
    final desiredUid = "2dCXtkkraFST33jeRvgG4WWkT9i2";

    // Loop through the data and extract data for the desired UID
    data.forEach((date, dateData) {
      if (dateData.containsKey(desiredUid)) {
        increament();
       
        uidData[date] = dateData[desiredUid];
       
        print(uidData[date]['checkin'].toString());
        uidData[date]['checkin']==null?decreament():graphData.add(AttendanceChartData1(x: date, y:statusCategorization(uidData[date]['checkin']), early: onTimemArrival[index-1], late: lateArrival[index-1], late15:late15min[index-1]));
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

















List<int>? imgGraph;


   Future<List?> renderChartAsImage() async {
  final double pixelRatio = 2.0; // Try using a lower pixel ratio (e.g., 2.0)
  final ui.Image data = await _cartesianChartKey.currentState!.toImage(pixelRatio: pixelRatio);
  final ByteData? bytes = await data.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List imageBytes = bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  imgGraph=imageBytes;
  print(imgGraph);
  return imageBytes;
}





// database variable names:

// for call break list:
String callBreakListDBName = 'Break';

// for casual break list:
String casualBreakListDBName = 'casualLeave';

// for lunch break list:
String lunchBreakListDBName = 'lunchBreak';

// for namaz break
String namazBreakListDBName = 'namazBreak';

// for summit break
String summitBreakListDBName = 'summitLeave';
































  Future<String> downloadURLExample( String filePath) async {
   String downloadURL = await FirebaseStorage.instance
        .ref("$filePath")
        .child("logo.png")
        .getDownloadURL();
    print(downloadURL);
    return downloadURL;
  }














String differenceShiftTime(String? time1, String? time2) {
  
  if ((time1 == null )|| (time2 == null)) {
    print("${time2} here is time 2");
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


List<String> timee = [];


String? statusCategorization(String dailyArrival) {
  String actualArrivalTime = "08:00:00 AM";

  String arrivalCategory = categorizeArrival(actualArrivalTime, dailyArrival);
  timee.add(arrivalCategory);
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
    print(timeDifference.inMinutes);
    return "late";
  } else if(timeDifference<Duration(minutes: 0,hours: 0,seconds: 0)){
    return "early";
  }
  else {
    print(timeDifference);
    return "onTime";
  }
}
// cases for enabling already enabled breaks:

checkEnabilityBreakBtn(String active,String activeTime){

  switch (active) {
    case 'Break':
      call_break = true;
      call_break_dict['startTime']=activeTime;
      break;

    case 'namazBreak':
      namaz_break = true;
      namaz_break_dict['startTime']=activeTime;
      break;
    
    case 'lunchBreak':
      lunch_break = true;
      lunch_break_dict['startTime']=activeTime;
      break;

    case 'casualBreak':
      casual_break = true;
      casual_break_dict['startTime']=activeTime;
      break;

    case 'summitBreak':
      summit_break = true;
      summit_break_dict['startTime']=activeTime;
      break;

    default:
  }

  notifyListeners();

}

// last checkin, checkout, shiftStart ,shiftEnd



String? lastCheckin;
String? lastCheckout;
String? lastShiftStart;
String? lastShiftEnd;

lastStats()async{
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('attendence/October 2023/Day/12-10-2023/2dCXtkkraFST33jeRvgG4WWkT9i2').get();
  Map<String,dynamic> data = snapshot.value as Map<String,dynamic>;
  print(snapshot.value);
  lastCheckin = data['checkin'];
  lastCheckout = data['checkout'];
  notifyListeners();
}


//


// already active break data

String? alreadyActive;
String? alreadyActiveTime;


Duration namazBreakSum = Duration();
Duration lunchBreakSum = Duration();
Duration callBreakSum = Duration();
Duration summitBreakSum = Duration();
Duration casualBreakSum = Duration();



// check either collection exist or not?

Future<bool> doesCollectionExist() async {
  try {
    final DocumentSnapshot document = await FirebaseFirestore.instance.collection('morning_Shift').doc('2dCXtkkraFST33jeRvgG4WWkT9i2').collection('2023-10-01').doc('2dCXtkkraFST33jeRvgG4WWkT9i2').get();
    if (document.exists) {
      Map<String,dynamic> data = document.data() as Map<String,dynamic>;
        // Initialize variables to store the sum of durations
  // Iterate through callBreak and calculate the sum of durations
 data["$callBreakListDBName"]!=[]? data["$callBreakListDBName"].forEach((item) {
    final List<dynamic> durationParts = item["duration"].split(':').map(int.parse).toList();
    final Duration duration = Duration(
      hours: durationParts[0],
      minutes: durationParts[1],
      seconds: durationParts[2],
    );
    callBreakSum += duration;
  }):null;




  // Iterate through namazBreak and calculate the sum of durations
 data["$namazBreakListDBName"]!=[]? data["$namazBreakListDBName"].forEach((item) {
    final List<dynamic> durationParts = item["duration"].split(':').map(int.parse).toList();
    final Duration duration = Duration(
      hours: durationParts[0],
      minutes: durationParts[1],
      seconds: durationParts[2],
    );
    namazBreakSum += duration;
  }):null;

  // Iterate through lunchBreak and calculate the sum of durations
 data["$lunchBreakListDBName"]!=[]? data["$lunchBreakListDBName"].forEach((item) {
    final List<dynamic> durationParts = item["duration"].split(':').map(int.parse).toList();
    final Duration duration = Duration(
      hours: durationParts[0],
      minutes: durationParts[1],
      seconds: durationParts[2],
    );
    lunchBreakSum += duration;
  }):null;


    // Iterate through casualBreak and calculate the sum of durations
 data["$casualBreakListDBName"]!=[]? data["$casualBreakListDBName"].forEach((item) {
    final List<dynamic> durationParts = item["duration"].split(':').map(int.parse).toList();
    final Duration duration = Duration(
      hours: durationParts[0],
      minutes: durationParts[1],
      seconds: durationParts[2],
    );
    casualBreakSum += duration;
  }):null;


      // Iterate through summitBreak and calculate the sum of durations
  data["$summitBreakListDBName"]!=[]? data["$summitBreakListDBName"].forEach((item) {
    final List<dynamic> durationParts = item["duration"].split(':').map(int.parse).toList();
    final Duration duration = Duration(
      hours: durationParts[0],
      minutes: durationParts[1],
      seconds: durationParts[2],
    );
    summitBreakSum += duration;
  }):null;

  print("Total Namaz Break Duration: $callBreakSum");
  print("Total Lunch Break Duration: $namazBreakSum");
  print("Total Namaz Break Duration: $lunchBreakSum");
  print("Total Lunch Break Duration: $casualBreakSum");
  print("Total Lunch Break Duration: $summitBreakSum");


 lastStats();



      // coditions for checking either he started shift or end or not
      if (data['startShift']!="" && data['endShift']!="") {
        print("your todays shift is complete");
      } else if(data['startShift']!="" && data['endShift']=="") {
       await enableShiftStartButton();
       if (data['active']!="" && data['activeStartTime']!="") {
         checkEnabilityBreakBtn(data['active'].toString(),data['activeStartTime'].toString());
       } else {
         
       }
        print("your todays shift is  at ${data['startShift']}");
      }
      else{

      }
      //--
      
    } else {
      // Document doesn't exist.
      return false;
    }
 
    return document.exists;
  } catch (e) {

    // If an error occurs, the collection doesn't exist.
    print(" not exists $e");
    return false;
  }
  
}



  Future<void> updateActiveData(var breakOf) {
    
    return morning_Shift
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .collection("2023-10-01")
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .update({
      "active": breakOf.toString(),
      "activeStartTime":DateTime.now().toString().substring(11,19)
    });
  }


  Future<void> updateActiveDataLocally(var breakOf) {
    FirebaseFirestore.instance.enablePersistence();
    return morning_Shift
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .collection("2023-10-01")
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .update({
       "active": breakOf.toString(),
       "activeStartTime":DateTime.now().toString().substring(11,19)
    });
  }



  Future<void> updateActivetoNull() {
    
    return morning_Shift
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .collection("2023-10-01")
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .update({
      "active": "",
      "activeStartTime":""
    });
  }






  Future<void> updateActivetoNullLocally() {
    FirebaseFirestore.instance.enablePersistence();
    return morning_Shift
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .collection("2023-10-01")
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .update({
      "active": "",
      "activeStartTime":""
    });
  }














































var stack_namaz_data =[];



// find time difference 

String timeDifferenceString(String time1,String time2) {
  // Parse the time strings into DateTime objects
  DateTime dateTime1 = DateTime.parse("2023-01-01 $time1");
  DateTime dateTime2 = DateTime.parse("2023-01-01 $time2");

  // Calculate the time difference
  Duration difference = dateTime2.difference(dateTime1);

  // Convert the duration to hours, minutes, and seconds
  int hours = difference.inHours;
  int minutes = (difference.inMinutes % 60);
  int seconds = (difference.inSeconds % 60);
  
  return "${difference.inHours}:${(difference.inMinutes % 60)}:${(difference.inSeconds % 60)}" ;
}


Duration timeDifference(String time1, String time2) {
  // Parse the time strings into DateTime objects
  DateTime dateTime1 = DateTime.parse("2023-01-01 $time1");
  DateTime dateTime2 = DateTime.parse("2023-01-01 $time2");

  // Calculate the time difference
  Duration difference = dateTime2.difference(dateTime1);

  return difference;
}















String getTimeDifference(String startTimeStr, String endTimeStr) {
  List<int> startTimeParts = startTimeStr.split(':').map(int.parse).toList();
  List<int> endTimeParts = endTimeStr.split(':').map(int.parse).toList();

  DateTime startTime = DateTime(0, 1, 1, startTimeParts[0], startTimeParts[1], startTimeParts[2]);
  DateTime endTime = DateTime(0, 1, 1, endTimeParts[0], endTimeParts[1], endTimeParts[2]);

  if (endTime.isBefore(startTime)) {
    // If end time is before start time, add a day to the end time
    endTime = endTime.add(Duration(days: 1));
  }

  Duration difference = endTime.difference(startTime);

  String twoDigits(int n) => n.toString().padLeft(2, '0');
  int hours = difference.inHours;
  int minutes = difference.inMinutes % 60;
  int seconds = difference.inSeconds % 60;

  return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
}











// shift timings starting and ending;

  String? startTime;
  String? endTime;

  bool shiftStarted = false;
  bool breakActive = false;

  bool call_break = false;
  bool namaz_break = false;
  bool lunch_break = false;
  bool casual_break = false;
  bool summit_break = false;

  var call_break_controller = ValueNotifier<bool>(false);
  var namaz_break_controller = ValueNotifier<bool>(false);
  var lunch_break_controller = ValueNotifier<bool>(false);
  var casual_break_controller = ValueNotifier<bool>(false);
  var summit_break_controller = ValueNotifier<bool>(false);

  String? activeBreakIndex;

  enableShiftStartButton(){
    shiftStarted = true;
    notifyListeners();
  }


  startShiftTime()async {
    
    startTime = DateTime.now().toString();
    shiftStarted = true;
    print(startTime);
    notifyListeners();
  }

  endShiftTime() async{
    await checkInternetConnectivity();
    if (internetAvailabilty=="yes") {
      if (stack_namaz_data.length!=0) {
        updateBreaksData2(stack_namaz_data);
      } else {
        
      }
      endTime = DateTime.now().toString();
      shiftStarted = false;
      print(endTime);
    } else {
      print("nottt");
    }
    
    notifyListeners();
  }



  String? internetAvailabilty;
checkInternetConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    internetAvailabilty = "none";
    print("No Internet connection");
  } else if (connectivityResult == ConnectivityResult.mobile) {
    internetAvailabilty = "yes";
    print("Mobile data connection");
  } else if (connectivityResult == ConnectivityResult.wifi) {
    internetAvailabilty = "yes";
    print("Wi-Fi connection");
  }
}


  Future<void> updateBreaksData2(var data) {
    
    return morning_Shift
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .collection("2023-10-01")
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .update({
      "namazBreak": FieldValue.arrayUnion(data),
    });
  }


  Future<void> updateBreaksData(var data , var dataFor) {
    return morning_Shift
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .collection("2023-10-01")
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .update({
      "$dataFor": FieldValue.arrayUnion([data]),
    });
  }

  
  Future<void> updateBreaksDataLocally(var data , var dataFor)async {
    FirebaseFirestore.instance.enablePersistence();
    return morning_Shift
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .collection("2023-10-01")
        .doc("2dCXtkkraFST33jeRvgG4WWkT9i2")
        .update({
      "$dataFor": FieldValue.arrayUnion([data]),
    });
  }



  changeActiveBreakIndex(String indexOfBreak) async{
    if (shiftStarted==true) {
      activeBreakIndex = indexOfBreak;
   
    switch (indexOfBreak) {




      case "0":
        if(call_break == true){
          call_break = false;
          call_break_dict['endTime']=DateTime.now().toString().substring(11,19);
          call_break_dict['duration'] = timeDifferenceString(call_break_dict['startTime'], call_break_dict['endTime']);
          callBreakSum += timeDifference(call_break_dict['startTime'], call_break_dict['endTime']);
          await checkInternetConnectivity();
           if (internetAvailabilty=="yes") {
           updateBreaksData(call_break_dict,"Break");
          await updateActivetoNull();
          } else {
            updateBreaksDataLocally(call_break_dict,"Break");
            updateActivetoNull();
          }
          call_break_dict={};
        }else if(call_break == false){
          call_break = true;
          if (internetAvailabilty=="yes") {
            await updateActiveData('Break');
          }else{
            await updateActiveDataLocally('Break');
          }
          
          call_break_dict['startTime']=DateTime.now().toString().substring(11,19);
        }
        
        namaz_break = false;
        lunch_break = false;
        casual_break = false;
        summit_break = false;
        print("call break");
        break;




      case "1":
      if(namaz_break == true){
          namaz_break = false;
          namaz_break_dict['endTime']=DateTime.now().toString().substring(11,19);
          namaz_break_dict['duration'] = timeDifferenceString(namaz_break_dict['startTime'], namaz_break_dict['endTime']);
          namazBreakSum += timeDifference(namaz_break_dict['startTime'], namaz_break_dict['endTime']);
          await checkInternetConnectivity();
          if (internetAvailabilty=="yes") {
          updateBreaksData(namaz_break_dict,"namazBreak");
          updateActivetoNull();
          } else {
          
            updateBreaksDataLocally(namaz_break_dict,"namazBreak");
            updateActivetoNullLocally();
          }
          namaz_break_dict={};
        }else if(namaz_break == false){
          namaz_break = true;
           if (internetAvailabilty=="yes") {
            await updateActiveData('namazBreak');
          }else{
            await updateActiveDataLocally('namazBreak');
          }
          namaz_break_dict['startTime']=DateTime.now().toString().substring(11,19);
        }
        call_break = false;
        lunch_break = false;
        casual_break = false;
        summit_break = false;
        print("namaz break");
        break;




        
      case "2":
         if(lunch_break == true){
          lunch_break = false;
          lunch_break_dict['endTime']=DateTime.now().toString().substring(11,19);
          lunch_break_dict['duration'] = timeDifferenceString(lunch_break_dict['startTime'], lunch_break_dict['endTime']);
          lunchBreakSum += timeDifference(lunch_break_dict['startTime'], lunch_break_dict['endTime']);
          await checkInternetConnectivity();
          if (internetAvailabilty=="yes") {
          updateBreaksData(lunch_break_dict,"lunchBreak");
          updateActivetoNull();
          } else {
          
            updateBreaksDataLocally(lunch_break_dict,"lunchBreak");
            updateActivetoNullLocally();
          }
          lunch_break_dict={};
        }else if(lunch_break == false){
          lunch_break = true;
          if (internetAvailabilty=="yes") {
            await updateActiveData('lunchBreak');
          }else{
            await updateActiveDataLocally('lunchBreak');
          }
          lunch_break_dict['startTime']=DateTime.now().toString().substring(11,19);
        }
        call_break = false;
        namaz_break = false;
        casual_break = false;
        summit_break = false;
        print("lunch break");
        break;




      case "3":
      if(casual_break == true){
          casual_break = false;
         casual_break_dict['endTime']=DateTime.now().toString().substring(11,19);
          casual_break_dict['duration'] = timeDifferenceString(casual_break_dict['startTime'], casual_break_dict['endTime']);
          casualBreakSum += timeDifference(casual_break_dict['startTime'], casual_break_dict['endTime']);
          await checkInternetConnectivity();
          if (internetAvailabilty=="yes") {
          updateBreaksData(casual_break_dict,"casualLeave");
          updateActivetoNull();
          } else {
            
            updateBreaksDataLocally(casual_break_dict,"casualLeave");
            updateActivetoNullLocally();
          }
          casual_break_dict={};
        }else if(casual_break == false){
          casual_break = true;
           if (internetAvailabilty=="yes") {
            await updateActiveData('casualBreak');
          }else{
            await updateActiveDataLocally('casualBreak');
          }
          casual_break_dict['startTime']=DateTime.now().toString().substring(11,19);
        }
       
        call_break = false;
        namaz_break = false;
        lunch_break = false;
        summit_break = false;
        print("casual break");
        break;



      case "4":
       if(summit_break == true){
          summit_break = false;
          summit_break_dict['endTime']=DateTime.now().toString().substring(11,19);
          summit_break_dict['duration'] = timeDifferenceString(summit_break_dict['startTime'], summit_break_dict['endTime']);
           summitBreakSum += timeDifference(summit_break_dict['startTime'], summit_break_dict['endTime']);
          await checkInternetConnectivity();
          if (internetAvailabilty=="yes") {
          updateBreaksData(summit_break_dict,"summitBreak");
          updateActivetoNull();
          } else {
            
            updateBreaksDataLocally(summit_break_dict,"summitBreak");
            updateActivetoNullLocally();
          }
          summit_break_dict={};
        }else if(summit_break == false){
          summit_break = true;
           if (internetAvailabilty=="yes") {
            await updateActiveData('summitBreak');
          }else{
            await updateActiveDataLocally('summitBreak');
          }
          summit_break_dict['startTime']=DateTime.now().toString().substring(11,19);
        }
        
        call_break = false;
        namaz_break = false;
        lunch_break = false;
        casual_break = false;

        print("summit break");
        break;
      default:
        call_break = false;
        namaz_break = false;
        lunch_break = false;
        casual_break = false;
        summit_break = false;
        print('Invalid day of week.');
    }

    } else {
      null;
      print("Your Shift isn't started");
    }
    
    notifyListeners();

  }




// 0

  var call_break_dict={};
  var call_break_list =[];

  var namaz_break_dict={};
  var namaz_break_list =[];

  var lunch_break_dict={};
  var lunch_break_list =[];

  var casual_break_dict={};
  var casual_break_list =[];

  var summit_break_dict={};
  var summit_break_list =[];

  int activeTab = 0;

  changeSideTab(int tabIndex) {
    activeTab = tabIndex;
    notifyListeners();
  }

  int activeTabTimeTracked = 0;

  changeTimeTrackTab(int tabIndex) {
    activeTabTimeTracked = tabIndex;
    notifyListeners();
  }
}

class TimeTrackingData {
  factory TimeTrackingData.fromJson(Map<String, dynamic> json) {
    return TimeTrackingData(
      callBreak: json['address']['street'],
      casualBreak: json['address']['suite'],
      date: json['address']['street'],
      endShift: json['address']['street'],
      lunchBreak: json['username'],
      namazBreak: json['name'],
      serialNo: json['id'],
      startShift: json['address']['street'],
      summitBreak: json['address']['city'],
    );
  }
  int? serialNo;
  String? date;
  String? startShift;
  String? endShift;
  String? callBreak;
  String? namazBreak;
  String? lunchBreak;
  String? casualBreak;
  String? summitBreak;
  TimeTrackingData(
      {required this.callBreak,
      required this.casualBreak,
      required this.date,
      required this.endShift,
      required this.lunchBreak,
      required this.namazBreak,
      required this.serialNo,
      required this.startShift,
      required this.summitBreak});
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