// import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/User.dart';
import 'package:notes/pages/Dashboard.dart';
import 'package:notes/pages/Login.dart';
import 'package:notes/pages/addNote.dart';
import 'package:notes/service/AuthService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SingleNote extends StatefulWidget {
  var noteData;
  SingleNote({required this.noteData});


  @override
  State<SingleNote> createState() => _SingleNoteState(noteData: noteData);
}

class _SingleNoteState extends State<SingleNote> {
  final _formKey = GlobalKey<FormState>();
  var noteData;

  late TextEditingController noteTitle;
  late TextEditingController noteDescription;

  _SingleNoteState({required this.noteData}) {
    noteTitle = TextEditingController(text: noteData['noteTitle']);
    noteDescription = TextEditingController(text: noteData['noteDescription']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple.shade500,
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: Colors.black,
        //     width: 2.0
        //   ),
        //   borderRadius: BorderRadius.circular(20)
        // ),
        padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                // readOnly: true,
                controller: noteTitle,
                validator: (val) {
                  if (val == "") {
                    return "Title Can't be blanked";
                  }
                },
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: "Note Title", 
                    // label: Text("Note Title"),
                    // enabledBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Color(0xff4c505b)) 
                    // ),
                    // border: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Color(0xff4c505b)) 
                    // ),
                    border: InputBorder.none
                ),
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .5),
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: TextFormField(
                  // readOnly: true,
                  controller: noteDescription,
                  validator: (val) {
                    if (val == "") {
                      return "Description Can't be blanked";
                    }
                  },
                  maxLines: null,
                  decoration: const InputDecoration(
                      hintText: "Note Description", border: InputBorder.none),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      letterSpacing: .5,
                    ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () async {
          if(_formKey.currentState!.validate()){
            var result = await AuthService.updateNote(noteTitle.text, noteDescription.text, noteData['userId'], noteData['uniqueId']);
                if(result != "Failed"){
                  Fluttertoast.showToast(
                    msg: "Note has been Updated Successfully",
                    textColor: Colors.white,
                    backgroundColor: Colors.green,
                    fontSize: 18,
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_LONG
                  );
                  Navigator.pop(context);
                  // Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  //   return Dashboard(id: noteData['uniqueId']);
                  // })).then((value) => setState((){}));
                }else{
                  Fluttertoast.showToast(
                    msg: "Failed to Update Note",
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                    fontSize: 18,
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_LONG
                  );
                  Navigator.push(context, CupertinoPageRoute(builder: (context) {
                    return addNote(id: noteData['uniqueId']);
                  }));
                }
          }
        },
        child: const Icon(Icons.check, size: 30,),
      ),
    );
  }
}
