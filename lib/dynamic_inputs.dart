import 'dart:convert';
import 'package:http/http.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:print_id/utils.dart';
import 'storage_methods.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class dynamic_widget extends StatefulWidget {

  const dynamic_widget({Key? key}) : super(key: key);

  @override
  State<dynamic_widget> createState() => _dynamic_widgetState();
}

class _dynamic_widgetState extends State<dynamic_widget> {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseAppCheck  firebaseAppCheck=FirebaseAppCheck.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  Uint8List? _image;

  String DropdowndefaultValue='Male';
  List dropDownListItem=[
    'Male',"Female","Others"
  ];

  void selectimage() async{
    Uint8List _img= await pickImage(ImageSource.gallery);

    final usercred=    await _auth.currentUser!.uid;
    // print("This is the  download url for image : ${usercred}");
    setState(() {
      _image=_img;
      if(_img==0){
        final snackbar= SnackBar(
          content: Text('No Image Was selected!'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed:() {

            } ,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);

      }
    });
  }


  bool _showspinner = false;
  bool _iselementLoaded=false;

  List upcoming_element_holder=[];
  final List upcomingElements=[];
  List _nameController=[TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),];
  void upcomingelementmethod()async{
    final List default_string=['Name',"Father's",'Adress','Mob No.'];
    Response res=  await get(Uri.parse('http://arixpower.in/api/'));
    final body = json.decode(res.body);
    String s=body[0]['object_fields'];
    final r=s.replaceAll('[', '') ;
    final t=r.replaceAll(']', '');
    final rec=t.split(',');
    //final recy=rec.toString().trim();
    final rec_len=rec.length;
    
     //new experiment 
   //   print(recy);
   final List el_string=[];
       
     for(int i=0 ;i<rec_len;i++){
          el_string.add(rec[i].trim()); 
     
        }
  List expHolder=[];
  String expString='';
   for(int i=0 ;i<el_string.length;i++){
          expString.trim();
          int newLength=el_string[i].length;
          for (int j=0;j<newLength-1;j++){
                if(j==0 || j==newLength-1){
                  j++;
                }
                expString=expString+'${el_string[i][j]}';
            } 
          expHolder.add(expString); 
        
          expString='';
        }
    final editedString=[];
    for(int i=0 ;i<expHolder.length;i++){

      editedString.add(expHolder[i].trim());
    }

      
    for(int i=0 ;i<editedString.length;i++){
            //here final element name will be added to its 
        setState(() {
            upcomingElements.add(editedString[i].replaceAll(' ','_').toLowerCase());
  
          });
          
          }
    
//    print(upcomingElements);
     }
  void initState() {
    upcomingelementmethod();
    super.initState();
     }

  @override
  Widget build(BuildContext context) {
    if(upcomingElements.isEmpty){
      setState(() {
        _showspinner=true;
      });

       return Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _showspinner,
          opacity: 0.4,
          progressIndicator: CircularProgressIndicator(
            valueColor:AlwaysStoppedAnimation<Color>(Colors.redAccent) ,
          ),
          child: Center(
            child: Text('Waiting for the Data ',textAlign: TextAlign.center,style: TextStyle(
              fontSize: 24,
              color: Colors.teal,
            ),
            ),
          ),
        ),
      );
    }
  else{//

    if(_iselementLoaded==false) {
        int element_length = upcomingElements.length;
        for (int i = 0; i < element_length; i++) {
          //  print(upcomingElements[i]);
          //call input field
          upcoming_element_holder.add(input_textfield(Texthint: '${upcomingElements[i]}', controller: _nameController[i]));
        }
        setState(() {
      _iselementLoaded=true;
      });
      }
      else{
        print(upcoming_element_holder);
    }


      setState(() {
        _showspinner=false;
      });
      print('line no : 10');
      print(_showspinner);
         return Scaffold(
            body: ModalProgressHUD(
              inAsyncCall: _showspinner,
              opacity: 0.4,
              progressIndicator: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
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
                                    SizedBox(width: 70),

                                    Text("Create Card",
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

                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: upcoming_element_holder.length,
                                  itemBuilder: (context, index) {
                                    return Container(child: upcoming_element_holder[index]);
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: DropdownButton(
                                      iconSize: 30,
                                      isExpanded: true,
                                      icon: Icon(Icons.male),
                                      iconEnabledColor: Colors.blueAccent,

                                      value:DropdowndefaultValue, onChanged: (newValue){
                                        setState(() {
                                            DropdowndefaultValue=newValue.toString();
                                             });

                                  },items: dropDownListItem.map((itemvalue) {
                                    return DropdownMenuItem(value:itemvalue,child: Text(itemvalue));
                                  }).toList()
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  width: double.infinity,
                                  height: 450,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.redAccent)
                                  ),
                                  child: Column(
                                    children: [
                                      //image condtions
                                      _image!=null
                                          ? Image(image: MemoryImage(_image!),height:300,width:double.infinity,fit: BoxFit.contain,)
                                          :
                                      Image(image: AssetImage('images/default_image.png'),fit: BoxFit.contain,)
                                      ,

                                      GestureDetector(
                                          onTap: (){
                                            selectimage();
                                            },
                                          child: Icon(Icons.camera_enhance,size: 60,)),
                                      Text('Add Image')
                                    ],
                                  ),
                                ),
                              )


                            ],
                          ),
                        ),
                      ),
                    )


                    , Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(onPressed: ()async {
                            setState(() {
                              _showspinner = true;
                            });
              //              print('line no : 47');
                //            print(_showspinner);

                            bool isEmpty11=false;
                            String downurl='';
                            var uuid_path=Uuid();

                            // Creating fields from texthint
                            List textfields=[];
                            List textvalues=[];
                            Map<String, dynamic> map11={'gender':DropdowndefaultValue};
                            for (int i =0;i<upcoming_element_holder.length;i++) {
                              if (_nameController[i].text.toString().isNotEmpty) {
                                isEmpty11 = true;
                                textvalues.add(_nameController[i].text.toString().trim());
                                textfields.add(upcomingElements[i].toString().trim().replaceAll(' ','_'));
                              }
                            }
                            if(isEmpty11==true){
                              for (int i =0;i<upcoming_element_holder.length;i++){
                                map11['${textfields[i]}']='${textvalues[i]}';
                              }
                            if(_image!=null) {
                              buildShowDialog(context);
                              print(_image);
                            try {
                              downurl = await StorageMethods().UploadImageto(
                                  'Icards', _image!);
                            }
                            catch(err){
                              print(err);
                            }
                            map11['Photo_Url']=downurl;

                               // creating the Map literals for the database uploading


                               //   print(map11);
                               try {

                                 await _firestore.collection('user-cards')
                                     .doc(_auth.currentUser!.uid).collection("user-id-cards").add(map11);
                                 setState(() {
                                   _showspinner=false;
                                 });
                                 Navigator.of(context).pop();

                                 for (int i =0;i<upcoming_element_holder.length;i++) {
                                      _nameController[i].clear();
                                 }
                               setState(() {
                                 _image=null;
                               });
                               }

                               catch(err){
                                 print(err);
                               }

                            }
                        // print(map11);

                    }
                               else{
                                 final snackBar = SnackBar(
                                   content: const Text("Feilds Can't Be Empty !"),
                                   action: SnackBarAction(
                                     label: 'Ok',
                                     onPressed: () {
                                       // Some code to undo the change.
                                     },
                                   ),
                                 );

                                 // Find the ScaffoldMessenger in the widget tree
                                 // and use it to show a SnackBar.
                                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
                               }

                              },


                              child: Text('Create', style: TextStyle(
                                  color: Colors.white, fontFamily: 'Poppins',
                                  fontSize: 20, fontWeight: FontWeight.bold),))),
                    ),
                  ],
                ),
              ),
            ),
          );
    }
  }
}




buildShowDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      });
}




class input_textfield extends StatelessWidget {
  final String Texthint;
  final TextEditingController controller;

  const input_textfield({
    super.key,
    required this.Texthint, required this.controller
    });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.redAccent,width:1.0)
              ,borderRadius: BorderRadius.circular(15)
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                prefixText: ' ',
                hintText: Texthint,
                border:InputBorder.none
            ),
          )),
    );
  }
}

