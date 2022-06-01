import 'finance.dart';

class ListModel<T> {
  List<T> list;
  int? pageSize;
  int? pageIndex;
  int? total;
  ListModel(this.list, this.pageIndex, this.pageSize, this.total);

  factory ListModel.fromJson(Map<String, dynamic> json) {
    dynamic list;

    if (T == Finance)
      list = ((json["list"])
          .map<Finance>((item) => Finance.fromJson(item))
          .toList());
    else if (T == FinanceBook)
      list = ((json["list"])
          .map<FinanceBook>((item) => FinanceBook.fromJson(item))
          .toList());
    else
      list = json["list"];

    return ListModel(list, json["pageIndex"], json["pageSize"], json["total"]);
  }

  Map<String, dynamic> toJson() => {
        'list': list,
        'pageSize': pageSize,
        'pageIndex': pageIndex,
        'total': total,
      };
}
