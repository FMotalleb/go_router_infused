## background

this package was built as an extension on [go_router](https://pub.dev/packages/go_router)

currently in this version(0.0.1+) it only implements middleware

since middlewares are not supported by default in this case an extended version of `GoRoute`
is built (`GoRouteInfused`) that accepts middlewares

middlewares use [provider](https://pub.dev/packages/provider) to attach middleware's result to the context.

its simple to migrate to `GoRouteInfused`, since it uses all parameters of `GoRoute`

if you don't have any middleware for a route **DO NOT** use `GoRouteInfused`

## usecases

* parsing models from route parameters
* checking user authentication before changing route

## example

model:

```dart
class MyModel{
    final String text;
    const MyModel(this.text);
    factory MyModel.fromParams(Map<String,String> params)=>MyModel(params['text']);
}
```

middleware definition:

```dart
/// [GoMiddlewareParamsParser] is a built-in middleware that parses parameters
final myMiddleware = GoMiddlewareParamsParser<MyModel>(
    parser:MyModel.fromParams,
    canBeIgnored=true,
);
```

route definition:

```dart
GoRouteInfused(
    // currently you must provide parameters in path manually
    path: "/path/to/route/:text",
     builder:(context,state){
        // there is a extension on `BuildContext` that checks existence of a provider
        // its not efficient thu, you may need to create a method manually for this purpose.
        if(context.hasProviderFor<MyModel>()){
            final myInstance=context.read<MyModel>();
            print(myInstance.text);
        }
        throw UnimplementedError();
     },
    middlewares = [
        myMiddleware,
    ],
)
```

in this example if you go to route `/path/to/route/test_text`
the result will be `test_text`.
