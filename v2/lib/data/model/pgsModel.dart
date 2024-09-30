class PGSModel {
  int? id;
  String? method;
  String? bank;
  String? accname;
  String? accnum;
  int? isactive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  PGSModel({this.id, this.method, this.bank, this.accname, this.accnum, this.isactive, this.createdAt, this.updatedAt, this.deletedAt});

  PGSModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    method = json['method'];
    bank = json['bank'];
    accname = json['accname'];
    accnum = json['accnum'];
    isactive = json['isactive'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['method'] = this.method;
    data['bank'] = this.bank;
    data['accname'] = this.accname;
    data['accnum'] = this.accnum;
    data['isactive'] = this.isactive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
