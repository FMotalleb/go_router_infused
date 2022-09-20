import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_infused/go_router_infused.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

final router = GoRouter(
  routerNeglect: true,
  initialLocation: '/example/initial',
  routes: [
    GoRouteInfused(
      middlewares: [
        GoMiddlewareParamsParser<DataModel>(
          parser: DataModel.fromStringMap,
          canBeIgnored: false,
        ),
      ],
      path: '/example/:name',
      builder: (context, state) => const MyHomePage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Example',
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        brightness: Brightness.dark,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  void reroute() {
    final name = _nameController.text;

    router.push('/example/$name', extra: {'name': name});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SimpleResponse(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SimpleResponse(),
            TextField(
              controller: _nameController,
            ),
            TextButton.icon(
              onPressed: reroute,
              icon: const Icon(Icons.navigate_next_outlined),
              label: const Text('navigate'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reroute,
        tooltip: 'Navigate',
        child: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}

class SimpleResponse extends StatelessWidget {
  const SimpleResponse({super.key});

  @override
  Widget build(BuildContext context) {
    final hasProvider = context.hasProviderFor<DataModel>();
    // final res = context.read<DataModel>();
    // print(res);
    if (hasProvider) {
      return Text('name is ${context.read<DataModel>().name}');
    }

    return const Text('cannot find data model');
  }
}

class DataModel {
  final String name;

  DataModel(this.name);
  factory DataModel.fromStringMap(Map<String, String> params) {
    assert(params.containsKey("name"));
    return DataModel(params['name']!);
  }
}
