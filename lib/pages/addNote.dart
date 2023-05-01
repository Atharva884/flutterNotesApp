import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/pages/Dashboard.dart';
import 'package:notes/service/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';


class addNote extends StatefulWidget {
  var id;
  addNote({required this.id});

  @override
  State<addNote> createState() => _addNoteState(id: id);
}

class _addNoteState extends State<addNote> {
  final _formKey = GlobalKey<FormState>();

  var id;
  _addNoteState({required this.id});

  @override
  Widget build(BuildContext context) {

    // To Get Focus
    FocusNode noteFocus = FocusNode();

    // Controllers
    TextEditingController noteTitle = TextEditingController();
    TextEditingController noteDescription = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              if(_formKey.currentState!.validate()){
                var result = await AuthService.addNote(noteTitle.text, noteDescription.text, id);
                if(result != "Failed"){
                  Fluttertoast.showToast(
                    msg: "Note has been Inserted",
                    textColor: Colors.white,
                    backgroundColor: Colors.green,
                    fontSize: 18,
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_LONG
                  );
                  // Navigator.pop(context);
                  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                    return Dashboard(id: id);
                  }));
                  // Navigator.pop(context);
                }else{
                  Fluttertoast.showToast(
                    msg: "Failed To Insert Note",
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                    fontSize: 18,
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_LONG
                  );
                  Navigator.push(context, CupertinoPageRoute(builder: (context) {
                    return addNote(id: id);
                  }));
                }
              }
            },
            icon: const Icon(Icons.check,)
          )
        ],
        backgroundColor: Colors.deepPurple.shade500,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: noteTitle,
                onSaved: (val){
                  if(val != ""){
                    noteFocus.requestFocus();
                  }
                },
                validator: (val){
                  if(val == ""){
                    return "Title Can't be blanked";
                  }
                },
                autofocus: true,
                decoration:  const InputDecoration(
                  hintText: "Note Title",
                  border: InputBorder.none
                  // border: OutlineInputBorder(
                  //   borderSide: BorderSide(
                  //     color: Colors.deepPurple.shade500
                  //   )
                  // )
                ),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .5           
                ),
              ),
              const SizedBox(
                height: 40,
              ),
               Expanded(
                 child: TextFormField(
                  controller: noteDescription,
                  focusNode: noteFocus,
                  validator: (val){
                    if(val == ""){
                      return "Description Can't be blanked";
                    }
                  },
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Note Description",
                    border: InputBorder.none
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    letterSpacing: .5           
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