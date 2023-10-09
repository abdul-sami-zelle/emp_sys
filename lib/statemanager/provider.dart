import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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




































































































































var attenData = [];
var data2 = {};
fetchFireBaseData()async{
  final ref = FirebaseDatabase.instance.ref();
final snapshot = await ref.child('attendence').get();
if (snapshot.exists) {
    data2 = snapshot.value as Map<String,dynamic>;
    print(data2.keys.toList());
} else {
    print('No data available.');
}


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

List<double> lateArrival = [];
List<double> onTimemArrival = [];
List<double> late15min = [];

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






var stack_namaz_data =[];



// find time difference 

String timeDifference(String time1,String time2) {
  // Parse the time strings into DateTime objects
  DateTime dateTime1 = DateTime.parse("2023-01-01 $time1");
  DateTime dateTime2 = DateTime.parse("2023-01-01 $time2");

  // Calculate the time difference
  Duration difference = dateTime2.difference(dateTime1);

  // Convert the duration to hours, minutes, and seconds
  int hours = difference.inHours;
  int minutes = (difference.inMinutes % 60);
  int seconds = (difference.inSeconds % 60);
  
  return "$hours:$minutes:$seconds" ;
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
          call_break_dict['duration'] = timeDifference(call_break_dict['startTime'], call_break_dict['endTime']);
          await checkInternetConnectivity();
           if (internetAvailabilty=="yes") {
           updateBreaksData(call_break_dict,"Break");
          } else {
            
            updateBreaksDataLocally(call_break_dict,"Break");
          }
          call_break_dict={};
        }else if(call_break == false){
          call_break = true;
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
          namaz_break_dict['duration'] = timeDifference(namaz_break_dict['startTime'], namaz_break_dict['endTime']);
          await checkInternetConnectivity();
          if (internetAvailabilty=="yes") {
          updateBreaksData(namaz_break_dict,"namazBreak");
          } else {
          
            updateBreaksDataLocally(namaz_break_dict,"namazBreak");
          }
          namaz_break_dict={};
        }else if(namaz_break == false){
          namaz_break = true;
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
          lunch_break_dict['duration'] = timeDifference(lunch_break_dict['startTime'], lunch_break_dict['endTime']);
          await checkInternetConnectivity();
          if (internetAvailabilty=="yes") {
          updateBreaksData(lunch_break_dict,"lunchBreak");
          } else {
          
            updateBreaksDataLocally(lunch_break_dict,"lunchBreak");
          }
          lunch_break_dict={};
        }else if(lunch_break == false){
          lunch_break = true;
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
          casual_break_dict['duration'] = timeDifference(casual_break_dict['startTime'], casual_break_dict['endTime']);
          await checkInternetConnectivity();
          if (internetAvailabilty=="yes") {
          updateBreaksData(casual_break_dict,"casualLeave");
          } else {
          
            updateBreaksDataLocally(casual_break_dict,"casualLeave");
          }
          casual_break_dict={};
        }else if(casual_break == false){
          casual_break = true;
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
          summit_break_dict['duration'] = timeDifference(summit_break_dict['startTime'], summit_break_dict['endTime']);
          await checkInternetConnectivity();
          if (internetAvailabilty=="yes") {
          updateBreaksData(summit_break_dict,"summitBreak");
          } else {
          
            updateBreaksDataLocally(summit_break_dict,"summitBreak");
          }
          summit_break_dict={};
        }else if(summit_break == false){
          summit_break = true;
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

  int activeTab = 3;

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







