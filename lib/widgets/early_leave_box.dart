import 'package:emp_sys/statemanager/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogBox extends StatelessWidget {
  DialogBox({Key? key});

  @override
  TextEditingController reason = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  Widget build(BuildContext context) {
    final Provider11 = Provider.of<Provider1>(context, listen: true);
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 32, 35, 50),
      insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Your reason',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w500),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Image(
                image: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/128/1617/1617543.png'),
                height: 25,
                width: 25,
                color: Colors.white,
              ))
        ],
      ),
      content: Container(
        height: 150,
        width: 270,
        child: Column(
          children: [
            Form(
              key:_formKey ,
              child: TextFormField(
                 validator: (value) =>
                  value!.isEmpty ? 'Email cannot be blank' : null,
              // onSaved: (value) => _email = value,
            
              controller: reason,
              style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Color.fromARGB(255, 255, 255, 255)),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w500),
                hintText: 'Enter text...',
              ),
            ),),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: ElevatedButton(
                onPressed: () {
                 if (_formKey.currentState!.validate()) {
                     print(reason.text);
                  Provider11.savedText = reason.text;
                  print(Provider11.savedText);
                  Navigator.of(context).pop();
                  Provider11.savedText == null
                      ? null
                      : Provider11.startbuttonenabled != false
                          ? null
                          : Provider11.resetTimer();
                  Provider11.lastAction = null;
                  Provider11.startbuttonenabled = null;
                  Provider11.endShiftDataBase();
                  Provider11.reasonDataBase();
                 }
                },
                child: const Text('Enter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
