
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods{
  var uuid_path=Uuid();

  final FirebaseStorage _storage=FirebaseStorage.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  //adding image to storage
   Future<String>UploadImageto(String ChildName,Uint8List file)async{
      String downurl='';
     // generating random path name
     Reference ref= _storage.ref().child(ChildName).child("${_auth.currentUser!.email}/${uuid_path.v1()}/${_auth.currentUser!.uid}");
                                 ref.delete();

                                 try{
                                   UploadTask uploadTask= ref.putData(file);
                                   TaskSnapshot snap= await uploadTask;
                                   String downloadurl= await snap.ref.getDownloadURL();
                                   print('This is me figureing out : ${await downloadurl}');
                                   downurl= downloadurl;
                                 }
                                 catch(err){
                                   print(err);
                                 }
           return downurl ;
  }

  Future<String>UpdateImage(String fullpath,Uint8List file)async{
       String fullblownPath= fullpath.substring(70).replaceAll('%2F', '/').replaceAll('%40','@').replaceAll('?', '  ').split(' ')[0];
       Reference ref=_storage.ref(fullblownPath);
        UploadTask uploadTask= ref.putData(file);
        TaskSnapshot snap= await uploadTask;
        String downloadurl= await snap.ref.getDownloadURL();
      return downloadurl;
  }
  Future<String> DeleteImage(String fullpath)async{
    String fullblownPath= fullpath.substring(70).replaceAll('%2F', '/').replaceAll('%40','@').replaceAll('?', '  ').split(' ')[0];
    Reference ref=_storage.ref(fullblownPath);

     //print("this is the ref coming in : ${ref}");
     await ref.delete();
     return "Deleted !";
          }
}
