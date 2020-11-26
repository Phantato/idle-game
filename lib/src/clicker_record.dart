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

  BigInt value;
  _BigInt([num value=0]) : this.value = BigInt.from(value);
  
  String _generateUnit(int n) {
    String ret = '';
    while (n > 0) {
      --n;  
      ret += String.fromCharCode(n % 26 + 'a'.codeUnitAt(0));
      n ~/= 26;
    }
    return ret.split('').reversed.join('');
  }

  @override  
  String toString() {  
    String str = '$value';  
    int len = str.length;
    int digitShowed = len % 3 != 0 ? len % 3 : 3;
    return len <= 3 ? '$value' :
      '$value'.substring(0, digitShowed) + '.' + '$value'[digitShowed] + _generateUnit(len ~/ 3);
  }
}

