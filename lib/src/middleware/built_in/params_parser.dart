library go_router_infused.middleware.built_in;

import 'package:flutter/widgets.dart' show BuildContext;
import 'package:go_router/go_router.dart' show GoRouterState;
import 'package:provider/provider.dart' show Provider;

import 'package:go_router_infused/src/middleware/middleware.dart' //
    show
        GoMiddleware;
import 'package:go_router_infused/src/middleware/validation_result.dart' //
    show
        MiddlewareValidationResult;

class GoMiddlewareParamsParser<T extends Object> extends GoMiddleware<T> {
  final T? Function(Map<String, String> params) parser;
  final bool Function(Map<String, String> params)? validator;
  final bool canBeIgnored;

  /// -parameters given to the middleware are [Map<String,String>]
  /// so don't use the default [toMap] constructor method here
  ///
  /// -[validator] is simple validation method to check the parameters given to
  /// the middleware are correct so **DO NOT** use any huge computations here
  ///
  /// - if result of this middleware can be ignored pass
  /// [true] to [canBeIgnored] so this way the middleware validator will not
  /// throw an exception
  GoMiddlewareParamsParser({
    required this.parser,
    this.validator,
    required this.canBeIgnored,
  });

  @override
  Provider<T>? generateProvider(
    BuildContext context,
    GoRouterState state,
  ) {
    final object = parser(state.params);
    if (object == null) {
      return null;
    }
    return Provider<T>(
      create: (context) => object,
    );
  }

  @override
  MiddlewareValidationResult? validate(
    BuildContext context,
    GoRouterState state,
  ) {
    if (validator == null) {
      return null;
    }
    final result = validator!(state.params);
    return MiddlewareValidationResult(
      canBeIgnored: canBeIgnored,
      code: result ? 0 : 1,
      isValid: result,
    );
  }

  @override
  String toString() {
    return 'params parser of type $T';
  }
}
