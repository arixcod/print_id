import 'package:flutter/material.dart';

class input_textfield extends StatelessWidget {
 Widget child;
 input_textfield({required this.child}){

 }
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
      child: child,
      ),
    );
  }
}
