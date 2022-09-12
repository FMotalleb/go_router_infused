library go_router_infused;

/// The route that accepts [GoMiddleware]
export 'package:go_router_infused/src/route.dart';

/// Abstract of the [Middleware]
export 'package:go_router_infused/src/middle_ware/middle_ware.dart';

/// Validation Result and Validation Exception classes
export 'package:go_router_infused/src/middle_ware/validation_result.dart';

/// a built-in middleware that will parse the given params and generate a
/// provider for the object
export 'package:go_router_infused/src/middle_ware/built_in/params_parser.dart';
