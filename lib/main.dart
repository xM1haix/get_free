import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  runApp(const MyApp());
}

///[grey] [Color] constant for app
const grey = Color(0xFF121212);

///[primary] [Color] constant for app
const primary = Color(0xFF00FF00);

///[textStyle] [TextStyle] constant for app
const textStyle = TextStyle(color: primary);

///Main skelethon of the app
class MyApp extends StatelessWidget {
  ///
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Get Free",
      home: MyHomePage(),
    );
  }
}

///Main skelethon of the app
class MyHomePage extends StatefulWidget {
  ///
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _counter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: grey,
        title: const Text(
          "Get Free",
          style: textStyle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _settings,
            icon: const Icon(
              Icons.settings,
              color: primary,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          _counter,
          style: textStyle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: _onTap,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    final s = (await SharedPreferences.getInstance()).getInt("days") ?? 0;
    setState(() {
      _counter = "$s days";
    });
  }

  Future<void> _onTap() async {
    final s = await SharedPreferences.getInstance();
    await s.setInt("days", (s.getInt("days") ?? 0) + 1);
    await _init();
  }

  Future<void> _settings() async {
    final t = TextEditingController();
    final c = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: grey,
        content: TextField(
          controller: t,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"^\d*$")),
          ],
        ),
        actions: [("Save", true), ("Cancel", false)]
            .map(
              (e) => TextButton(
                onPressed: () => Navigator.pop(context, e.$2),
                child: Text(
                  e.$1,
                  style: textStyle,
                ),
              ),
            )
            .toList(),
      ),
    );
    if (c != true) {
      return;
    }
    await (await SharedPreferences.getInstance())
        .setInt("days", int.parse(t.text));
    await _init();
  }
}
