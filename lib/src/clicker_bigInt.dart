part of clicker;

class _BigInt {
  final BigInt _value;

  static _BigInt get zero => _BigInt.from(0);
  static _BigInt get one => _BigInt.from(1);

  _BigInt(this._value);
  _BigInt.from(num value) : _value = BigInt.from(value);
  _BigInt.parse(String s) : _value = BigInt.parse(s);
  _BigInt.fromJson(Map<String, dynamic> json)
      : _value = BigInt.parse(json['data']);
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

  Map<String, dynamic> toJson() => {
        'data': '$_value',
      };
  _BigInt operator +(_BigInt other) => _BigInt(_value + other._value);
  _BigInt operator -(_BigInt other) => _BigInt(_value - other._value);
  _BigInt operator *(_BigInt other) => _BigInt(_value * other._value);
  bool operator <(_BigInt other) => _value < other._value;
  // @override
  // bool operator ==(_BigInt other) => _value == other._value;
}
