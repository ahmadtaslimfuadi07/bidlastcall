class ItemDetailModel {
  int? id;
  String? name;
  String? slug;
  String? description;
  int? price;
  String? startdt;
  String? enddt;
  int? minbid;
  int? startbid;
  int? closeprice;
  int? shippingfee;
  String? bidstatus;
  int? servicefee;
  int? winnerbidid;
  int? buyerbillprice;
  int? totalcloseprice;
  String? image;
  double? latitude;
  double? longitude;
  String? address;
  String? contact;
  int? showOnlyToPremium;
  String? status;
  String? rejectedReason;
  String? city;
  String? state;
  String? country;
  int? userId;
  int? categoryId;
  String? allCategoryIds;
  int? clicks;
  int? cost;
  String? createdAt;
  String? updatedAt;
  String? expirePaymentAt;
  List<Bids>? bids;
  User? user;
  ItemBid? itemBid;
  ItemPayment? itemPayment;
  Category? category;
  List<GalleryImages>? galleryImages;
  OngkirOpts? ongkirOpts;

  ItemDetailModel(
      {this.id,
      this.name,
      this.slug,
      this.description,
      this.price,
      this.startdt,
      this.enddt,
      this.minbid,
      this.startbid,
      this.closeprice,
      this.shippingfee,
      this.bidstatus,
      this.servicefee,
      this.winnerbidid,
      this.buyerbillprice,
      this.totalcloseprice,
      this.image,
      this.latitude,
      this.longitude,
      this.address,
      this.contact,
      this.showOnlyToPremium,
      this.status,
      this.rejectedReason,
      this.city,
      this.state,
      this.country,
      this.userId,
      this.categoryId,
      this.allCategoryIds,
      this.clicks,
      this.cost,
      this.createdAt,
      this.updatedAt,
      this.bids,
      this.user,
      this.itemBid,
      this.itemPayment,
      this.category,
      this.ongkirOpts,
      this.expirePaymentAt,
      this.galleryImages});

  ItemDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    price = json['price'];
    startdt = json['startdt'];
    enddt = json['enddt'];
    minbid = json['minbid'];
    startbid = json['startbid'];
    closeprice = json['closeprice'];
    shippingfee = json['shippingfee'];
    bidstatus = json['bidstatus'];
    servicefee = json['servicefee'];
    winnerbidid = json['winnerbidid'];
    buyerbillprice = json['buyerbillprice'];
    totalcloseprice = json['totalcloseprice'];
    image = json['image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    contact = json['contact'];
    showOnlyToPremium = json['show_only_to_premium'];
    status = json['status'];
    rejectedReason = json['rejected_reason'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    allCategoryIds = json['all_category_ids'];
    clicks = json['clicks'];
    cost = json['cost'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    expirePaymentAt = json['expire_payment_at'];
    if (json['bids'] != null) {
      bids = <Bids>[];
      json['bids'].forEach((v) {
        bids!.add(new Bids.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    itemBid = json['item_bid'] != null ? new ItemBid.fromJson(json['item_bid']) : null;
    itemPayment = json['item_payment'] != null ? new ItemPayment.fromJson(json['item_payment']) : null;
    category = json['category'] != null ? new Category.fromJson(json['category']) : null;
    if (json['gallery_images'] != null) {
      galleryImages = <GalleryImages>[];
      json['gallery_images'].forEach((v) {
        galleryImages!.add(new GalleryImages.fromJson(v));
      });
    }
    ongkirOpts = json['ongkirOpts'] != null ? new OngkirOpts.fromJson(json['ongkirOpts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expire_payment_at'] = this.expirePaymentAt;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['price'] = this.price;
    data['startdt'] = this.startdt;
    data['enddt'] = this.enddt;
    data['minbid'] = this.minbid;
    data['startbid'] = this.startbid;
    data['bidstatus'] = this.bidstatus;
    data['buyerbillprice'] = this.buyerbillprice;
    data['winnerbidid'] = this.winnerbidid;
    data['image'] = this.image;
    data['servicefee'] = this.servicefee;
    data['totalcloseprice'] = this.totalcloseprice;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['contact'] = this.contact;
    data['show_only_to_premium'] = this.showOnlyToPremium;
    data['status'] = this.status;
    data['shippingfee'] = this.shippingfee;
    data['rejected_reason'] = this.rejectedReason;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['all_category_ids'] = this.allCategoryIds;
    data['clicks'] = this.clicks;
    data['closeprice'] = this.closeprice;
    data['cost'] = this.cost;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.bids != null) {
      data['bids'] = this.bids!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.itemBid != null) {
      data['item_bid'] = this.itemBid!.toJson();
    }
    if (this.itemPayment != null) {
      data['item_payment'] = this.itemPayment!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.galleryImages != null) {
      data['gallery_images'] = this.galleryImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bids {
  int? id;
  int? userId;
  int? itemId;
  int? bidAmount;
  int? bidPrice;
  String? tipe;
  String? createdAt;
  String? updatedAt;
  User? user;

  Bids({this.id, this.userId, this.itemId, this.bidAmount, this.bidPrice, this.tipe, this.createdAt, this.updatedAt, this.user});

  Bids.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    itemId = json['item_id'];
    bidAmount = json['bid_amount'];
    bidPrice = json['bid_price'];
    tipe = json['tipe'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['item_id'] = this.itemId;
    data['bid_amount'] = this.bidAmount;
    data['bid_price'] = this.bidPrice;
    data['tipe'] = this.tipe;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? buyerUname;
  String? sellerUname;

  User({this.id, this.buyerUname, this.sellerUname});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyerUname = json['buyer_uname'];
    sellerUname = json['seller_uname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['buyer_uname'] = this.buyerUname;
    data['seller_uname'] = this.sellerUname;
    return data;
  }
}

class ItemBid {
  int? id;
  int? userId;
  int? bidAmount;
  int? bidPrice;
  String? tipe;
  String? createdAt;
  String? winnerUname;
  String? winnerAddress;

  ItemBid({this.id, this.userId, this.bidAmount, this.bidPrice, this.tipe, this.createdAt, this.winnerUname, this.winnerAddress});

  ItemBid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bidAmount = json['bid_amount'];
    bidPrice = json['bid_price'];
    tipe = json['tipe'];
    createdAt = json['created_at'];
    winnerUname = json['winner_uname'];
    winnerAddress = json['winner_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['bid_amount'] = this.bidAmount;
    data['bid_price'] = this.bidPrice;
    data['tipe'] = this.tipe;
    data['created_at'] = this.createdAt;
    data['winner_uname'] = this.winnerUname;
    data['winner_address'] = this.winnerAddress;
    return data;
  }
}

class ItemPayment {
  int? id;
  int? itemId;
  int? itemBidId;
  int? pgId;
  String? paymentdate;
  int? amount;
  int? istransfered;
  String? accnum;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? shippingservice;
  String? estimatePaymentAt;
  String? imgtransfer;

  ItemPayment({
    this.id,
    this.itemId,
    this.itemBidId,
    this.pgId,
    this.paymentdate,
    this.amount,
    this.istransfered,
    this.accnum,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.shippingservice,
    this.estimatePaymentAt,
    this.imgtransfer,
  });

  ItemPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    itemBidId = json['item_bid_id'];
    pgId = json['pg_id'];
    paymentdate = json['paymentdate'];
    amount = json['amount'];
    istransfered = json['istransfered'];
    accnum = json['accnum'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    shippingservice = json['shippingservice'];
    estimatePaymentAt = json['estimate_payment_at'];
    imgtransfer = json['imgtransfer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['istransfered'] = this.istransfered;
    data['imgtransfer'] = this.imgtransfer;
    data['item_id'] = this.itemId;
    data['item_bid_id'] = this.itemBidId;
    data['pg_id'] = this.pgId;
    data['paymentdate'] = this.paymentdate;
    data['amount'] = this.amount;
    data['accnum'] = this.accnum;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['shippingservice'] = this.shippingservice;
    data['estimate_payment_at'] = this.estimatePaymentAt;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? image;
  String? translatedName;

  Category({this.id, this.name, this.image, this.translatedName});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    translatedName = json['translated_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['translated_name'] = this.translatedName;
    return data;
  }
}

class GalleryImages {
  int? id;
  String? image;
  int? itemId;

  GalleryImages({this.id, this.image, this.itemId});

  GalleryImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    itemId = json['item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['item_id'] = this.itemId;
    return data;
  }
}

class OngkirOpts {
  List<KurirModel>? jNE;
  List<KurirModel>? pOS;
  List<KurirModel>? tIKI;

  OngkirOpts({this.jNE, this.pOS, this.tIKI});

  OngkirOpts.fromJson(Map<String, dynamic> json) {
    if (json['JNE'] != null) {
      jNE = <KurirModel>[];
      json['JNE'].forEach((v) {
        jNE!.add(new KurirModel.fromJson(v));
      });
    }
    if (json['POS'] != null) {
      pOS = <KurirModel>[];
      json['POS'].forEach((v) {
        pOS!.add(new KurirModel.fromJson(v));
      });
    }
    if (json['TIKI'] != null) {
      tIKI = <KurirModel>[];
      json['TIKI'].forEach((v) {
        tIKI!.add(new KurirModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jNE != null) {
      data['JNE'] = this.jNE!.map((v) => v.toJson()).toList();
    }
    if (this.pOS != null) {
      data['POS'] = this.pOS!.map((v) => v.toJson()).toList();
    }
    if (this.tIKI != null) {
      data['TIKI'] = this.tIKI!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KurirModel {
  String? courier;
  String? service;
  String? serviceid;
  int? cost;
  String? etd;

  KurirModel({this.courier, this.service, this.serviceid, this.cost, this.etd});

  KurirModel.fromJson(Map<String, dynamic> json) {
    courier = json['courier'];
    service = json['service'];
    serviceid = json['serviceid'];
    cost = json['cost'];
    etd = json['etd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courier'] = this.courier;
    data['service'] = this.service;
    data['serviceid'] = this.serviceid;
    data['cost'] = this.cost;
    data['etd'] = this.etd;
    return data;
  }
}
