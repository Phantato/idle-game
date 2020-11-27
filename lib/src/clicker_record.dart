part of clicker;

class _Records {
  static final _record = _Records._internal();

  final _resourceTabel = <String, ValueNotifier<_BigInt>>{};
  final _minerListTabel = <String, List<ValueNotifier<_BigInt>>>{};
  final _minerCostListTabel = <String, List<ValueNotifier<_BigInt>>>{};
  factory _Records() {
    return _record;
  }

  _Records._internal() {
    Clicker.names.forEach((name) {
      _resourceTabel[name] = ValueNotifier<_BigInt>(_BigInt.zero);
      _minerListTabel[name] = <ValueNotifier<_BigInt>>[];
      _minerListTabel[name].add(ValueNotifier(_BigInt.zero));
      _minerCostListTabel[name] = <ValueNotifier<_BigInt>>[];
      _minerCostListTabel[name].add(ValueNotifier(_BigInt(10)));
    });
  }

  ValueNotifier<_BigInt> numberOf(String name) => _resourceTabel[name];
  ValueNotifier<_BigInt> minerOfAt(String name, int index) =>
      _minerListTabel[name][index];
  ValueNotifier<_BigInt> minerCostOfAt(String name, int index) =>
      _minerCostListTabel[name][index];
  List<ValueNotifier<_BigInt>> minerListOf(String name) =>
      _minerListTabel[name];

  void increase(String name) {
    increaseBy(name, _BigInt.one);
  }

  void increaseBy(String name, _BigInt value) {
    _resourceTabel[name].value += value;
  }

  void decreaseBy(String name, _BigInt value) {
    _resourceTabel[name].value -= value;
  }

  void increaseMinerOf(String name, int index) {
    _increaseMinerOfBy(name, index, _BigInt.one);
  }

  void _increaseMinerOfBy(String name, int index, _BigInt value) {
    _minerListTabel[name][index].value += value;
    _minerCostListTabel[name][index].value += value * _BigInt(10);
    Clicker._increaser.regist(name, index, value);
  }
}
