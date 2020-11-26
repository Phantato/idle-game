class ResourceRecords {
  static var apple = _BigInt(0);
  static var gold = _BigInt(0);
}

class MinerRecords {
  static var apple = _BigInt(0);
  static var gold = _BigInt(0);
}

class _BigInt {
  int value;

  _BigInt(this.value);
  
  String toString() => value.toString();

  @override  
  _BigInt operator+(int i) {
    value += i;
    return this;
  }
}

