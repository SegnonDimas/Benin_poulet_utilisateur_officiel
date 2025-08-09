class SellersCollection {
  static const String createdAt = 'createdAt';
  static const String deliveryInfos = 'deliveryInfos';
  static const String documentsVerified = 'documentsVerified';
  static const String fiscality = 'fiscality';
  static const String identyCardUrl = 'identyCardUrl';
  @Deprecated("à ramener dans StoreCollection")
  static const String mobileMoney = 'mobileMoney';
  static const String sectors = 'sectors';
  static const String sellerId = 'sellerId';
  static const String storeIds = 'storeIds';
  @Deprecated("à ramener dans StoreCollection")
  static const String storeInfos = 'storeInfos'; //TODO : à ramener dans Store
  static const subSectors = 'subSectors';
  static const String userId = 'userId';
}

class DeliveryInfos {
  static const String location = 'location';
  static const String locationDescription = 'locationDescription';
  static const String sellerOwnDeliver = 'sellerOwnDeliver';
}

class IdentityCardUrl {
  static const String recto = 'recto';
  static const String verso = 'verso';
}

//TODO : à ramener dans Store
@Deprecated("à ramener dans StoreCollection")
class MobileMoney {
  static const String gsmService = 'gsmService';
  static const String name = 'name';
  static const String phone = 'phone';
}

//TODO : à ramener dans Store
@Deprecated("à ramener dans StoreCollection")
class StoreInfos {
  static const String email = 'email';
  static const String name = 'name';
  static const String phone = 'phone';
}
