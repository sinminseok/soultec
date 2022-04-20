class Receipt_object {
  final int? id; //영수증 id
  final String? dateTime;// 영수증 발행 시간
  final String? pumpId; //  주유기 id (ble에서 받아온 시리얼 번호이고 서버에서 어디 지점인지 판별하는 변수이다)
  final int? branchId; // 주유 지점 id
  final String? branchName; // 지점 이름
  final String? branchCeo; // 지점 관리자 이름
  final String? branchAddress; // 지점 주소
  final String? branchTEL; // 지점 전회번호
  final String? approvalNumber; // 승인 번호 (추후 어떻게 생성할지 논의 )
  final int? pumpNumber; // 주입기 번호
  final String? product; // 요소수 , 기름 등
  final int? amount; // 주입량
  final String? username; //기사번호
  final String? nickname; //
  final String? carNumber; // 자동차 번호

  Receipt_object({
    this.id,
    this.dateTime,
    this.pumpId,
    this.branchId,
    this.branchName,
    this.branchCeo,
    this.branchAddress,
    this.branchTEL,
    this.approvalNumber,
    this.pumpNumber,
    this.product,
    this.amount,
    this.username,
    this.nickname,
    this.carNumber,
  });

  factory Receipt_object.fromJson(Map<String, dynamic> json) {
    return Receipt_object(
      id: json['id'],
      dateTime: json['datetime'],
      pumpId: json['pumpId'],
      branchId: json['branchId'],
      branchName:json['branchName'],
      branchCeo: json['branchCeo'],
      branchAddress: json['branchAddress'],
      branchTEL: json['branchTEL'],
      approvalNumber: json['approvalNumber'],
      pumpNumber: json['pumpNumber'],
      product: json['product'],
      amount: json['amount'],
      username: json['username'],
      nickname: json['nickname'],
      carNumber: json['carNumber'],
    );
  }
}
