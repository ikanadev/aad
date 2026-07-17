import 'package:flutter/material.dart';

import 'package:aad/domain/models/account.dart';
import 'package:aad/domain/models/app_color.dart';
import 'package:aad/utils/app_theme.dart';
import 'package:aad/utils/currency_utils.dart';
import 'package:aad/widgets/color_picker.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({
    super.key,
    this.account,
    required this.submitLabel,
    required this.onSubmit,
    this.onAdjustBalance,
  });

  final Account? account;
  final String submitLabel;
  final Future<void> Function(
    String name,
    String currencyCode,
    String color,
    bool isDefault,
  )
  onSubmit;
  final VoidCallback? onAdjustBalance;

  bool get isEditing => account != null;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _currencyCode;
  late String _color;
  late bool _isDefault;
  bool _saving = false;
  String? _error;

  // The current default can't be untoggled directly; the default only moves
  // when another account claims it.
  bool get _lockedAsDefault => widget.account?.isDefault ?? false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _currencyCode =
        widget.account?.currencyCode ?? supportedCurrencies.first.code;
    _color = widget.account?.color ?? 'blue';
    _isDefault = widget.account?.isDefault ?? false;
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
        padding: const EdgeInsets.all(AppSpacing.s16),
        children: [
          if (_error != null) ...[
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: AppSpacing.s16),
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
          const SizedBox(height: AppSpacing.s16),
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
          const SizedBox(height: AppSpacing.s16),
          SwatchPickerField(
            label: 'Color',
            onTap: _pickColor,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColor.byName(_color).fill,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          SwitchListTile(
            title: const Text('Default account'),
            subtitle: Text(
              _lockedAsDefault
                  ? 'To change it, make another account the default'
                  : 'Preselected when creating a transaction',
            ),
            contentPadding: EdgeInsets.zero,
            value: _isDefault,
            onChanged: _lockedAsDefault
                ? null
                : (value) => setState(() => _isDefault = value),
          ),
          const SizedBox(height: AppSpacing.s24),
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
          if (widget.onAdjustBalance != null) ...[
            const SizedBox(height: AppSpacing.s12),
            OutlinedButton(
              onPressed: _saving ? null : widget.onAdjustBalance,
              child: const Text('Adjust balance'),
            ),
          ],
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
      await widget.onSubmit(
        _nameController.text.trim(),
        _currencyCode,
        _color,
        _isDefault,
      );
    } catch (error) {
      if (mounted) setState(() => _error = 'Could not save account: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickColor() async {
    final selected = await showAppColorPicker(context, selectedName: _color);
    if (selected != null) setState(() => _color = selected.name);
  }
}
