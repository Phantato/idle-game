part of clicker;

class _Records {
  static final _record = _Records._internal();
  
  
  final _resource = <String, _BigInt>{};
  final _miner = <String, _BigInt>{};

  get numberOf => (String name) => _resource[name];
  get miner => (String name) => _miner[name];
  get increase => (String name) => _resource[name] += _BigInt(1);
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

  BigInt _value;
  _BigInt([num value=0]) : _value = BigInt.from(value);
  _BigInt.parse(String value) : _value = BigInt.parse(value);
  
  String _generateUnit(int n) {
    String ret = '';
    while (n > 0) {
      --n;  
      ret += String.fromCharCode(n % 26 + 'a'.codeUnitAt(0));
      n ~/= 26;
    }
    return ret.split('').reversed.join('');
  }

  String toString() {  
    String str = '$_value';  
    int len = str.length;
    int digitShowed = len % 3 != 0 ? len % 3 : 3;
    return len <= 3 ? str :
      str.substring(0, digitShowed) + '.' + str[digitShowed] + _generateUnit(len ~/ 3);
  }
  _BigInt operator+(_BigInt other) => _BigInt.parse('${_value + other._value}');
}

