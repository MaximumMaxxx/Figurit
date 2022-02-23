import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:basic_utils/basic_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Figurit, The instant calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.cyan,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: "Figurit"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool mode = false;

  final input1Controller = TextEditingController();
  final input2Controller = TextEditingController();
  String operation = "+";

  @override
  void dispose() {
    input1Controller.dispose();
    input2Controller.dispose();
    super.dispose();
  }

  double doublify(TextEditingController controller) {
    String value = '';
    if (controller.text.isNotEmpty) {
      if (controller.text[0] != '-') {
        // not a negative sign
        value = '0' + controller.text;
      } else {
        value = StringUtils.addCharAtPosition(controller.text, "0", 1);
      }
    } else {
      value = '0';
    }
    return (double.parse(value));
  }

  String mathify(
      TextEditingController controller1, TextEditingController controller2) {
    switch (operation) {
      case "+":
        return ((doublify(controller1) + doublify(controller2)).toString());
      case "-":
        return ((doublify(controller1) - doublify(controller2)).toString());
      case "*":
        return ((doublify(controller1) * doublify(controller2)).toString());
      case "/":
        return ((doublify(controller1) / doublify(controller2)).toString());
      case "^":
        return (pow(doublify(controller1), doublify(controller2)).toString());
      case "log":
        return ((log(doublify(controller1)) / log(doublify(controller2)))
            .toString());
      default:
        return ("Error");
    }
  }

  Widget customRadioButton(String text) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          operation = text;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          color: (operation == text) ? Colors.cyan[800] : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide.lerp(
              BorderSide(
                style: BorderStyle.solid,
                color: (operation == text)
                    ? Colors.cyanAccent[700]!
                    : Colors.black,
                width: 1.5,
              ),
              BorderSide(
                style: BorderStyle.solid,
                color: (operation == text)
                    ? Colors.cyanAccent[700]!
                    : Colors.black,
                width: 1.5,
              ),
              10.0))),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Container(
          padding: const EdgeInsets.all(40),
          child: Column(children: <Widget>[
            Center(
                child: Column(children: [
              Text('Value: ${mathify(input1Controller, input2Controller)}',
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                            text: mathify(input1Controller, input2Controller))).then((_){
                              ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(content: Text('Copied to clipboard'),));
                            }
                    );
                  },
                  child: const Icon(Icons.copy, size: 20)),
            ])),
            TextField(
              decoration:
                  const InputDecoration(labelText: "Enter your first number"),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              controller: input1Controller,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp('^-?[0-9]*[,.]{0,1}[0-9]*'))
              ], // Only numbers can be entered
              onChanged: (text) {
                setState(() {});
              },
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Enter your second number"),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp('^-?[0-9]*[,.]{0,1}[0-9]*'))
              ], // Only numbers can be entered
              controller: input2Controller,
              onChanged: (text) {
                setState(() {});
              },
            ),
            Wrap(
                
                alignment: WrapAlignment.center,
                spacing: 5,
                runSpacing: -6,
                children: <Widget>[
                  customRadioButton("+"),
                  customRadioButton("-"),
                  customRadioButton('*'),
                  customRadioButton('/'),
                  customRadioButton('^'),
                  customRadioButton('log'),
                ])
          ]
        )
      )
    );
  }
}
