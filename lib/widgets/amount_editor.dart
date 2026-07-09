/// Holds the amount string edited through [NumberPad] and converts it to
/// cents. The editor is unsigned; direction comes from the category type.
class AmountEditor {
  static const _maxIntegerDigits = 9;

  AmountEditor([this.value = '0']);

  AmountEditor.fromCents(int cents) : value = _format(cents < 0 ? 0 : cents);

  String value;

  int get cents {
    final parts = value.split('.');
    final integer = int.tryParse(parts[0]) ?? 0;
    final decimals = parts.length > 1 ? parts[1].padRight(2, '0') : '00';
    return integer * 100 + int.parse(decimals);
  }

  bool get isIncomplete => value.endsWith('.');

  void pressNumber(int number) {
    final dotIndex = value.indexOf('.');
    if (dotIndex == -1) {
      if (value == '0') {
        value = '$number';
      } else if (value.length < _maxIntegerDigits) {
        value += '$number';
      }
    } else if (value.length - dotIndex <= 2) {
      value += '$number';
    }
  }

  void pressDecimal() {
    if (value.contains('.')) return;
    value += '.';
  }

  void remove() {
    value = value.length <= 1 ? '0' : value.substring(0, value.length - 1);
  }

  static String _format(int cents) {
    final integer = cents ~/ 100;
    final remainder = cents % 100;
    return remainder == 0
        ? '$integer'
        : '$integer.${remainder.toString().padLeft(2, '0')}';
  }
}
