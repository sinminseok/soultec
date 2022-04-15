class Receipt_object {
  final int? id;
  final String? dateTime;//
  final String? pumpId; //
  final int? branchId; //
  final String? branchName;
  final String? branchCeo; // 지점 관리자
  final String? branchAddress; // 지점 주소
  final String? branchTEL; // 지점 전회번호
  final String? approvalNumber; //
  final int? pumpNumber; // 주입기 번호
  final String? product; //승인번호
  final int? amount; // 주입량
  final String? username; //기사번호
  final String? nickname;
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
