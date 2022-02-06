

class Receipt_object{
  final String? Point;
  final String? representative;
  final String? address;
  final DateTime? date;
  final int? Litter;
  final String? car_number;
  final String? bus_driver;
  final String? total_litter;

  Receipt_object(
      {this.Point,
      this.representative,
      this.address,
      this.date,
      this.Litter,
      this.car_number,
      this.bus_driver,
      this.total_litter});

  factory Receipt_object.fromJson(Map<String, dynamic> json) {
    return Receipt_object(
      Point: json['Point'],
      representative: json['representative'],
      address: json['address'],
      date: json['date'],
      Litter: json['Litter'],
      car_number: json['car_number'],
      bus_driver: json['bus_driver'],
      total_litter: json['total_litter'],
    );
  }
}