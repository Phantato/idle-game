part of clicker;

class _Increaser {
  static final _increaser = _Increaser._internal();
  final _harvestTabel = <String, _BigInt>{};

  factory _Increaser() {
    return _increaser;
  }
  _Increaser._internal() {
    Clicker.names.forEach((name) {
      _harvestTabel[name] = _BigInt.zero;
    });
  }

  void regist(String name, int index, _BigInt value) {
    _harvestTabel[name] += _BigInt.from(BigInt.from(pow(10, index))) * value;
  }

  void harvest() {
    Clicker.names.forEach(
        (name) => Clicker.records.increaseBy(name, _harvestTabel[name]));
  }
}
