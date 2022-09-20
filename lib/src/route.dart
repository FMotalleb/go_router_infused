// ignore_for_file: invalid_use_of_protected_member

library go_router_infused.route;

import 'package:flutter/widgets.dart' show BuildContext, Widget;
import 'package:go_router/go_router.dart' show GoRoute, GoRouterState;
import 'package:provider/provider.dart' show MultiProvider, Provider;

import 'package:go_router_infused/src/middleware/middleware.dart' //
    show
        GoMiddleware;
import 'package:go_router_infused/src/middleware/validation_result.dart' //
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
  ///
  /// acts like normal [GoRoute] if no middleware provided.
  GoRouteInfused({
    required super.path,
    required Widget Function(BuildContext, GoRouterState) builder,
    List<GoMiddleware> middlewares = const [],
    bool testMiddlewareValidation = true,
    super.name,
    super.pageBuilder,
    super.routes,
    String? Function(GoRouterState)? redirect,
  }) : super(
          redirect: (context, state) {
            for (final i in middlewares) {
              final redirectResult = i.redirect(context, state);
              if (redirectResult != null) {
                return redirectResult;
              }
            }
            return redirect?.call(state);
          },
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

  /// alternatively instead of creating new route or migrating to
  /// [GoRouteInfused] its possible to use [injectMiddle] on existing routes.
  ///
  /// @params:
  /// - [route] : (GoRoute) => normal [GoRoute]
  /// - [middlewares] : (List<GoMiddleware>)
  /// - [newPath] : (String?) => new path for the route
  /// - [testMiddlewareValidation] : (bool)
  /// - [pathResolver] : (String Function(String)?) => regenerate path for the
  ///   route
  ///

  // factory GoRouteInfused.injectMiddle({
  //   required GoRoute route,
  //   required List<GoMiddleware> middlewares,
  //   String? newPath,
  //   String Function(String route)? pathResolver,
  //   bool testMiddlewareValidation = true,
  // }) {
  //   // todo change method
  //   String path = newPath ?? route.path;
  //   if (pathResolver != null) {
  //     path = pathResolver(path);
  //   }
  //   return GoRouteInfused(
  //     builder: route.builder,
  //     path: path,
  //     middlewares: middlewares,
  //     name: route.name,
  //     pageBuilder: route.pageBuilder,
  //     redirect: route.redirect,
  //     routes: route.routes,
  //     testMiddlewareValidation: testMiddlewareValidation,
  //   );
  // }
  static Iterable<Provider> _generateProviders(
    List<GoMiddleware> middleWares,
    BuildContext context,
    GoRouterState state,
  ) sync* {
    for (final i in middleWares) {
      final provider = i.generateProvider(context, state);
      if (provider != null) {
        yield provider;
      }
    }
  }

  static void _validateMiddleware(
    List<GoMiddleware> middleWares,
    BuildContext context,
    GoRouterState state,
  ) {
    for (final i in middleWares) {
      final validationResult = i.validate(context, state);
      if (validationResult != null) {
        if (validationResult.isValid == false && //
            validationResult.canBeIgnored == false) {
          throw MiddlewareValidationResultException(
            validationResult,
            i,
          );
        }
      }
    }
  }
}
