import 'package:flutter/material.dart';

void main() {
  runApp(const ShakewellApp());
}

class ShakewellApp extends StatelessWidget {
  const ShakewellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shakewell',
      theme: ThemeData(
        primarySwatch: Colors.amber,  // 金黄调酒主题
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String greeting = 'Hi, 调酒小白！今天想摇什么？';  // 个性化问候

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shakewell 🍸'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              greeting,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  greeting = '准备加冰摇晃！';
                });
              },
              child: const Text('开始调酒'),
            ),
          ],
        ),
      ),
    );
  }
}