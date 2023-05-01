import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/models/User.dart';
import 'package:notes/pages/Login.dart';
import 'package:notes/pages/SingleNote.dart';
import 'package:notes/pages/Statistic.dart';
import 'package:notes/pages/addNote.dart';
import 'package:notes/service/AuthService.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  var id;
  Dashboard({required this.id});

  @override
  _DashboardState createState() => _DashboardState(id: id);
  // List<String> id = [];
}

class _DashboardState extends State<Dashboard> {
  var id;
  _DashboardState({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple.shade500,
        elevation: 0,
        title: const Text(
          "Notes App",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var sharedPref = await SharedPreferences.getInstance();
              sharedPref.setBool('Login', false);
              sharedPref.setString("id", "");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return Login();
              }));
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
              size: 30,
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: AuthService.getNotesById(id),
          builder: (context, AsyncSnapshot snapshot) {
            print(snapshot.hasData);
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return SingleNote(noteData: snapshot.data[index]);
                      })).then((value) => setState(() {}));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          border: Border.all(color: Colors.purple.shade500),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Icon(
                            Icons.note_alt_outlined,
                            size: 40,
                            color: Colors.yellow,
                          ),
                          title: Text(
                            snapshot.data[index]['noteTitle'],
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data[index]['noteDescription'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              var response = await AuthService.deleteNoteById(
                                  snapshot.data[index]['uniqueId']);
                              if (response == "Deleted") {
                                Fluttertoast.showToast(
                                    msg: "Note has been Deleted Successfully",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.green,
                                    fontSize: 18,
                                    gravity: ToastGravity.BOTTOM,
                                    toastLength: Toast.LENGTH_LONG);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Dashboard(id: id);
                                }));
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Failed to Delete Note",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    fontSize: 18,
                                    gravity: ToastGravity.BOTTOM,
                                    toastLength: Toast.LENGTH_LONG);
                              }
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
              // return GridView.builder(
              //     itemCount: snapshot.data.length,
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 2),
              //     itemBuilder: (context, index) {
              //       return Container(
              //           padding: EdgeInsets.only(top: 20, left: 10, right: 15),
              //           margin: EdgeInsets.only(top: 25, left: 15, right: 15),
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(10),
              //               border: Border.all(
              //                 color: Colors.grey,
              //                 width: 2,
              //               )),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 snapshot.data[index]['noteTitle'],
              //                 style: const TextStyle(
              //                   fontSize: 24,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //                 maxLines: 1,
              //                 overflow: TextOverflow.ellipsis,
              //               ),
              //               const Divider(
              //                 thickness: 2,
              //               ),
              //               Text(
              //                 snapshot.data[index]['noteDescription'],
              //                 style: const TextStyle(
              //                     fontSize: 18,
              //                     height: 1.4,
              //                     fontWeight: FontWeight.w400,
              //                     color: Color(0xff4c505b)),
              //                 maxLines: 5,
              //                 overflow: TextOverflow.ellipsis,
              //               ),
              //               Row(
              //                 // crossAxisAlignment: CrossAxisAlignment.end,
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 // mainAxisSize: MainAxisSize.max,
              //                 children: [
              //                   TextButton(
              //                       onPressed: () {
              //                         Navigator.push(context,
              //                             CupertinoPageRoute(
              //                                 builder: (context) {
              //                           return SingleNote(
              //                               noteData: snapshot.data[index]);
              //                         })).then((value) => setState(() {}));
              //                       },
              //                       child: const Text(
              //                         // Icons.remove_red_eye
              //                         "View",
              //                         style: TextStyle(
              //                             fontSize: 18, color: Colors.green),
              //                       )),
              //                   IconButton(
              //                     onPressed: () async {
              //                       var result =
              //                           await AuthService.deleteNoteById(
              //                               snapshot.data[index]['uniqueId']);
              //                       print(result);
              //                       if (result == "Deleted") {
              //                         Fluttertoast.showToast(
              //                           msg: "Note Deleted Successfully",
              //                           textColor: Colors.white,
              //                           backgroundColor: Colors.red,
              //                           fontSize: 18,
              //                           toastLength: Toast.LENGTH_LONG,
              //                           gravity: ToastGravity.BOTTOM,
              //                         );
              //                         // Navigator.push(context, CupertinoPageRoute(builder: (context){
              //                         //   return Dashboard(id: id);
              //                         // }));
              //                         setState(() {});
              //                       } else {
              //                         Fluttertoast.showToast(
              //                           msg: "Failed to delete Note",
              //                           textColor: Colors.white,
              //                           backgroundColor: Colors.red,
              //                           fontSize: 18,
              //                           toastLength: Toast.LENGTH_LONG,
              //                           gravity: ToastGravity.BOTTOM,
              //                         );
              //                       }
              //                     },
              //                     icon: const Icon(
              //                       Icons.delete,
              //                       color: Colors.red,
              //                     ),
              //                     iconSize: 28,
              //                   )
              //                 ],
              //               )
              //             ],
              //           ));
              //     });
            }else{
              return const Center(
                  child: Text("No Notes Found", style:  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  ),)
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade500,
        onPressed: () => {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) {
                    print(id);
                    return addNote(id: id);
                  }))
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// class Drawer1 extends StatefulWidget {
//   var id;
//   Drawer1({required this.id});

//   @override
//   State<Drawer1> createState() => _Drawer1State(id: id);
// }

// class _Drawer1State extends State<Drawer1> {
//   var id;
//   _Drawer1State({required this.id});

//   File? filePathName;
//   String? ImageData;
//   String? ImageName;

//   ImagePicker imagePicker = ImagePicker();
//   Future<void> getImage() async {
//     var image = await imagePicker.pickImage(source: ImageSource.gallery);

//     setState((){
//       filePathName = File(image!.path);
//       ImageName = image.path.split('/').last;
//       ImageData = base64Encode(filePathName!.readAsBytesSync());
//     });

//     print(filePathName);
//     print(ImageName);
//     print(ImageData);
//   }
  

//   // @override
//   // Widget build(BuildContext context) {
//   //   return FutureBuilder(
//   //     future: AuthService.getImageFromDb(id),
//   //     builder: (context, AsyncSnapshot snapshot){
//   //       print(snapshot.data);
//   //       if(snapshot.hasData){
//   //         // File? filePathName = File("http://192.168.0.106/Notes/" + snapshot.data[0]['profileImage']);
//   //         return ListView(
//   //           padding: EdgeInsets.zero,
//   //           children: [
//   //             UserAccountsDrawerHeader(
//   //               accountEmail: Text(snapshot.data[0]['userEmail'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
//   //               accountName: Text(snapshot.data[0]['userFirstName'] + " " + snapshot.data[0]['userLastName'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
//   //               currentAccountPicture: Container(
//   //                 width: 30.0,
//   //                 height: 30.0,
//   //                 child: CircleAvatar(
//   //                   backgroundImage: snapshot.data[0]['profileImage'] != "" ? NetworkImage("http://192.168.0.106/Notes/" + snapshot.data[0]['profileImage']) : Image.asset('assets/profile.png').image,
//   //                 ),
//   //               ),
//   //               decoration: const BoxDecoration(color: Color(0xff4c505b)),
//   //             ),
//   //             Row(
//   //               mainAxisAlignment: MainAxisAlignment.spaceAround,
//   //               children: [
//   //                 ElevatedButton(
//   //                   onPressed: (){
//   //                     getImage();
//   //                   }, 
//   //                   child: const Text("Choose Image")
//   //                 ),
//   //                 ElevatedButton(
//   //                   onPressed: () async {
//   //                     // print(id);
//   //                     // var result = await AuthService.getUserDataById(id);
//   //                     // var data = jsonEncode(result);
//   //                     // var userId = jsonDecode(data)['uniqueId'];
//   //                     var response = await AuthService.uploadProfile(id, ImageName, ImageData);
//   //                     if(response == "Done"){
//   //                       print("Done");
//   //                       Fluttertoast.showToast(msg: "Inserted Image");
//   //                     }else{
//   //                       Fluttertoast.showToast(msg: "Not Inserted Image");
//   //                     }
//   //                   }, 
//   //                   child: const Text("Upload Imge")
//   //                 ),
//   //               ],
//   //             ),
//   //             ListTile(
//   //               title: const Text(
//   //                 'Settings',
//   //                 style: TextStyle(color: Colors.white),
//   //               ),
//   //               onTap: () {},
//   //             ),
//   //             ListTile(
//   //               title: const Text(
//   //                 'Account',
//   //                 style: TextStyle(color: Colors.white),
//   //               ),
//   //               onTap: () {},
//   //             ),
//   //             ListTile(
//   //               title: const Text(
//   //                 'Statistics',
//   //                 style: TextStyle(color: Colors.white, fontSize: 18),
//   //               ),
//   //               onTap: () {
//   //                 Navigator.push(context, CupertinoPageRoute(builder: (context){
//   //                   return Statistic(id: id);
//   //                 }));
//   //               },
//   //             ),
//   //             ListTile(
//   //               title: const Text(
//   //                 'Logout',
//   //                 style: TextStyle(color: Colors.red),
//   //               ),
//   //               onTap: () async {
//   //                 var obj = await SharedPreferences.getInstance();
//   //                 obj.setBool("Login", false);
//   //                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//   //                   return const Login();
//   //                 }));
//   //               },
//   //             ),
//   //           ],
//   //         );
//   //       }else{
//   //         return Text("No data");
//   //       }
//   //     },
//   //   );
//   // }
// }
