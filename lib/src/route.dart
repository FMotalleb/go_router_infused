library go_router_infused.route;

import 'package:flutter/widgets.dart' show BuildContext, Widget;
import 'package:go_router/go_router.dart' show GoRoute, GoRouterState;
import 'package:provider/provider.dart' show MultiProvider, Provider;

import 'package:go_router_infused/src/middle_ware/middle_ware.dart' //
    show
        GoMiddleware;
import 'package:go_router_infused/src/middle_ware/validation_result.dart' //
    show
        MiddlewareValidationResultException;

class GoRouteInfused extends GoRoute {
  /// Default constructor used to create mapping between a route path and a page
  /// builder but supports middlewares
  ///
  /// you can bypass validation phase of middlewares by passing false to
  /// [testMiddlewareValidation]
  ///
  /// since middlewares generate provider result of middlewares can be accessed
  /// in builder using normal provider calls
  /// ```dart
  ///  context.read<`Provider Name`>()
  /// ```
  GoRouteInfused({
    required super.path,
    required Widget Function(BuildContext, GoRouterState) builder,
    List<GoMiddleware> middlewares = const [],
    bool testMiddlewareValidation = true,
    super.name,
    super.pageBuilder,
    super.routes,
    super.redirect,
  }) : super(
          builder: (context, state) {
            if (middlewares.isEmpty) {
              return builder(context, state);
            }
            if (testMiddlewareValidation) {
              _validateMiddleware(middlewares, context, state);
            }
            final providers = _generateProviders(middlewares, context, state);
            if (providers.isNotEmpty) {
              return MultiProvider(
                providers: providers.toList(),
                builder: (context, child) => builder(context, state),
              );
            }
            return builder(context, state);
          },
        );

  static Iterable<Provider> _generateProviders(
      List<GoMiddleware> middleWares, BuildContext context, GoRouterState state) sync* {
    for (final i in middleWares) {
      final provider = i.generateProvider(context, state);
      if (provider != null) {
        yield provider;
      }
    }
  }

  static void _validateMiddleware(List<GoMiddleware> middleWares, BuildContext context, GoRouterState state) {
    for (final i in middleWares) {
      // ignore: invalid_use_of_protected_member
      final validationResult = i.validate(context, state);
      if (validationResult != null) {
        if (validationResult.isValid == false && validationResult.canBeIgnored == false) {
          throw MiddlewareValidationResultException(
            validationResult,
            i,
          );
        }
      }
    }
  }
}
