import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aad/domain/models/account_details.dart';
import 'package:aad/domain/providers/transactions/transaction_actions_provider.dart';
import 'package:aad/utils/currency_utils.dart';
import 'package:aad/widgets/amount_editor.dart';
import 'package:aad/widgets/number_pad.dart';

Future<void> showAdjustBalanceSheet(
  BuildContext context, {
  required AccountDetails account,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => AdjustBalanceSheet(account: account),
  );
}

class AdjustBalanceSheet extends ConsumerStatefulWidget {
  const AdjustBalanceSheet({super.key, required this.account});

  final AccountDetails account;

  @override
  ConsumerState<AdjustBalanceSheet> createState() =>
      _AdjustBalanceSheetState();
}

class _AdjustBalanceSheetState extends ConsumerState<AdjustBalanceSheet> {
  late final AmountEditor _amount = AmountEditor.fromCents(
    widget.account.balance,
  );
  String? _error;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final currencySymbol = currencySymbolByCode(widget.account.currencyCode);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Adjust balance',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _AccountChip(name: widget.account.name),
            const SizedBox(height: 24),
            Text(
              '$currencySymbol ${_amount.value}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            if (_error != null) ...[
              const SizedBox(height: 4),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            NumberPad(
              onNumberPress: _onNumberPress,
              onDecimalPress: _onDecimalPress,
              onRemove: _onRemove,
              onSubmit: _saving ? () {} : _submit,
            ),
          ],
        ),
      ),
    );
  }

  void _onNumberPress(int number) {
    setState(() {
      _error = null;
      _amount.pressNumber(number);
    });
  }

  void _onDecimalPress() {
    setState(() {
      _error = null;
      _amount.pressDecimal();
    });
  }

  void _onRemove() {
    setState(() {
      _error = null;
      _amount.remove();
    });
  }

  Future<void> _submit() async {
    if (_amount.isIncomplete) {
      setState(() => _error = 'The amount is incomplete');
      return;
    }

    if (_amount.cents == widget.account.balance) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ref
          .read(transactionActionsProvider.notifier)
          .adjustAccountBalance(
            accountId: widget.account.id,
            newBalance: _amount.cents,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Balance updated')));
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Could not adjust balance: $error';
        });
      }
    }
  }
}

class _AccountChip extends StatelessWidget {
  const _AccountChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
