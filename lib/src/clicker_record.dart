part of clicker;

class _Records {
  static final _record = _Records._internal();

  final _resource = <String, ValueNotifier<_BigInt>>{};
  final _miner = <String, List<ValueNotifier<_BigInt>>>{};

  factory _Records() {
    return _record;
  }

  _Records._internal() {
    for (var name in Clicker.names) {
      _resource[name] = ValueNotifier<_BigInt>(_BigInt());
      _miner[name] = <ValueNotifier<_BigInt>>[ValueNotifier(_BigInt())];
    }
  }

  ValueNotifier<_BigInt> numberOf(String name) => _resource[name];
  List<ValueNotifier<_BigInt>> minerOf(String name) => _miner[name];

  void increase(String name) {
    _resource[name].value += _BigInt.one;
  }

  void increaseMiner(String name, int index) {
    _miner[name][index].value += _BigInt.one;
  }
}
