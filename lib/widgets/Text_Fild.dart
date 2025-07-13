import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFormFildWidget extends StatelessWidget {
    TextEditingController inputText = TextEditingController();
   final String hintError ;
   final String hintLable;
    TextFormFildWidget({super.key , required this.inputText ,required this.hintError,required this.hintLable});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (String? value){
        if (value?.trim().isEmpty?? false ){
          return hintError;
        }
        return null;
      },
      controller: inputText,
      style: Theme.of(context).textTheme.labelMedium,
      decoration: InputDecoration(
        hintText: hintLable,
      ),

      onChanged: (value){

      },
    );
  }
}
