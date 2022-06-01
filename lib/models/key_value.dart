class KeyValue {
  String key;
  dynamic value;

  KeyValue(this.key, this.value);

  @override
  toString() {
    return "$key:$value";
  }
}
