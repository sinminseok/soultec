

class Receipt_object{
  final String? Point; //지점
  final String? representative;
  final String? address; //주소
  final DateTime? date;//날짜
  final int? Litter; //사용리터(해당 날짜)
  final String? car_number; //자동차번호
  final String? user_number; //기사번호
  final String? total_litter; //전체 사용 리터

  Receipt_object(
      {this.Point,
      this.representative,
      this.address,
      this.date,
      this.Litter,
      this.car_number,
      this.user_number,
      this.total_litter});

  factory Receipt_object.fromJson(Map<String, dynamic> json) {
    return Receipt_object(
      Point: json['Point'],
      representative: json['representative'],
      address: json['address'],
      date: json['date'],
      Litter: json['Litter'],
      car_number: json['car_number'],
      user_number: json['bus_driver'],
      total_litter: json['total_litter'],
    );
  }
}