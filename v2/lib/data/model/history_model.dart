import 'package:eClassify/data/model/item/item_detail_model.dart';

class HistoryModel {
  List<ItemHistoryModel>? all;
  List<ItemHistoryModel>? open;
  List<ItemHistoryModel>? closed;

  HistoryModel({this.all, this.open, this.closed});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['all'] != null) {
      all = <ItemHistoryModel>[];
      json['all'].forEach((v) {
        all!.add(new ItemHistoryModel.fromJson(v));
      });
    }
    if (json['open'] != null) {
      open = <ItemHistoryModel>[];
      json['open'].forEach((v) {
        open!.add(new ItemHistoryModel.fromJson(v));
      });
    }
    if (json['closed'] != null) {
      closed = <ItemHistoryModel>[];
      json['closed'].forEach((v) {
        closed!.add(new ItemHistoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.all != null) {
      data['all'] = this.all!.map((v) => v.toJson()).toList();
    }
    if (this.open != null) {
      data['open'] = this.open!.map((v) => v.toJson()).toList();
    }
    if (this.closed != null) {
      data['closed'] = this.closed!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemHistoryModel {
  int? id;
  String? name;
  String? slug;
  String? description;
  int? price;
  String? startdt;
  String? enddt;
  int? minbid;
  int? startbid;
  String? bidstatus;
  int? winnerbidid;
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

  int? winnerBidPrice;
  bool? haswinner;
  bool? hasclosed;
  User? user;
  Category? category;
  List<GalleryImages>? galleryImages;
  ItemPayment? itemPayment;

  ItemHistoryModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.price,
    this.startdt,
    this.enddt,
    this.minbid,
    this.startbid,
    this.bidstatus,
    this.winnerbidid,
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
    this.winnerBidPrice,
    this.haswinner,
    this.hasclosed,
    this.user,
    this.category,
    this.galleryImages,
    this.itemPayment,
  });

  ItemHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    price = json['price'];

    startdt = json['startdt'];
    enddt = json['enddt'];
    minbid = json['minbid'];
    startbid = json['startbid'];
    bidstatus = json['bidstatus'];
    winnerbidid = json['winnerbidid'];
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

    winnerBidPrice = json['winner_bid_price'];
    haswinner = json['haswinner'];
    hasclosed = json['hasclosed'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    category = json['category'] != null ? new Category.fromJson(json['category']) : null;
    if (json['gallery_images'] != null) {
      galleryImages = <GalleryImages>[];
      json['gallery_images'].forEach((v) {
        galleryImages!.add(new GalleryImages.fromJson(v));
      });
    }
    itemPayment = json['item_payment'] != null ? new ItemPayment.fromJson(json['item_payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['price'] = this.price;

    data['startdt'] = this.startdt;
    data['enddt'] = this.enddt;
    data['minbid'] = this.minbid;
    data['startbid'] = this.startbid;
    data['bidstatus'] = this.bidstatus;
    data['winnerbidid'] = this.winnerbidid;
    data['image'] = this.image;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['contact'] = this.contact;
    data['show_only_to_premium'] = this.showOnlyToPremium;
    data['status'] = this.status;
    data['rejected_reason'] = this.rejectedReason;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['all_category_ids'] = this.allCategoryIds;
    data['clicks'] = this.clicks;
    data['cost'] = this.cost;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['winner_bid_price'] = this.winnerBidPrice;
    data['haswinner'] = this.haswinner;
    data['hasclosed'] = this.hasclosed;
    if (this.itemPayment != null) {
      data['item_payment'] = this.itemPayment!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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

class User {
  int? id;
  String? name;
  String? email;
  String? mobile;
  Null? profile;
  String? createdAt;

  User({this.id, this.name, this.email, this.mobile, this.profile, this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    profile = json['profile'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['profile'] = this.profile;
    data['created_at'] = this.createdAt;
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
