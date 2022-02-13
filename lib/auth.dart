// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'Data/database.dart';
// import 'Data/toast.dart';
//
//
// class AuthService{
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Stream<DatabaseService?>get userState{
//     return _auth.authStateChanges().map(userFromFirebase);
//   }
//
//   DatabaseService? userFromFirebase(Object? user){
//     return user != null ? DatabaseService(uid: user.uid) : null;
//   }
//   Future register(String email,String password,String name) async{
//     try{
//       print('register...');
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       Object? user = userCredential.user;
//       DatabaseService(uid: user!.uid).updateUserData(email,password,name);
//       return userFromFirebase(user);
//     }catch(e){
//       print(e.toString());
//       return null;
//     }
//   }
//
//   Future signOut()async{
//     try{
//       print('로그아웃 되었습니다');
//       return await _auth.signOut();
//     }catch(e){
//       showtoast("로그아웃 실패");
//     }
//   }
//
// }