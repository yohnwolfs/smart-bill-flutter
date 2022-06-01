import 'package:json_annotation/json_annotation.dart';

part 'finance.g.dart';

@JsonSerializable()
class Finance {
  Finance(
      this.id,
      this.goods,
      this.amount,
      this.bookId,
      this.paymentType,
      this.tradingTime,
      this.tradingParty,
      this.tradingType,
      this.tradingOrder,
      this.remark,
      this.userId,
      this.tags);
  String? id;
  String goods;
  double amount;
  String? bookId;
  String? paymentType;
  String? tradingType;
  String? tradingTime;
  String? tradingParty;
  String? tradingOrder;
  String? merchantOrder;
  String? userId;
  String? remark;
  List<FinanceTag>? tags;

  factory Finance.fromJson(Map<String, dynamic> json) =>
      _$FinanceFromJson(json);
  Map<String, dynamic> toJson() => _$FinanceToJson(this);
}

@JsonSerializable()
class FinanceBook {
  FinanceBook(this.id, this.name, this.image, this.isArchive);
  String? id;
  String name;
  String? image;
  bool? isArchive;

  factory FinanceBook.fromJson(Map<String, dynamic> json) =>
      _$FinanceBookFromJson(json);
  Map<String, dynamic> toJson() => _$FinanceBookToJson(this);
}

@JsonSerializable()
class FinanceTag {
  FinanceTag(this.id, this.name, this.type, this.icon);
  String? id;
  String name;
  String type;
  String? icon;
  int? order;

  factory FinanceTag.fromJson(Map<String, dynamic> json) =>
      _$FinanceTagFromJson(json);
  Map<String, dynamic> toJson() => _$FinanceTagToJson(this);
}
