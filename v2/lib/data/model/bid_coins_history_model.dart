class BidcoinsHistoryModel {
  List<Balances>? balances;
  int? currbalance;

  BidcoinsHistoryModel({this.balances, this.currbalance});

  BidcoinsHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['balances'] != null) {
      balances = <Balances>[];
      json['balances'].forEach((v) {
        balances!.add(new Balances.fromJson(v));
      });
    }
    currbalance = json['currbalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.balances != null) {
      data['balances'] = this.balances!.map((v) => v.toJson()).toList();
    }
    data['currbalance'] = this.currbalance;
    return data;
  }
}

class Balances {
  int? id;
  int? userId;
  int? debit;
  int? credit;
  String? trx;
  int? trxId;
  String? notes;
  String? createdAt;
  String? updatedAt;
  int? open;
  int? close;

  Balances({this.id, this.userId, this.debit, this.credit, this.trx, this.trxId, this.notes, this.createdAt, this.updatedAt, this.open, this.close});

  Balances.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    debit = json['debit'];
    credit = json['credit'];
    trx = json['trx'];
    trxId = json['trx_id'] ?? 0;
    notes = json['notes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    open = json['open'];
    close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['debit'] = this.debit;
    data['credit'] = this.credit;
    data['trx'] = this.trx;
    data['trx_id'] = this.trxId;
    data['notes'] = this.notes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['open'] = this.open;
    data['close'] = this.close;
    return data;
  }
}
