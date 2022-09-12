import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension ProviderContext on BuildContext {
  bool hasProviderFor<T extends Object>() {
    try {
      read<T>();
      return true;
    } on ProviderNullException catch (_) {
      return false;
    }
  }
}
