import 'package:flutter/material.dart';

import 'package:aad/domain/models/account.dart';
import 'package:aad/screens/home/utils/currency_utils.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({
    super.key,
    this.account,
    required this.submitLabel,
    required this.onSubmit,
  });

  final Account? account;
  final String submitLabel;
  final Future<void> Function(String name, String currencyCode) onSubmit;

  bool get isEditing => account != null;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _currencyCode;
  bool _saving = false;
  String? _error;

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
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null) ...[
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
          ],
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
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.submitLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await widget.onSubmit(_nameController.text.trim(), _currencyCode);
    } catch (error) {
      if (mounted) setState(() => _error = 'Could not save account: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
