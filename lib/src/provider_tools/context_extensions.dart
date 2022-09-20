import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension ProviderContext on BuildContext {
  /// checking if [Provider<T>] is available on the current [context]
  bool hasProviderFor<T extends Object>() {
    try {
      read<T>();
      return true;
    } catch (_) {
      return false;
    }
  }

  T? readOrNull<T>() {
    try {
      return read<T>();
    } catch (e) {
      return null;
    }
  }
}
