import 'package:eClassify/data/model/category_model.dart';
import 'package:eClassify/data/model/item/item_detail_model.dart';

import '../CustomField/custom_field_model.dart';

class ItemModel {
  int? id;
  String? name;
  String? slug;
  String? description;
  int? price;
  int? minbid;
  int? startbid;
  int? curentbid;
  int? shippingfee;
  String? image;
  dynamic watermarkimage;
  double? _latitude;
  double? _longitude;
  String? address;
  String? goodscondition;
  String? contact;
  int? totalLikes;
  int? views;
  String? type;
  String? status;
  bool? active;
  String? videoLink;
  User? user;
  List<GalleryImages>? galleryImages;
  List<ItemOffers>? itemOffers;
  CategoryModel? category;
  ItemBid? itemBid;
  List<CustomFieldModel>? customFields;
  bool? isLike;
  bool? isFeature;
  String? created;
  String? itemType;
  int? userId;
  int? categoryId;
  bool? isAlreadyOffered;
  bool? isAlreadyReported;
  String? allCategoryIds;
  String? rejectedReason;
  int? areaId;
  String? area;
  String? city;
  String? state;
  String? country;
  String? startdt;
  String? enddt;
  String? bidstatus;
  String? expirePaymentAt;
  int? myBidPrice;
  int? winnerBidPrice;
  int? closeprice;
  bool? iswinner;
  ItemPayment? itemPayment;

  double? get latitude => _latitude;

  set latitude(dynamic value) {
    if (value is int) {
      _latitude = value.toDouble();
    } else if (value is double) {
      _latitude = value;
    } else {
      _latitude = null;
    }
  }

  double? get longitude => _longitude;

  set longitude(dynamic value) {
    if (value is int) {
      _longitude = value.toDouble();
    } else if (value is double) {
      _longitude = value;
    } else {
      _longitude = null;
    }
  }

  /* double? get price => _price is int ? (_price as int).toDouble() : _price;
  set price(dynamic value) {
    if (value is int) {
      _price = value.toDouble();
    } else if (value is double) {
      _price = double.parse(value.toStringAsFixed(2));
    } else {
      _price = null;
    }
  }*/

  ItemModel({
    this.id,
    this.name,
    this.slug,
    this.category,
    this.description,
    this.price,
    this.startbid,
    this.curentbid,
    this.shippingfee,
    this.minbid,
    this.image,
    this.watermarkimage,
    dynamic latitude,
    dynamic longitude,
    this.address,
    this.goodscondition,
    this.contact,
    this.type,
    this.status,
    this.active,
    this.totalLikes,
    this.views,
    this.videoLink,
    this.user,
    this.galleryImages,
    this.itemOffers,
    this.customFields,
    this.isLike,
    this.isFeature,
    this.created,
    this.itemType,
    this.userId,
    this.categoryId,
    this.isAlreadyOffered,
    this.isAlreadyReported,
    this.rejectedReason,
    this.allCategoryIds,
    this.areaId,
    this.area,
    this.city,
    this.state,
    this.country,
    this.startdt,
    this.enddt,
    this.bidstatus,
    this.expirePaymentAt,
    this.itemBid,
    this.iswinner,
    this.myBidPrice,
    this.winnerBidPrice,
    this.closeprice,
    this.itemPayment,
  }) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  ItemModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    int? price,
    int? startbid,
    int? minbid,
    int? curentbid,
    int? shippingfee,
    String? image,
    dynamic watermarkimage,
    dynamic latitude,
    dynamic longitude,
    String? address,
    String? goodscondition,
    String? contact,
    int? totalLikes,
    int? views,
    String? type,
    String? status,
    bool? active,
    String? videoLink,
    User? user,
    List<GalleryImages>? galleryImages,
    List<ItemOffers>? itemOffers,
    CategoryModel? category,
    List<CustomFieldModel>? customFields,
    bool? isLike,
    bool? isFeature,
    String? created,
    String? itemType,
    int? userId,
    bool? isAlreadyOffered,
    bool? isAlreadyReported,
    String? allCategoryIds,
    int? categoryId,
    int? areaId,
    String? area,
    String? city,
    String? state,
    String? country,
    String? startdt,
    String? enddt,
    String? bidstatus,
    String? expirePaymentAt,
    ItemBid? itemBid,
    int? myBidPrice,
    int? winnerBidPrice,
    int? closeprice,
    bool? iswinner,
    ItemPayment? itemPayment,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      minbid: minbid ?? this.minbid,
      goodscondition: goodscondition ?? this.goodscondition,
      curentbid: curentbid ?? this.curentbid,
      shippingfee: shippingfee ?? this.shippingfee,
      startbid: startbid ?? this.startbid,
      image: image ?? this.image,
      watermarkimage: watermarkimage ?? this.watermarkimage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      type: type ?? this.type,
      status: status ?? this.status,
      active: active ?? this.active,
      totalLikes: totalLikes ?? this.totalLikes,
      views: views ?? this.views,
      videoLink: videoLink ?? this.videoLink,
      user: user ?? this.user,
      galleryImages: galleryImages ?? this.galleryImages,
      itemOffers: itemOffers ?? this.itemOffers,
      customFields: customFields ?? this.customFields,
      isLike: isLike ?? this.isLike,
      isFeature: isFeature ?? this.isFeature,
      created: created ?? this.created,
      itemType: itemType ?? this.itemType,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      isAlreadyOffered: isAlreadyOffered ?? this.isAlreadyOffered,
      isAlreadyReported: isAlreadyReported ?? this.isAlreadyReported,
      allCategoryIds: allCategoryIds ?? this.allCategoryIds,
      rejectedReason: rejectedReason ?? this.rejectedReason,
      areaId: areaId ?? this.areaId,
      area: area ?? this.area,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      startdt: startdt ?? this.startdt,
      enddt: enddt ?? this.enddt,
      bidstatus: bidstatus ?? this.bidstatus,
      expirePaymentAt: expirePaymentAt ?? this.expirePaymentAt,
      itemBid: itemBid ?? this.itemBid,
      myBidPrice: myBidPrice ?? this.myBidPrice,
      winnerBidPrice: winnerBidPrice ?? this.winnerBidPrice,
      closeprice: closeprice ?? this.closeprice,
      iswinner: iswinner ?? this.iswinner,
      itemPayment: itemPayment ?? this.itemPayment,
    );
  }

  ItemModel.fromJson(Map<String, dynamic> json) {
    if (json['area'] != null) {
      areaId = json['area']['id'];
      area = json['area']['name'];
    }

    if (json['minbid'] is double) {
      minbid = (json['minbid'] as double).toInt();
    } else {
      minbid = json['minbid'];
    }

    if (json['startbid'] is double) {
      startbid = (json['startbid'] as double).toInt();
    } else {
      startbid = json['startbid'];
    }

    if (json['curentbid'] is double) {
      curentbid = (json['curentbid'] as double).toInt();
    } else {
      curentbid = json['curentbid'] ?? 0;
    }

    if (json['price'] is double) {
      price = (json['price'] as double).toInt();
    } else {
      price = json['price'];
    }

    itemBid = json['item_bid'] != null ? new ItemBid.fromJson(json['item_bid']) : null;

    goodscondition = json['goodscondition'];
    myBidPrice = json['my_bid_price'];
    winnerBidPrice = json['winner_bid_price'];
    closeprice = json['closeprice'];
    iswinner = json['iswinner'];
    shippingfee = json['shippingfee'] ?? 0;

    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    category = json['category'] != null ? CategoryModel.fromJson(json['category']) : null;
    totalLikes = json['total_likes'];
    views = json['clicks'];
    description = json['description'];
    itemPayment = json['item_payment'] != null ? new ItemPayment.fromJson(json['item_payment']) : null;
    image = json['image'];
    watermarkimage = json['watermark_image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    contact = json['contact'];
    type = json['type'];
    status = json['status'];
    active = json['active'] == 0 ? false : true;
    videoLink = json['video_link'];
    isLike = json['is_liked'];
    // isFeature = json['is_feature'];
    isFeature = true;
    created = json['created_at'];
    itemType = json['item_type'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    isAlreadyOffered = json['is_already_offered'];
    isAlreadyReported = json['is_already_reported'];
    allCategoryIds = json['all_category_ids'];
    rejectedReason = json['rejected_reason'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    startdt = json['startdt'];
    enddt = json['enddt'];
    bidstatus = json['bidstatus'];
    expirePaymentAt = json['expire_payment_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['gallery_images'] != null) {
      galleryImages = <GalleryImages>[];
      json['gallery_images'].forEach((v) {
        galleryImages!.add(GalleryImages.fromJson(v));
      });
    }
    if (json['item_offers'] != null) {
      itemOffers = <ItemOffers>[];
      json['item_offers'].forEach((v) {
        itemOffers!.add(ItemOffers.fromJson(v));
      });
    }
    if (json['custom_fields'] != null) {
      customFields = <CustomFieldModel>[];
      json['custom_fields'].forEach((v) {
        customFields!.add(CustomFieldModel.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['expire_payment_at'] = expirePaymentAt;
    data['name'] = name;
    data['goodscondition'] = goodscondition;
    data['slug'] = slug;
    data['closeprice'] = closeprice;
    data['description'] = description;
    data['price'] = price;
    data['total_likes'] = totalLikes;
    data['clicks'] = views;
    data['image'] = image;
    data['watermark_image'] = watermarkimage;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['contact'] = contact;
    data['type'] = type;
    data['status'] = status;
    data['active'] = active;
    data['video_link'] = videoLink;
    data['is_liked'] = isLike;
    data['is_feature'] = isFeature;
    data['created_at'] = created;
    data['item_type'] = itemType;
    data['user_id'] = userId;
    data['category_id'] = categoryId;
    data['is_already_offered'] = isAlreadyOffered;
    data['is_already_reported'] = isAlreadyReported;
    data['all_category_ids'] = allCategoryIds;
    data['rejected_reason'] = rejectedReason;
    if (this.itemPayment != null) {
      data['item_payment'] = this.itemPayment!.toJson();
    }
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['category'] = category!.toJson();
    if (this.itemBid != null) {
      data['item_bid'] = this.itemBid!.toJson();
    }
    if (areaId != null && area != null) {
      data['area'] = {
        'id': areaId,
        'name': area,
      };
    }
    data['user'] = user!.toJson();
    if (galleryImages != null) {
      data['gallery_images'] = galleryImages!.map((v) => v.toJson()).toList();
    }
    if (itemOffers != null) {
      data['item_offers'] = itemOffers!.map((v) => v.toJson()).toList();
    }
    if (customFields != null) {
      data['custom_fields'] = customFields!.map((v) => v.toMap()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'ItemModel{id: $id, name: $name,slug:$slug, description: $description, price: $price, image: $image, watermarkimage: $watermarkimage, latitude: $latitude, longitude: $longitude, address: $address, contact: $contact, total_likes: $totalLikes,isLiked: $isLike, isFeature: $isFeature,views: $views, type: $type, status: $status, active: $active, videoLink: $videoLink, user: $user, galleryImages: $galleryImages,itemOffers:$itemOffers, category: $category, customFields: $customFields,createdAt:$created,itemType:$itemType,userId:$userId,categoryId:$categoryId,isAlreadyOffered:$isAlreadyOffered,isAlreadyReported:$isAlreadyReported,allCategoryId:$allCategoryIds,rejected_reason:$rejectedReason,area_id:$areaId,area:$area,city:$city,state:$state,country:$country}';
  }
}

class User {
  int? id;
  String? name;
  String? mobile;
  String? email;
  String? type;
  String? profile;
  String? fcmId;
  String? firebaseId;
  int? status;
  String? apiToken;
  dynamic address;
  String? createdAt;
  String? updatedAt;

  User({this.id, this.name, this.mobile, this.email, this.type, this.profile, this.fcmId, this.firebaseId, this.status, this.apiToken, this.address, this.createdAt, this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    type = json['type'];
    profile = json['profile'];
    fcmId = json['fcm_id'];
    firebaseId = json['firebase_id'];
    status = json['status'];
    apiToken = json['api_token'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['type'] = type;
    data['profile'] = profile;
    data['fcm_id'] = fcmId;
    data['firebase_id'] = firebaseId;
    data['status'] = status;
    data['api_token'] = apiToken;
    data['address'] = address;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class GalleryImages {
  int? id;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? itemId;

  GalleryImages({this.id, this.image, this.createdAt, this.updatedAt, this.itemId});

  GalleryImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemId = json['item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['item_id'] = itemId;
    return data;
  }
}

class ItemOffers {
  int? id;
  int? sellerId;
  int? buyerId;
  String? createdAt;
  String? updatedAt;
  int? amount;

  ItemOffers({this.id, this.sellerId, this.createdAt, this.updatedAt, this.buyerId, this.amount});

  ItemOffers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyerId = json['buyer_id'];
    sellerId = json['seller_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['buyer_id'] = buyerId;
    data['seller_id'] = sellerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['amount'] = amount;
    return data;
  }
}

/*class ItemCategory {
  int? id;
  int? sequence;
  String? name;
  String? image;
  int? parentCategoryId;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;

  ItemCategory(
      {this.id,
      this.sequence,
      this.name,
      this.image,
      this.parentCategoryId,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt});

  ItemCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sequence = json['sequence'];
    name = json['name'];
    image = json['image'];
    parentCategoryId = json['parent_category_id'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sequence'] = sequence;
    data['name'] = name;
    data['image'] = image;
    data['parent_category_id'] = parentCategoryId;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}*/

class ItemBid {
  int? id;
  int? userId;
  int? itemId;
  int? bidAmount;
  int? bidPrice;
  String? tipe;
  String? createdAt;
  String? updatedAt;

  ItemBid({this.id, this.userId, this.itemId, this.bidAmount, this.bidPrice, this.tipe, this.createdAt, this.updatedAt});

  ItemBid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    itemId = json['item_id'];
    bidAmount = json['bid_amount'];
    bidPrice = json['bid_price'];
    tipe = json['tipe'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}
