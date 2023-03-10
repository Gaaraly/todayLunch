import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const Color priColor = Color(0xffd7000f);
const Color secColor = Color(0xfff0c2a2);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          primaryColor: priColor),
      home: const MyHomePage(title: '今天中午吃什么?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const double _itemExtent = 40;
  int currentSelectedIndex = 0;
  int _counter = 0;
  bool isRocking = false;
  final List<String> meatsList = [
    '蛋炒饭',
    '饺滋滋',
    '奶茶',
    '面包',
    '今天不吃',
    '老街称盘',
    '衢州菜'
  ];
  final ScrollController _scrollController = ScrollController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  int _randomItem() {
    return Random().nextInt(meatsList.length);
  }

  void _scrollToTarget(int target) {
    _scrollController.animateTo(
      target * _itemExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double containerMaxHeight = screenHeight * 0.25;
    final double listPadding = (containerMaxHeight - _itemExtent) / 2;

    // 监听滚动事件
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      int selectedIndex = (offset / _itemExtent).round();
      setState(() {
        currentSelectedIndex = selectedIndex;
      });
    });

    Widget theList = ListView.builder(
      controller: _scrollController,
      itemExtent: _itemExtent,
      itemBuilder: (context, index) {
        String item = meatsList[index];
        return Column(
          children: [
            Center(
              child: Text(
                item,
                style: TextStyle(
                    height: _itemExtent / 20,
                    fontSize: 20,
                    color: index == currentSelectedIndex ? priColor : null),
              ),
            ),
          ],
        );
      },
      itemCount: meatsList.length,
      padding: EdgeInsets.only(top: listPadding, bottom: listPadding),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: priColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              // constraints: BoxConstraints(maxHeight: containerMaxHeight),
              height: containerMaxHeight,
              width: 200,
              child: Stack(
                children: [
                  theList,
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: _itemExtent,
                      width: 140,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: secColor,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: secColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // button GO
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _counter++;
                  isRocking = !isRocking;
                });
                int target = _randomItem();
                if (target == currentSelectedIndex) {
                  target = _randomItem();
                }
                _scrollToTarget(target);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(88, 40),
                foregroundColor: Colors.white,
                backgroundColor: priColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: Text(isRocking ? 'STOP' : 'GO',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: secColor,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
