import 'package:flutter_test/flutter_test.dart';

import 'package:aad/widgets/amount_editor.dart';

void main() {
  group('AmountEditor', () {
    test('starts at 0', () {
      final editor = AmountEditor();
      expect(editor.value, '0');
      expect(editor.cents, 0);
    });

    test('replaces the leading zero', () {
      final editor = AmountEditor()..pressNumber(5);
      expect(editor.value, '5');
      expect(editor.cents, 500);
    });

    test('limits the integer part to 9 digits', () {
      final editor = AmountEditor();
      for (var i = 0; i < 12; i++) {
        editor.pressNumber(9);
      }
      expect(editor.value, '999999999');
    });

    test('allows at most two decimals', () {
      final editor = AmountEditor()
        ..pressNumber(1)
        ..pressDecimal()
        ..pressNumber(2)
        ..pressNumber(3)
        ..pressNumber(4);
      expect(editor.value, '1.23');
      expect(editor.cents, 123);
    });

    test('ignores a second decimal point', () {
      final editor = AmountEditor()
        ..pressNumber(1)
        ..pressDecimal()
        ..pressDecimal();
      expect(editor.value, '1.');
      expect(editor.isIncomplete, isTrue);
    });

    test('pads a single decimal digit when converting to cents', () {
      final editor = AmountEditor()
        ..pressNumber(1)
        ..pressDecimal()
        ..pressNumber(5);
      expect(editor.cents, 150);
    });

    test('remove falls back to 0 on the last character', () {
      final editor = AmountEditor()..pressNumber(7);
      editor.remove();
      expect(editor.value, '0');
    });

    group('fromCents', () {
      test('formats whole amounts without decimals', () {
        expect(AmountEditor.fromCents(12300).value, '123');
      });

      test('formats fractional amounts with two decimals', () {
        expect(AmountEditor.fromCents(12345).value, '123.45');
        expect(AmountEditor.fromCents(105).value, '1.05');
      });

      test('clamps negative amounts to 0', () {
        expect(AmountEditor.fromCents(-500).value, '0');
      });

      test('round-trips through cents', () {
        expect(AmountEditor.fromCents(12345).cents, 12345);
        expect(AmountEditor.fromCents(12300).cents, 12300);
      });
    });
  });
}
