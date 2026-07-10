import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aad/domain/models/account_details.dart';
import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/providers/accounts/accounts_provider.dart';
import 'package:aad/domain/providers/categories/categories_provider.dart';
import 'package:aad/domain/providers/transactions/transaction_actions_provider.dart';
import 'package:aad/utils/currency_utils.dart';
import 'package:aad/widgets/amount_editor.dart';
import 'package:aad/widgets/app_icon.dart';
import 'package:aad/widgets/number_pad.dart';

Future<void> showAddTransactionSheet(
  BuildContext context, {
  required Category category,
  AccountDetails? initialAccount,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => AddTransactionSheet(
      initialCategory: category,
      initialAccount: initialAccount,
    ),
  );
}

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({
    super.key,
    required this.initialCategory,
    this.initialAccount,
  });

  final Category initialCategory;
  final AccountDetails? initialAccount;

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  AccountDetails? _account;
  late Category _category;
  final AmountEditor _amount = AmountEditor();
  DateTime _date = DateTime.now();
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _account = widget.initialAccount;
    _category = widget.initialCategory;
  }

  bool get _isToday {
    final now = DateTime.now();
    return _date.year == now.year &&
        _date.month == now.month &&
        _date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = _account == null
        ? ''
        : '${currencySymbolByCode(_account!.currencyCode)} ';

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
            Row(
              children: [
                Expanded(
                  child: _PickerChip(
                    label: _account?.name ?? 'Choose account',
                    icon: const Icon(Icons.account_balance_wallet_outlined),
                    onTap: _saving ? null : _pickAccount,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerChip(
                    label: _category.name,
                    icon: _CategoryAvatar(category: _category, radius: 12),
                    onTap: _saving ? null : _pickCategory,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '$currencySymbol${_amount.value}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            TextButton(
              onPressed: _saving ? null : _pickDate,
              child: Text(
                _isToday
                    ? 'Today'
                    : '${_date.day.toString().padLeft(2, '0')}'
                          '/${_date.month.toString().padLeft(2, '0')}'
                          '/${_date.year}',
              ),
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

  Future<void> _pickAccount() async {
    final selected = await showModalBottomSheet<AccountDetails>(
      context: context,
      builder: (context) => _AccountPickerSheet(selectedId: _account?.id),
    );

    if (selected != null && mounted) {
      setState(() {
        _account = selected;
        _error = null;
      });
    }
  }

  Future<void> _pickCategory() async {
    final selected = await showModalBottomSheet<Category>(
      context: context,
      builder: (context) => _CategoryPickerSheet(
        type: _category.type,
        selectedId: _category.id,
      ),
    );

    if (selected != null && mounted) {
      setState(() {
        _category = selected;
        _error = null;
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: now,
    );

    if (picked == null || !mounted) return;

    setState(() {
      // Keep the time of day for today so transactions sort naturally;
      // past days get midnight.
      _date =
          picked.year == now.year &&
              picked.month == now.month &&
              picked.day == now.day
          ? now
          : picked;
    });
  }

  Future<void> _submit() async {
    final account = _account;

    final String? error;
    if (account == null) {
      error = 'Choose an account first';
    } else if (_amount.isIncomplete) {
      error = 'The amount is incomplete';
    } else if (_amount.cents == 0) {
      error = 'Enter an amount';
    } else if (_category.type == CategoryType.expense &&
        _amount.cents > account.balance) {
      error = 'Not enough balance in ${account.name}';
    } else {
      error = null;
    }

    if (error != null) {
      setState(() => _error = error);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ref
          .read(transactionActionsProvider.notifier)
          .createTransaction(
            accountId: account!.id,
            categoryId: _category.id,
            amount: _amount.cents,
            date: _date,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Transaction added')));
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Could not save transaction: $error';
        });
      }
    }
  }
}

class _PickerChip extends StatelessWidget {
  const _PickerChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            IconTheme(
              data: const IconThemeData(size: 20),
              child: icon,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const Icon(Icons.expand_more, size: 18),
          ],
        ),
      ),
    );
  }
}

class _CategoryAvatar extends StatelessWidget {
  const _CategoryAvatar({required this.category, required this.radius});

  final Category category;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final color = category.appColor;
    final icon = AppIcons.tryParse(category.iconName);

    return CircleAvatar(
      radius: radius,
      backgroundColor: color.container,
      child: icon == null
          ? Icon(Icons.category_outlined, color: color.fill, size: radius)
          : AppIcon(icon: icon, size: radius * 1.4),
    );
  }
}

class _AccountPickerSheet extends ConsumerWidget {
  const _AccountPickerSheet({this.selectedId});

  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsValue = ref.watch(accountsProvider);

    return _PickerListSheet(
      title: 'Choose account',
      child: accountsValue.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No accounts yet.')),
            );
          }

          return ListView(
            shrinkWrap: true,
            children: [
              for (final account in accounts)
                ListTile(
                  onTap: () => Navigator.of(context).pop(account),
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                  title: Text(account.name),
                  subtitle: Text(
                    '${(account.balance / 100).toStringAsFixed(2)} '
                    '${currencySymbolByCode(account.currencyCode)} '
                    '${account.currencyCode}',
                  ),
                  trailing: account.id == selectedId
                      ? const Icon(Icons.check)
                      : null,
                ),
            ],
          );
        },
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Could not load accounts: $error'),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _CategoryPickerSheet extends ConsumerWidget {
  const _CategoryPickerSheet({required this.type, this.selectedId});

  final CategoryType type;
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesValue = ref.watch(categoriesProvider);

    return _PickerListSheet(
      title: 'Choose category',
      child: categoriesValue.when(
        data: (categories) {
          final sameType = categories
              .where((category) => category.type == type)
              .toList();

          return ListView(
            shrinkWrap: true,
            children: [
              for (final category in sameType)
                ListTile(
                  onTap: () => Navigator.of(context).pop(category),
                  leading: _CategoryAvatar(category: category, radius: 16),
                  title: Text(category.name),
                  trailing: category.id == selectedId
                      ? const Icon(Icons.check)
                      : null,
                ),
            ],
          );
        },
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Could not load categories: $error'),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _PickerListSheet extends StatelessWidget {
  const _PickerListSheet({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          Flexible(child: child),
        ],
      ),
    );
  }
}
