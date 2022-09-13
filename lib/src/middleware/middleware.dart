library go_router_infused.middleware;

import 'package:flutter/foundation.dart' show protected;
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:go_router/go_router.dart' show GoRouterState;
import 'package:provider/provider.dart' show Provider;
import 'package:go_router_infused/src/middleware/validation_result.dart' //
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
  ///
  /// result of this method can be overriden by the creation of the
  /// [GoRouteInfused]
  ///
  /// this method is called before the [generateProvider] if validation was not
  /// ignored in GoRouteInfused construction.
  @protected
  MiddlewareValidationResult? validate(
    BuildContext context,
    GoRouterState state,
  );

  /// redirect to another route if returned a non-null value
  ///
  /// for example this can be used to handle user authentications and
  /// permissions
  String? redirect(GoRouterState state) => null;
}
