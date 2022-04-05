
class Car{
  int? id;
  String? carNumber;
  String? yesrs;
  String? carType;
  int? registrationNumber;

  Car({this.id,this.carNumber,this.yesrs,this.carType,this.registrationNumber});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      carNumber: json['carNumber'],
      yesrs: json['yesrs'],
      carType: json['carType'],
      registrationNumber: json['registrationNumber'],
    );
  }

}