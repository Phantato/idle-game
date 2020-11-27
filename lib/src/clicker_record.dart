part of clicker;

class _Records {
  static final _record = _Records._internal();

  final _resourceTabel = <String, ValueNotifier<_BigInt>>{};
  final _workerListTabel = <String, List<ValueNotifier<_BigInt>>>{};
  final _workerCostListTabel = <String, List<ValueNotifier<_BigInt>>>{};
  factory _Records() {
    return _record;
  }

  _Records._internal() {
    Clicker.names.forEach((name) {
      _resourceTabel[name] = ValueNotifier<_BigInt>(_BigInt.zero);
      _workerListTabel[name] = <ValueNotifier<_BigInt>>[];
      _workerListTabel[name].add(ValueNotifier(_BigInt.zero));
      _workerCostListTabel[name] = <ValueNotifier<_BigInt>>[];
      _workerCostListTabel[name].add(ValueNotifier(_BigInt(10)));
    });
  }

  ValueNotifier<_BigInt> numberOf(String name) => _resourceTabel[name];
  ValueNotifier<_BigInt> workerOfAt(String name, int index) =>
      _workerListTabel[name][index];
  ValueNotifier<_BigInt> workerCostOfAt(String name, int index) =>
      _workerCostListTabel[name][index];
  List<ValueNotifier<_BigInt>> workerListOf(String name) =>
      _workerListTabel[name];

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
    _workerListTabel[name][index].value += value;
    _workerCostListTabel[name][index].value += value * _BigInt(10);
    Clicker._increaser.regist(name, index, value);
  }
}
