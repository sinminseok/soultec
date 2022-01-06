import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection  = FirebaseFirestore.instance.collection('users');

  Future updateUserData(
      String email,
      String password,
      String name,
      ) async{
    print('updateUser');
    print(name);
    return await userCollection.doc(uid).set({
      'email':email,
      'password':password,
      'name':name,
    });
  }

}

class Carnumbers{
  final String? uid;
  Carnumbers({required this.uid});

  final CollectionReference carCollection = FirebaseFirestore.instance.collection('carnumber');

  Future updateCarnumber(
      String car_number,
      )async{
    print('update carnumber');
    return await carCollection.doc(uid).set({
      'car_number': car_number
    });
  }

}