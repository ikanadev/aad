import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/models/stats_filters.dart';
import 'package:aad/domain/providers/accounts/accounts_provider.dart';
import 'package:aad/domain/providers/categories/categories_provider.dart';
import 'package:aad/domain/providers/stats/stats_filters_provider.dart';
import 'package:aad/utils/app_theme.dart';
import 'package:aad/widgets/app_icon.dart';

/// Two filter buttons ("Accounts · All", "Categories · N") opening multi-select
/// sheets, plus removable chips for the active selection below.
class StatsFilterBar extends ConsumerWidget {
  const StatsFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(statsFiltersProvider);
    final accounts = ref.watch(accountsProvider).asData?.value ?? [];
    final categories = (ref.watch(categoriesProvider).asData?.value ?? [])
        .where((category) => category.type == CategoryType.expense)
        .toList();

    final selectedAccounts = [
      for (final account in accounts)
        if (filters.accountIds?.contains(account.id) == true) account,
    ];
    final selectedCategories = [
      for (final category in categories)
        if (filters.categoryIds?.contains(category.id) == true) category,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _FilterButton(
                label: 'Accounts',
                count: selectedAccounts.length,
                onPressed: () => _showFilterSheet(
                  context: context,
                  title: 'Filter by account',
                  options: [
                    for (final account in accounts)
                      _FilterOption(
                        id: account.id,
                        label: '${account.name} · ${account.currencyCode}',
                      ),
                  ],
                  selectedIds: (filters) => filters.accountIds,
                  onChanged: (ref, ids) =>
                      ref.read(statsFiltersProvider.notifier).setAccountIds(ids),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: _FilterButton(
                label: 'Categories',
                count: selectedCategories.length,
                onPressed: () => _showFilterSheet(
                  context: context,
                  title: 'Filter by category',
                  options: [
                    for (final category in categories)
                      _FilterOption(
                        id: category.id,
                        label: category.name,
                        icon: AppIcons.tryParse(category.iconName),
                      ),
                  ],
                  selectedIds: (filters) => filters.categoryIds,
                  onChanged: (ref, ids) => ref
                      .read(statsFiltersProvider.notifier)
                      .setCategoryIds(ids),
                ),
              ),
            ),
          ],
        ),
        if (selectedAccounts.isNotEmpty)
          _SelectionRow(
            label: 'Accounts:',
            chips: [
              for (final account in selectedAccounts)
                _SelectionChip(
                  label: account.name,
                  onRemoved: () {
                    final ids = [...?filters.accountIds]..remove(account.id);
                    ref.read(statsFiltersProvider.notifier).setAccountIds(ids);
                  },
                ),
            ],
          ),
        if (selectedCategories.isNotEmpty)
          _SelectionRow(
            label: 'Categories:',
            chips: [
              for (final category in selectedCategories)
                _SelectionChip(
                  label: category.name,
                  icon: AppIcons.tryParse(category.iconName),
                  onRemoved: () {
                    final ids = [...?filters.categoryIds]..remove(category.id);
                    ref
                        .read(statsFiltersProvider.notifier)
                        .setCategoryIds(ids);
                  },
                ),
            ],
          ),
      ],
    );
  }

  void _showFilterSheet({
    required BuildContext context,
    required String title,
    required List<_FilterOption> options,
    required List<String>? Function(StatsFilters filters) selectedIds,
    required void Function(WidgetRef ref, List<String>? ids) onChanged,
  }) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final selected = selectedIds(ref.watch(statsFiltersProvider)) ?? [];
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CheckboxListTile(
                  value: selected.isEmpty,
                  onChanged: (_) => onChanged(ref, null),
                  title: const Text('All'),
                ),
                for (final option in options)
                  CheckboxListTile(
                    value: selected.contains(option.id),
                    onChanged: (checked) {
                      final ids = [...selected];
                      checked == true
                          ? ids.add(option.id)
                          : ids.remove(option.id);
                      onChanged(ref, ids);
                    },
                    title: Text(option.label),
                    secondary: option.icon == null
                        ? null
                        : AppIcon(icon: option.icon!, size: 22),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FilterOption {
  const _FilterOption({required this.id, required this.label, this.icon});

  final String id;
  final String label;
  final AppIcons? icon;
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.count,
    required this.onPressed,
  });

  final String label;
  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.filter_list, size: 18),
      label: Text('$label · ${count == 0 ? 'All' : count}'),
    );
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow({required this.label, required this.chips});

  final String label;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: AppSpacing.s8),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Wrap(spacing: 6, runSpacing: 6, children: chips)),
        ],
      ),
    );
  }
}

class _SelectionChip extends StatelessWidget {
  const _SelectionChip({required this.label, this.icon, required this.onRemoved});

  final String label;
  final AppIcons? icon;
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon == null ? null : AppIcon(icon: icon!, size: 16),
      label: Text(label),
      labelStyle: Theme.of(context).textTheme.labelSmall,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onDeleted: onRemoved,
    );
  }
}
