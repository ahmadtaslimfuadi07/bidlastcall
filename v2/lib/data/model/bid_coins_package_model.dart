class BidcoinsPackageModel {
  int? id;
  String? name;
  int? price;
  int? bidcoin;
  int? normalbidcoin;
  int? bonusbidcoin;
  String? description;
  int? status;

  BidcoinsPackageModel({
    this.id,
    this.name,
    this.price,
    this.bidcoin,
    this.normalbidcoin,
    this.bonusbidcoin,
    this.description,
    this.status,
  });

  BidcoinsPackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    bidcoin = json['bidcoin'];
    normalbidcoin = json['normalbidcoin'];
    bonusbidcoin = json['bonusbidcoin'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['bidcoin'] = this.bidcoin;
    data['normalbidcoin'] = this.normalbidcoin;
    data['bonusbidcoin'] = this.bonusbidcoin;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}
