import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:print_id/dashboard.dart';
import 'package:print_id/utils.dart';
import '/storage_methods.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class update_card extends StatefulWidget {
  final String refPAth ;
  final String PhotUrl;
  const update_card({Key? key,required this.refPAth,required this.PhotUrl}) : super(key: key);

  @override
  State<update_card> createState() => _update_cardState();
}

class _update_cardState extends State<update_card> {


  bool _showspinner = false;

  String DropdowndefaultValue='Male';
  List dropDownListItem=[
    'Male',"Female","Others"
  ];
  final FirebaseAuth _auth=FirebaseAuth.instance;
  var ImagePath='';
  TextEditingController _nameController=TextEditingController();
  TextEditingController _fathernamerController=TextEditingController();
  TextEditingController _mobileController=TextEditingController();
  TextEditingController _adressController=TextEditingController();
  Uint8List? _image;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  // void clearAllfields(){
  //   _nameController.clear();
  //   _fathernamerController.clear();
  //   _mobileController.clear();
  //   _adressController.clear();
  //     DropdowndefaultValue='Male';
  //   _image=null;
  // }


  void selectimage() async{
    Uint8List _img= await pickImage(ImageSource.gallery);

    final usercred =  await _auth.currentUser!.uid;
    print("This is the  download url for image : ${usercred}");
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
  get_firestore_data()async{

      var fire_data= await _firestore.doc(widget.refPAth).get().then((value) => value.data());
          _nameController.text=fire_data!['Name'];
          _fathernamerController.text=fire_data!['father Name'];
          _mobileController.text=fire_data!['mobile'];
          _adressController.text=fire_data!['Adress'];
            DropdowndefaultValue=fire_data!['gender'];
            ImagePath=fire_data['Photo Url'];
         }

  @override
  void initState() {
    get_firestore_data();
    // TODO: implement initState
    super.initState();
  }

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
                              Text("Update Card",
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
                                    : Image(image: NetworkImage(widget.PhotUrl,scale: 1.0),height: 300,width: 300, fit: BoxFit.contain,),
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
                              child: TextButton(
                                  onPressed: ()async{

                                    setState(() {
                                      _showspinner=true;
                                    });
                                    String path='';
                                    if(_image!=null) {
                                          path = await StorageMethods().UpdateImage(
                                          ImagePath, _image!);
                                    }
                                    await _firestore.doc(widget.refPAth).update(
                                        {
                                          'Name': _nameController.text,
                                          'mobile': _mobileController.text,
                                          'father Name': _fathernamerController.text,
                                          'gender': DropdowndefaultValue,
                                          'Adress': _adressController.text,
                                          'Photo Url': _image != null ? path:widget.PhotUrl,
                                        });
                                      setState(() {
                                        _showspinner=false;
                                      });

                              }, child: Text('Update',style: TextStyle(color: Colors.white,fontFamily: 'Poppins',
                                  fontSize: 20, fontWeight: FontWeight.bold),))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                  onPressed: ()async{
                                           setState(() {
                                             _showspinner=true;
                                           });
                                     if(ImagePath!=null) {
                                      StorageMethods().DeleteImage(ImagePath);
                                    }
                                    await _firestore.doc(widget.refPAth).delete();

                                           setState(() {
                            _showspinner=false;
                                });
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>dashboard()));
                                  }, child: Text('Delete',style: TextStyle(color: Colors.white,fontFamily: 'Poppins',
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
