import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({required this.uid});

  List<String> cars = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');
  final CollectionReference carCollection =
  FirebaseFirestore.instance.collection('cars');

  Future updateUserData(String email,
      String password,
      String name,) async {
    print('updateUser');
    print(name);
    return await userCollection.doc(uid).set({
      'email': email,
      'password': password,
      'name': name,
    });
  }


  Future updateCarData(String? number,) async {
    print('carnumber update');
    return await carCollection.doc(number).set({'car_number': number});
  }


  Future readCar(String? number) async {
    var car_data =  await carCollection.doc(number).get().then((value) {
      print('sez');
      print(value.exists);
      return value.exists;
    });
    print("hi");
    print(car_data);
    return car_data;
  }



  Future readCarData(String number,) async {
    print(userCollection.doc(uid).collection("cars").get().then((value) {
      value.docs.forEach((element) {
        print(element
            .data()
            .values
            .toList());
      });
    }));

    return await userCollection
        .doc(uid)
        .collection("cars")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs;
    });
  }

  Stream<DocumentSnapshot?> get getuser {
    return userCollection.doc(uid).snapshots();
  }

}
