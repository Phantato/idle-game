part of clicker;

class _Records {
  static final _record = _Records._internal();
  
  
  final _resource = <String, _BigInt>{};
  final _miner = <String, _BigInt>{};

  get resource => (String name) => _resource[name];
  get miner => (String name) => _miner[name];

  factory _Records() {
    return _record;
  }

  _Records._internal() {
    for (var name in Clicker.names) {
      _resource[name] = _BigInt();
      _miner[name] = _BigInt();
    }
  }
}

class _BigInt {
  int value;
  
  _BigInt([this.value = 100]);

  String toString() => value.toString();

  @override  
  _BigInt operator+(int i) {
    value += i;
    return this;
  }
}

