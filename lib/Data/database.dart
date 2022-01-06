import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soultec/Data/toast.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({required this.uid});

  List<String> cars = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  final CollectionReference userCollection  = FirebaseFirestore.instance.collection('users');
  //final CollectionReference carCollection =  FirebaseFirestore.instance.collection('users/'+this.uid.toString() +'/cars');
  // final CollectionReference carCollection = FirebaseFirestore.instance.collection('users').doc("uid").collection("cars");

  // Future readcar(
  //     String number
  //     )async{
  //   final carCollection = FirebaseFirestore.instance.collection('users/'+this.uid.toString() +'/cars');
  //   carCollection.get().then((value) {
  //     print(value.docs.forEach((element) ));
  //   });
  //
  //   return null;
  // }

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


  Future updateCarData(
      String number,
      ) async{
    print('carnumber update');
    return await userCollection.doc(uid).collection("cars").add({
      "car_number":number
    });
  }

  // await userCollection.doc(uid).collection("cars").get().then((querySnapshot){
  // querySnapshot.docs.forEach((element) {
  // print(element.data());
  // });
  // } )

  Future readCarData(
      String number,
      )async{


    print(userCollection.doc(uid).collection("cars").get().then((value) {
      value.docs.forEach((element) {
        print(element.data().values.toList());
      });
    }));

    return await userCollection.doc(uid).collection("cars").get().then((querySnapshot){
      querySnapshot.docs;
    } );
  }

  Stream<DocumentSnapshot> get getuser {
    return userCollection.doc(uid).snapshots();
  }

}