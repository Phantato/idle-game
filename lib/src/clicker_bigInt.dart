part of clicker;

class _BigInt {

  BigInt _value;
  _BigInt([num value=0]) : _value = BigInt.from(value);
  _BigInt.from(this._value);
  
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
  _BigInt operator+(_BigInt other) => _BigInt.from(_value + other._value);
  _BigInt operator*(_BigInt other) => _BigInt.from(_value * other._value);
}
