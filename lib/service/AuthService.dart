import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes/const/AppConstant.dart';
import 'package:notes/models/User.dart';

class AuthService{
  static Future<String> registerUser(User user) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstant.API}/Notes/Login/register.php"),
        body: user.toJson(),
      );
      if(jsonDecode(response.body) == "Success"){
        return "Registered";
      }else{ 
        return "Falied";
      }
    } catch (e) {
      print(e);
      return "error";
    }
  } 

  static Future<Object> loginUser(User user) async {
    try {
      print("Hit");
      print(user.userEmail);
      print(user.userPassword);
      var response = await http.post(
        Uri.parse("${AppConstant.API}/Notes/Login/login.php"),
        body: {
          "userEmail": user.userEmail,
          "userPassword": user.userPassword
        },
        // headers: {'Content-Type': 'application/json; charset=UTF-8'}
      );
      print("Done");
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {"status": "Error"};
    }
  }

  static Future<Object?> getUserDataById(id) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstant.API}/Notes/getUserDataById.php"),
        body: {
          "userId": id
        },
        // headers: {'Content-Type': 'application/json; charset=UTF-8'}
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Object?> getNotesById(id) async {
     try {

      print(id);
      var response = await http.post(
        Uri.parse("${AppConstant.API}/Notes/displayNotes.php"),
        body: {
          "userId": id
        },
        // headers: {'Content-Type': 'application/json; charset=UTF-8'}
      );

  print("Hello");
      print(jsonDecode(response.body));
      if(jsonDecode(response.body) != null){
        return jsonDecode(response.body);
      }else{
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String> deleteNoteById(id) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstant.API}/Notes/deleteNoteById.php"),
        body: {
          "noteId": id
        },
        // headers: {'Content-Type': 'application/json; charset=UTF-8'}
      );

      if(jsonDecode(response.body) == "Deleted"){
        return jsonDecode(response.body);
      }else{
        return "Failed";
      }
    } catch (e) {
      print(e);
      return "Error";
    }
  }

  static Future<Object?> addNote(noteTitle, noteDescription, id) async {
    try {
      var response = await http.post(Uri.parse("${AppConstant.API}/Notes/createNote.php"),
        body: {
          "noteTitle": noteTitle,
          "noteDescription": noteDescription,
          "userId": id,
        }
      );

      if(jsonDecode(response.body) == "Success"){
        return jsonDecode(response.body);
      }else{
        return "Failed";
      }

    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Object?> updateNote(noteTitle, noteDescription, userId, noteId) async {
    try {
      var response = await http.post(Uri.parse("${AppConstant.API}/Notes/updateNoteById.php"),
        body: {
          "noteTitle": noteTitle,
          "noteDescription": noteDescription,
          "userId": userId,
          "noteId": noteId
        }
      );

      if(jsonDecode(response.body) == "Success"){
        return jsonDecode(response.body);
      }else{
        return "Failed";
      }

    } catch (e) {
      print(e);
      return null;
    }
  }

  // static Future<Object?> getSingleNoteById(noteId) async {
  //   try {
  //     var response = await http.post(Uri.parse("http://192.168.0.106/Notes/getSingleNoteById.php"),
  //       body: {
  //         "noteId": noteId
  //       }
  //     );

  //     // print(response.body);
  //     // print(jsonDecode(response.body));
  //     print(response.body.runtimeType);
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  // static Future<String> uploadProfile(userId, imageFile, imageData) async {
  //   try {
  //     print("Inside Auth Service");
  //     print(userId.runtimeType);
  //     // print(imagePath.runtimeType);
  //     print(imageFile.runtimeType);
  //     print(imageData.runtimeType);
  //     var response = await http.post(Uri.parse("http://192.168.0.106/Notes/uploadProfile.php"),
  //       body: {
  //         "userId": userId,
  //         "fileName": imageFile,
  //         "fileData": imageData
  //       }
  //     );

  //     print(response);
  //     print(response.body);
  //     print(jsonDecode(response.body));

  //     if(jsonEncode(response.body) == "Success"){
  //       return "Done";
  //     }else{
  //       return "Not Done";
  //     }
  //   } catch (e) {
  //     print(e);
  //     return e.toString();
  //   }
  // }

  // static Future<Object?> getImageFromDb(id) async {
  //   try {
  //     print(id);
  //     var response = await http.post(Uri.parse("http://192.168.0.106/Notes/getImageFromDb.php"), 
  //       body: {
  //         "userId": id
  //       } 
  //     );

  //     print(response.body);
  //     print(response.body.runtimeType);

  //     return jsonDecode(response.body);
  //   // return response.body;
  //   } catch (e) {
  //     print(e);
  //     return e.toString();
  //   }
  // }

  // static Future<String?> getStatisticData(userId) async {
  //   try {
  //     var response = await http.post(Uri.parse("http://192.168.0.106/Notes/getStatisticDataByUserId.php"),body: {
  //       "userId": userId
  //     });

  //     print(response.body);
  //     print(response.body.runtimeType);

  //     return response.body;
  //   } catch (e) {
  //     print(e.toString());
  //     return e.toString();
  //   }
  // }
}