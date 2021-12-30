import 'package:flutter/material.dart';
import 'package:zevent_bus/zevent_bus.dart';
void main() {
  runApp(const MyApp());
}

const String CUS_KEY = "CUS_KEY";


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    _counter += 1;
    EventBus.instance.commit(eventKey: CUS_KEY, arg: "params = $_counter");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            _Text()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _Text extends StatefulWidget {
  const _Text({ Key? key }) : super(key: key);

  @override
  __TextState createState() => __TextState();
}

class __TextState extends State<_Text> {

  String val = "";
  @override
  void initState() {
    super.initState();
    EventBus.instance.addListener(eventKey: CUS_KEY, callback: (arg) {
      setState(() {
        val = "$arg";
      });
    });
  }

  @override
  void dispose() {
    EventBus.instance.removeListener(CUS_KEY);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
              '$val',
              style: Theme.of(context).textTheme.headline4,
            );
  }
}
