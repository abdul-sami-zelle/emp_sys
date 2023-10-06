import 'package:emp_sys/pages/forgotpassword.dart';
import 'package:emp_sys/pages/landingPage.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';

import '../statemanager/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final email = TextEditingController(text:"abdulsami.zellesolutions@gmail.com");
  final password = TextEditingController(text:"123456");
  @override
  final _formKey = new GlobalKey<FormState>();
  Widget build(BuildContext context) {
    final Provider11 = Provider.of<Provider1>(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            // image: DecorationImage(
            //     image: NetworkImage(
            //         "https://img.freepik.com/free-photo/vivid-shades-colors-blur_23-2147734221.jpg"),
            //     fit: BoxFit.fill),

            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 10, 148, 223),
          Color.fromARGB(255, 182, 42, 190)
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Padding(
            //   padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
            //   child: Text(
            //     'HI',
            //     style: TextStyle(
            //         fontSize: 45,
            //         fontWeight: FontWeight.w400,
            //         color: Color.fromARGB(255, 255, 255, 255)),
            //   ),
            // ),
            // const Padding(
            //   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //   child: Text(
            //     'WELCOME BACK',
            //     style: TextStyle(
            //         fontSize: 65,
            //         fontWeight: FontWeight.w400,
            //         color: Color.fromARGB(255, 255, 255, 255)),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Container(
                height: 450,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 280, 0),
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // EMAIL BOX
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: const GradientBoxBorder(
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 10, 148, 223),
                                  Color.fromARGB(255, 182, 42, 190)
                                ]),
                                width: 3,
                              )),
                          child: TextFormField(
                            controller: email,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, color: Colors.white),
                            cursorColor: Colors.white,
                             validator: (value) =>
                            value!.isEmpty ? 'Email cannot be blank' : null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                              hintText: 'abc@gamil.com',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 250, 0),
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Password box
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: const GradientBoxBorder(
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 10, 148, 223),
                                  Color.fromARGB(255, 182, 42, 190)
                                ]),
                                width: 3,
                              )),
                          child: TextFormField(
                            obscureText: true,
                            controller: password,
                             validator: (value) =>
                            value!.isEmpty ? 'Password cannot be blank' : null,
                            cursorColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                              hintText: '*********',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.only(left: 200, bottom: 20),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         'Keep me logged in',
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.w500,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //       Checkbox(
                      //         value: true,
                      //         onChanged: null,
                      //         activeColor: Colors.white,
                      //         focusColor: Colors.white,
                      //         side: BorderSide(
                      //           color: Colors.white, //your desire colour here
                      //           width: 1.5,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                  //     Padding(
                  //       padding: const EdgeInsets.fromLTRB(80, 0, 0, 10),
                  //       child: Container(
                  //         height: 30,
                  //         width: 130,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             gradient: const LinearGradient(colors: [
                  //               Color.fromARGB(255, 10, 148, 223),
                  //               Color.fromARGB(255, 182, 42, 190)
                  //             ])),
                  //         child: ElevatedButton(
                  //           onPressed: () {
                  //             Navigator.push(context,
                  // MaterialPageRoute(builder: (context) => ForgotPassword()));;
                  //           },
                  //           style: ElevatedButton.styleFrom(
                  //               backgroundColor: Colors.transparent,
                  //               shadowColor: Colors.transparent),
                  //           child: const Text('Forgot password',style: TextStyle(fontSize: 10),),
                  //         ),
                  //       ),
                  //     ),
                  GestureDetector(
                    onTap: () {

                      Navigator.push(context,
                   MaterialPageRoute(builder: (context) => ForgotPassword()));
                      
                    },
                    child: Text('Forgotten Password',style: TextStyle(fontSize: 15,color: Colors.white,),),),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child:Provider11.loginState==false?  Container(
                          height: 44.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 10, 148, 223),
                                Color.fromARGB(255, 182, 42, 190)
                              ])),
                          child: ElevatedButton(
                            onPressed: ()async {
                              if (_formKey.currentState!.validate()) {
                                Provider11.signInWithEmailPassword(
                                  email.text, password.text, context);
                              }
                             
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
                            child: const Text('Log in'),
                          ),
                        ):CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
