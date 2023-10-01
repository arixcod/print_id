import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:print_id/create_card.dart';
import 'dashboard.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class app_login extends StatefulWidget {


  const app_login({Key? key}) : super(key: key);

  @override
  State<app_login> createState() => _app_loginState();
}

class _app_loginState extends State<app_login> {

  final  _emaiController=TextEditingController();
  final  _passwordController=TextEditingController();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  bool _showspinner = false;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: ModalProgressHUD(
        inAsyncCall: _showspinner,
        opacity: 0.4,
        progressIndicator: CircularProgressIndicator(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(100))
                      ),
                      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      width:double.infinity,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 20),
                              GestureDetector(onTap: (){
                                Navigator.pop(context);
                              },child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
                              SizedBox(width: 100),

                              Text("Log In",
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
                        decoration: BoxDecoration(
                          boxShadow: [BoxShadow(
                            color: Colors.white,
                             blurRadius: 50.0
                          )]
                        ),
                        child: Icon(Icons.account_circle,size: 60,color: Colors.black,)),
                  ),

                ],
                clipBehavior: Clip.none,
             ),

              SizedBox(height: 70,),
              Expanded(
                child:SingleChildScrollView(
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    child: Column(

                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  border: Border.all(color: Colors.redAccent,width:1.0)
                                  ,borderRadius: BorderRadius.circular(15)

                              ),
                              child: TextField(
                                controller: _emaiController,
                                decoration: InputDecoration(
                                    prefixText: ' ',
                                    prefixIcon: Icon(Icons.mail,color: Colors.lightBlue,),
                                    hintText: 'User Id / Email',
                                    border:InputBorder.none
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  border: Border.all(color: Colors.redAccent,width:1.0)
                                  ,borderRadius: BorderRadius.circular(15)

                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixText: ' ',
                                    prefixIcon: Icon(Icons.lock,color: Colors.lightBlue,),
                                    hintText: 'Password',
                                    border:InputBorder.none
                                ),
                              )),
                        ),
                        TextButton(onPressed: (){}, child: Text('Forgot Password?',style: TextStyle(fontSize:16,decoration: TextDecoration.underline),)),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(20),

                              ),
                              child: TextButton(
                                  onPressed: () async{

                                    if(_emaiController.text.isNotEmpty||_passwordController.text.isNotEmpty){
                                      setState(() {
                                        _showspinner=true;
                                      });

                                    try{
                                       final res= await _auth.signInWithEmailAndPassword(email: _emaiController.text.trim(), password: _passwordController.text.trim());
                                        print(res.user!.uid);
                                    setState(() {
                                    _showspinner=false;
                                    });
                                  if (res!=null){
                                    Navigator.of(context).pop();
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>dashboard()));
                                  }
                                }
                                catch(err){
                                  print(err);
                                }
                                }
                                else{

                                  //Creating a snackbar for notifications

                                final snackbar= SnackBar(
                                  content: Text('Email or Password field is Empty !'),
                                  action: SnackBarAction(
                                    label: 'Ok',
                                    onPressed:() {

                                    } ,
                                  ),
                                  );

                                ScaffoldMessenger.of(context).showSnackBar(snackbar);

                                }

                              }, child: Text('Login',style: TextStyle(color: Colors.white,fontFamily: 'Poppins',
                                  fontSize: 20, fontWeight: FontWeight.bold),))),
                        ),

                      ],
                    ),
                  ),
                ),
              )


            ],
          ),
        ),
      ),

    );
  }
}
