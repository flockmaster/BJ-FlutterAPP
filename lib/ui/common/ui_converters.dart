import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extension methods for UI Logic (UI Converters)
/// As per requirements.md

extension BoolUIConverters on bool {
  /// Returns the widget if true, otherwise returns SizedBox.shrink()
  Widget visible(Widget widget) {
    return this ? widget : const SizedBox.shrink();
  }

  /// Returns the widget if true, otherwise returns SizedBox.shrink()
  /// Synonym for visible but often used for collapsible sections
  Widget collapsed(Widget widget) {
    return this ? widget : const SizedBox.shrink();
  }
}

extension WidgetUIConverters on Widget? {
  /// Returns this widget if not null, otherwise returns the fallback widget
  Widget orElse(Widget fallback) {
    return this ?? fallback;
  }
}

extension DateTimeUIConverters on DateTime {
  /// Returns string in YYYY-MM-DD format
  String toYMD() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// Returns a friendly string like "Today", "Yesterday" or YYYY-MM-DD
  String toFriendlyString() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0 && day == now.day) {
      return 'Today';
    } else if (difference.inDays == 1 || (difference.inDays == 0 && day != now.day)) {
      return 'Yesterday';
    } else {
      return toYMD();
    }
  }
}

extension DoubleUIConverters on double {
  /// Returns currency string
  String toCurrency({String symbol = '¥', int decimalDigits = 2}) {
    return NumberFormat.currency(symbol: symbol, decimalDigits: decimalDigits).format(this);
  }
}

extension ListUIConverters<T> on List<T>? {
  /// Returns the widget if the list is not null and not empty
  Widget visibleWhenNotEmpty(Widget Function(List<T> list) builder) {
    if (this != null && this!.isNotEmpty) {
      return builder(this!);
    }
    return const SizedBox.shrink();
  }
}
