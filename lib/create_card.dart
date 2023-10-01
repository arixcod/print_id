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


class create_card extends StatefulWidget {

  const create_card({Key? key}) : super(key: key);
  @override
  State<create_card> createState() => _create_cardState();
}

class _create_cardState extends State<create_card> {


  bool _showspinner = false;

  String DropdowndefaultValue='Male';
      List dropDownListItem=[
        'Male',"Female","Others"
      ];



      //creating textEditting controlleres for it to use for the fields

  final _nameController=TextEditingController();
  final _fathernamerController=TextEditingController();
  final _mobileController=TextEditingController();
  final _adressController=TextEditingController();

      final FirebaseAuth _auth=FirebaseAuth.instance;
      Uint8List? _image;
      FirebaseAppCheck  firebaseAppCheck=FirebaseAppCheck.instance;
      final FirebaseFirestore _firestore=FirebaseFirestore.instance;

   void clearAllfields(){
        _nameController.clear();
        _fathernamerController.clear();
        _mobileController.clear();
        _adressController.clear();
        DropdowndefaultValue='Male';
        _image=null;
   }
@override

      void selectimage() async{
       Uint8List _img= await pickImage(ImageSource.camera);
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

    //printing the incoming request data



  @override
  Widget build(BuildContext context) {

     return  Scaffold(
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
                      children: [
                        input_textfield(icon: Icons.person,Texthint: 'Name',controller:_nameController ,),

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

                        input_textfield(icon: Icons.male_sharp,Texthint: "Father's Name" ,controller: _fathernamerController,),
                        input_textfield(icon: Icons.phone,Texthint: 'Mobile No',controller: _mobileController,),
                        input_textfield(icon: Icons.location_on,Texthint: 'Adress',controller:_adressController ,),
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
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(20),

                              ),
                              child: TextButton(onPressed: ()async{


                                        //Check If  Fileds are not Empty....

          if(_nameController.text.isNotEmpty||_fathernamerController.text.isNotEmpty||_mobileController.text.isNotEmpty||_adressController.text.isNotEmpty){

            String downurl='';
            var uuid_path=Uuid();

              //Here Card will be created
              if(_image!=null) {

                setState(() {
                  _showspinner=true;
                });

                downurl = await StorageMethods().UploadImageto('Icards', _image!);

                try {

                  await _firestore.collection('user-cards')
                      .doc(_auth.currentUser!.uid).collection("user-id-cards").add(
                      {
                        "Name": _nameController.text.toUpperCase().trim(),
                        "Father_Name": _fathernamerController.text.toUpperCase().trim(),
                        "gender":DropdowndefaultValue,
                        "mobile": _mobileController.text.trim(),
                        "Adress": _adressController.text.trim(),
                        "Photo_Url": downurl,
                      });
                  setState(() {
                    _showspinner=false;
                  });
                  clearAllfields();

                }


                catch(err){
                  print(err);
                }
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

              }
              else
                {
                  final snackBar = SnackBar(
                    content: const Text("Select an Image !"),
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

                                //After The succesfull uploading of the data clear the Text Field and Image
                              }, child: Text('Create',style: TextStyle(color: Colors.white,fontFamily: 'Poppins',
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


class input_textfield extends StatelessWidget {
  final IconData icon;
  final String Texthint;
  final TextEditingController controller;
  const input_textfield({
    super.key,
    required this.icon,
    required this.Texthint,
    required this.controller
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
                prefixIcon: Icon(icon,color: Colors.lightBlue,),
                hintText: Texthint,
                border:InputBorder.none
            ),
          )),
    );
  }
}
