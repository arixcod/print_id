import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:print_id/welcomePage.dart';
import 'create_card.dart';
import 'user_method/update_userdata.dart';
import 'dynamic_inputs.dart';





class dashboard extends StatefulWidget {

  const dashboard({Key? key}) : super(key: key);
  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
    String searchparameter='';
    final TextEditingController _searchcontroller=TextEditingController();
    final _firestore=FirebaseFirestore.instance;
    final FirebaseAuth _auth=FirebaseAuth.instance;
    // Page Controller
       Future<String> getCurrentUser()async{
         final user = await _auth.currentUser!.email;
          return user.toString();
          }


  @override
    void initState() {
      // TODO: implement initState
     getCurrentUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                          ),
                          child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Hello, ${_auth.currentUser!.email.toString().split('@')[0]}',textAlign:TextAlign.center,style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize:18,
                              ),
                          ),
                              GestureDetector(

                                onTap: (){

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder:(context){
                                        return  AlertDialog(
                                          title: Text('Log Out !'),
                                          content: Text('Are You Sure To Logout ?'),
                                          actions: [
                                            TextButton(onPressed: ()async{
                                              await  _auth.signOut();
                                              Navigator.push(context,MaterialPageRoute(builder: (context)=>WelcomePage()));
                                            }, child: Text('Logout')),
                                            TextButton(onPressed: (){
                                              Navigator.of(context).pop();
                                            }, child: Text('No')),
                                          ],
                                          elevation: 24.0,
                                          backgroundColor: Colors.white,

                                        );
                                      }
                                  );
                                },
                                child: Container(
                                  padding:EdgeInsets.all(5) ,
                                    decoration:BoxDecoration(
                                      color: Colors.blueAccent[400]
                                      ,borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Icon(Icons.logout,color: Colors.white,size: 30,)),
                              ),
                            ],
                          ),),

                      Container(
                     padding: EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          TextButton(onPressed: (){

                            Navigator.push(context, MaterialPageRoute(builder:(context)=>dynamic_widget()));
                          },style: ButtonStyle(backgroundColor:MaterialStatePropertyAll<Color>(Colors.redAccent),padding:MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(15))), child: Text('Dashboard',style:
                            TextStyle(color: Colors.white),)),
                          SizedBox(width: 20,),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>create_card()));
                          },style: ButtonStyle(backgroundColor:MaterialStatePropertyAll<Color>(Colors.redAccent),padding:MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(15))), child: Text('Create Card',style:
                          TextStyle(color: Colors.white),)),],),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: TextField(
                                onChanged: (value){
                                  setState(() {
                                    searchparameter=value;
                                  });
                                },
                                controller: _searchcontroller,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  border:InputBorder.none,
                                  suffixIcon: Icon(Icons.search)
                                  ,hintText: 'search ...',


                                ),),
                            )
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            ),
                                      child:StreamBuilder<QuerySnapshot>(
                                          stream: _firestore.collection('user-cards').doc(_auth.currentUser!.uid).collection('user-id-cards').snapshots(),
                                          builder: (context,snapshot) {
                                            return(snapshot.connectionState==ConnectionState.waiting?
                                                Center(child: CircularProgressIndicator()):
                                                ListView.builder(
                                                    itemCount: snapshot.data!.docs.length,
                                                    itemBuilder:(context,index){
                                                            String referencepath= snapshot.data!.docs[index].reference.path;
                                                            var data=snapshot.data!.docs[index].data() as Map<String ,dynamic>;
                                                            if(_searchcontroller.text.isEmpty){
                                                              return
                                                                 GestureDetector(
                                                                  onTap: (){
                                                                    Navigator.push(context, MaterialPageRoute(builder: (Context)=>
                                                                        update_card(refPAth:referencepath,PhotUrl: data['Photo_Url'],)
                                                                    ));
                                                                  },
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Container(
                                                                      padding: EdgeInsets.all(10),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.white54,
                                                                          border:Border.all(color: Colors.redAccent),
                                                                          borderRadius: BorderRadius.circular(15)
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                         CircleAvatar(backgroundImage:NetworkImage(data['Photo_Url'],scale: 1.0),radius: 40,),
                                                                          SizedBox(width: 30,),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(data['name'].toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins',fontSize: 17),),
                                                                              SizedBox(height: 5,),
                                                                              Text("Contact : ${data['moible_no']}"),
                                                                              SizedBox(height: 5,),
                                                                              Text("Adress :  ${data['adress']}"),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                            }
                                                            if(data['name'].toString().toLowerCase().startsWith(searchparameter.toLowerCase())){
                                                              return  GestureDetector(
                                                                onTap: (){
                                                                  Navigator.push(context, MaterialPageRoute(builder: (Context)=>
                                                                      update_card(refPAth:referencepath,PhotUrl: data['Photo_Url'],)
                                                                  ));
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Container(
                                                                    padding: EdgeInsets.all(10),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white54,
                                                                        border:Border.all(color: Colors.redAccent),
                                                                        borderRadius: BorderRadius.circular(15)
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        CircleAvatar(backgroundImage:NetworkImage(data['Photo_Url'],scale: 1.0),radius: 40,),
                                                                        SizedBox(width: 30,),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(data['name'].toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins',fontSize: 17),),
                                                                            SizedBox(height: 5,),
                                                                            Text("Contact : ${data['moible_no']}"),
                                                                            SizedBox(height: 5,),
                                                                            Text("Adress :  ${data['adress']}"),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                   return Container();
                                                    }
                                                )
                                            );


                                          })
                                      ),
                      )
                    ],
                  ),
                ),
    );
  }
}





class page1 extends StatelessWidget {
  const page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}



class page2 extends StatelessWidget {
  const page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.redAccent,
    );
  }
}

