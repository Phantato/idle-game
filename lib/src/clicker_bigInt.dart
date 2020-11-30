part of clicker;

class _BigInt {
  final BigInt _value;

  static _BigInt get zero => _BigInt.from(0);
  static _BigInt get one => _BigInt.from(1);

  int get hashCode => _value.hashCode;
  get toJson => _value.toString;

  _BigInt(this._value);
  _BigInt.from(num value) : _value = BigInt.from(value);
  _BigInt.parse(String s) : _value = BigInt.parse(s);
  // _BigInt.fromJson(Map<String, dynamic> json)

  // : _value = BigInt.parse(json['data']);
  // int get hashCode => _value.hashCode;
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
    return len <= 3
        ? str
        : str.substring(0, digitShowed) +
            '.' +
            str[digitShowed] +
            _generateUnit(len ~/ 3);
  }

  _BigInt timesTen() => this * _BigInt.from(10);
  _BigInt timesThousand() => this * _BigInt.from(1000);
  // Only support integer range pow
  _BigInt pow(_BigInt other) => _BigInt(_value.pow(other._value.toInt()));
  _BigInt operator +(_BigInt other) => _BigInt(_value + other._value);
  _BigInt operator -(_BigInt other) => _BigInt(_value - other._value);
  _BigInt operator *(_BigInt other) => _BigInt(_value * other._value);
  _BigInt operator /(_BigInt other) => _BigInt(_value ~/ other._value +
      (_value % other._value == BigInt.zero ? BigInt.zero : BigInt.one));
  _BigInt operator ~/(_BigInt other) => _BigInt(_value ~/ other._value);
  bool operator <(_BigInt other) => _value < other._value;
  bool operator ==(Object other) =>
      other is _BigInt ? _value == other._value : false;
  bool operator <=(_BigInt other) => this < other || this == other;
}
