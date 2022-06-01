// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Finance _$FinanceFromJson(Map<String, dynamic> json) {
  return Finance(
    json['id'] as String?,
    json['goods'] as String,
    (json['amount'] as num).toDouble(),
    json['bookId'] as String?,
    json['paymentType'] as String?,
    json['tradingTime'] as String?,
    json['tradingParty'] as String?,
    json['tradingType'] as String?,
    json['tradingOrder'] as String?,
    json['remark'] as String?,
    json['userId'] as String?,
    (json['tags'] as List<dynamic>?)
        ?.map((e) => FinanceTag.fromJson(e as Map<String, dynamic>))
        .toList(),
  )..merchantOrder = json['merchantOrder'] as String?;
}

Map<String, dynamic> _$FinanceToJson(Finance instance) => <String, dynamic>{
      'id': instance.id,
      'goods': instance.goods,
      'amount': instance.amount,
      'bookId': instance.bookId,
      'paymentType': instance.paymentType,
      'tradingType': instance.tradingType,
      'tradingTime': instance.tradingTime,
      'tradingParty': instance.tradingParty,
      'tradingOrder': instance.tradingOrder,
      'merchantOrder': instance.merchantOrder,
      'userId': instance.userId,
      'remark': instance.remark,
      'tags': instance.tags,
    };

FinanceBook _$FinanceBookFromJson(Map<String, dynamic> json) {
  return FinanceBook(
    json['id'] as String?,
    json['name'] as String,
    json['image'] as String?,
    json['isArchive'] as bool?,
  );
}

Map<String, dynamic> _$FinanceBookToJson(FinanceBook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'isArchive': instance.isArchive,
    };

FinanceTag _$FinanceTagFromJson(Map<String, dynamic> json) {
  return FinanceTag(
    json['id'] as String?,
    json['name'] as String,
    json['type'] as String,
    json['icon'] as String?,
  )..order = json['order'] as int?;
}

Map<String, dynamic> _$FinanceTagToJson(FinanceTag instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'icon': instance.icon,
      'order': instance.order,
    };
