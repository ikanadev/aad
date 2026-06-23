import 'package:flutter/material.dart';

import 'package:aad/domain/models/account.dart';
import 'package:aad/screens/home/utils/currency_utils.dart';

class AccountBottomSheet extends StatefulWidget {
  const AccountBottomSheet({super.key, this.account});

  final Account? account;

  bool get isEditing => account != null;

  @override
  State<AccountBottomSheet> createState() => _AccountBottomSheetState();
}

class _AccountBottomSheetState extends State<AccountBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _currencyCode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _currencyCode =
        widget.account?.currencyCode ?? supportedCurrencies.first.code;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isEditing ? 'Edit account' : 'Add account',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter an account name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (widget.isEditing)
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Currency',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    '${currencyNameByCode(_currencyCode)} (${currencySymbolByCode(_currencyCode)} $_currencyCode)',
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  initialValue: _currencyCode,
                  decoration: const InputDecoration(
                    labelText: 'Currency',
                    border: OutlineInputBorder(),
                  ),
                  items: supportedCurrencies
                      .map(
                        (currency) => DropdownMenuItem(
                          value: currency.code,
                          child: Text(
                            '${currency.name} (${currency.symbol} ${currency.code})',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _currencyCode = value);
                  },
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submit,
                child: Text(
                  widget.isEditing ? 'Save changes' : 'Create account',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      AccountBottomSheetResult(
        name: _nameController.text.trim(),
        currencyCode: _currencyCode,
      ),
    );
  }
}

class AccountBottomSheetResult {
  const AccountBottomSheetResult({
    required this.name,
    required this.currencyCode,
  });

  final String name;
  final String currencyCode;
}
