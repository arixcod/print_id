import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'input_textfield_signup.dart';



class app_signup extends StatefulWidget {
     app_signup({Key? key}) : super(key: key);

  @override
  State<app_signup> createState() => _app_signupState();
}

class _app_signupState extends State<app_signup> {
  final _auth=FirebaseAuth.instance;
  final _controller=TextEditingController();
  String email='';
  String userName='';
  String password='';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                    decoration:const  BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(100))
                    ),
                    padding:const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    width:double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                           const
                           SizedBox(width: 20),
                            GestureDetector(onTap: (){
                              Navigator.pop(context);
                            },child: const Icon(Icons.arrow_back_ios,color: Colors.white,)),
                            const SizedBox(width: 100),

                            const Text("Sign Up",
                              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white),


                            ),
                          ],
                        ),
                        SizedBox(height: 40,),

                      ],
                    )
                ),

                Positioned(
                  top: 100,
                  left: 160,
                  child: Container(
                      decoration:const BoxDecoration(
                          boxShadow: [ BoxShadow(
                              color: Colors.white,
                              blurRadius: 50.0
                          )]
                      ),
                      child:const Icon(Icons.account_circle,size: 60,color: Colors.black,)),
                ),

              ],
            ),

           const SizedBox(height: 70,),
           SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: Column(
               children: [
                 input_textfield(
                   child: TextField(
                     onChanged: (value){
                     email=value;
                     },
                     decoration:const InputDecoration(
                         prefixText: '',
                         prefixIcon: Icon(Icons.mail),
                         hintText: "Email",
                         border:InputBorder.none
                     ),
                   ),
                 ),
                 input_textfield(
                   child: TextField(
                     controller: _controller,
                     onChanged: (value){
                       userName=value;
                     },
                     decoration:const InputDecoration(
                         prefixText: '',
                         prefixIcon: Icon(Icons.mail),
                         hintText: "User Name",
                         border:InputBorder.none
                     ),
                   ),
                 ),
                 input_textfield(
                   child: TextField(
                     onChanged: (value){
                       password=value;
                     },
                     decoration:const InputDecoration(
                         prefixText: '',
                         prefixIcon: Icon(Icons.mail),
                         hintText: "Password",
                         border:InputBorder.none
                     ),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Container(
                       width: double.infinity,
                       decoration: BoxDecoration(
                         color: Colors.blueAccent,
                         borderRadius: BorderRadius.circular(20),

                       ),
                       child: TextButton(onPressed: (){
                                print(email);
                                print(password);
                                print(userName);

                       }, child:const Text('Sign Up',style: TextStyle(color: Colors.white,fontFamily: 'Poppins',
                           fontSize: 20, fontWeight: FontWeight.bold),))),
                 ),

               ],
              ),
           )
          ],
        ),
      ),

    );
  }
}

