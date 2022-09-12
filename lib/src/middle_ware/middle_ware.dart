library go_router_infused.middleware;

import 'package:flutter/foundation.dart' show protected;
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:go_router/go_router.dart' show GoRouterState;
import 'package:provider/provider.dart' show Provider;
import 'package:go_router_infused/src/middle_ware/validation_result.dart' //
    show
        MiddlewareValidationResult;

abstract class GoMiddleware<T extends Object> {
  /// Generate the provider that can be accessed in the route.
  @protected
  Provider<T>? generateProvider(
    BuildContext context,
    GoRouterState state,
  );

  /// [validate] is simple validation method to check the parameters given to
  /// the middleware are correct so **DO NOT** use any huge computations here.
  @protected
  MiddlewareValidationResult? validate(
    BuildContext context,
    GoRouterState state,
  );
}
