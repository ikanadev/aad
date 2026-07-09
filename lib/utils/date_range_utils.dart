import 'package:aad/domain/models/transaction_filters.dart';

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const _monthAbbreviations = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const _weekdayAbbreviations = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// Start and end (inclusive) of the period of [type] containing [anchor].
({DateTime from, DateTime to}) dateRangeFor(
  DateRangeType type,
  DateTime anchor,
) {
  switch (type) {
    case DateRangeType.date:
      return (
        from: DateTime(anchor.year, anchor.month, anchor.day),
        to: DateTime(anchor.year, anchor.month, anchor.day, 23, 59, 59, 999),
      );
    case DateRangeType.week:
      final monday = DateTime(
        anchor.year,
        anchor.month,
        anchor.day - (anchor.weekday - 1),
      );
      return (
        from: monday,
        to: DateTime(monday.year, monday.month, monday.day + 6, 23, 59, 59, 999),
      );
    case DateRangeType.month:
      return (
        from: DateTime(anchor.year, anchor.month, 1),
        to: DateTime(anchor.year, anchor.month + 1, 0, 23, 59, 59, 999),
      );
    case DateRangeType.year:
      return (
        from: DateTime(anchor.year, 1, 1),
        to: DateTime(anchor.year, 12, 31, 23, 59, 59, 999),
      );
  }
}

/// [anchor] moved [delta] periods of [type] forward (negative for backward).
DateTime shiftAnchor(DateRangeType type, DateTime anchor, int delta) {
  switch (type) {
    case DateRangeType.date:
      return DateTime(anchor.year, anchor.month, anchor.day + delta);
    case DateRangeType.week:
      return DateTime(anchor.year, anchor.month, anchor.day + 7 * delta);
    case DateRangeType.month:
      return DateTime(anchor.year, anchor.month + delta, 1);
    case DateRangeType.year:
      return DateTime(anchor.year + delta, 1, 1);
  }
}

/// Human-friendly label for the period of [type] starting at [from].
String dateRangeLabel(DateRangeType type, DateTime from) {
  final now = DateTime.now();
  final range = dateRangeFor(type, from);
  final containsToday = !now.isBefore(range.from) && !now.isAfter(range.to);
  final yearSuffix = from.year == now.year ? '' : ' ${from.year}';

  switch (type) {
    case DateRangeType.date:
      if (containsToday) return 'Today';
      final yesterday = dateRangeFor(
        type,
        DateTime(now.year, now.month, now.day - 1),
      );
      if (from == yesterday.from) return 'Yesterday';
      return '${_weekdayAbbreviations[from.weekday - 1]}, '
          '${from.day} ${_monthAbbreviations[from.month - 1]}$yearSuffix';
    case DateRangeType.week:
      if (containsToday) return 'This week';
      final to = range.to;
      final fromPart =
          '${_weekdayAbbreviations[from.weekday - 1]} ${from.day}'
          '${from.month == to.month ? '' : ' ${_monthAbbreviations[from.month - 1]}'}';
      final toPart =
          '${_weekdayAbbreviations[to.weekday - 1]} ${to.day} '
          '${_monthAbbreviations[to.month - 1]}';
      return '$fromPart – $toPart$yearSuffix';
    case DateRangeType.month:
      if (containsToday) return 'This month';
      return '${_monthNames[from.month - 1]}$yearSuffix';
    case DateRangeType.year:
      if (containsToday) return 'This year';
      return '${from.year}';
  }
}
