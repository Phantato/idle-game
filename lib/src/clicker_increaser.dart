part of clicker;

class _Increaser {
  static final _increaser = _Increaser._internal();
  final _harvestMap = <String, _BigInt>{};

  factory _Increaser() {
    return _increaser;
  }

  void _clear() {
    _harvestMap.updateAll((_, __) => _BigInt.zero);
  }

  _Increaser._internal();
  void _flush(Map<String, List<_Worker>> map) {
    _clear();
    map.forEach((name, list) {
      list.forEach((worker) {
        _harvestMap[name] = worker._efficient * worker._number.value;
      });
    });
  }

  void regist(String name, int index, _BigInt value) {
    _harvestMap[name] += _Record()._efficientOfAt(name, index) * value;
  }

  void harvest() {
    _harvestMap.forEach((name, value) => _Record()._increaseBy(name, value));
  }
}
