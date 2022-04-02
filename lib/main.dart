import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kraken/kraken.dart';

KrakenJavaScriptChannel javaScriptChannel = KrakenJavaScriptChannel();

void main() {
  javaScriptChannel.onMethodCall = (String method, dynamic arguments) async {
    if (method == 'eventBus') {
      Completer completer = Completer<String>();
      print('eventBus: $arguments');
      await javaScriptChannel.invokeMethod('eventBus', arguments);
      completer.complete();
      return completer.future;
    }
  };
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  List<Map<String, dynamic>> pages = [
    {
      "name": "Kraken1",
      "icon": Icons.one_k,
      "bundleContent": '''
        kraken.methodChannel.addMethodCallHandler((method, args) => {
          if (method == 'eventBus') {
            console.log('A页面监听输出', args);
          }
        });
        const div = document.createElement("div");
        div.style.width = '100px';
        div.style.height = '100px';
        div.style.backgroundColor = 'red';
        div.appendChild(document.createTextNode("点击抛eventBus事件,值为aaa"));
        div.addEventListener('click', () => {
          kraken.methodChannel.invokeMethod('eventBus', 'aaa')
        })
        document.body.appendChild(div);
        ''',
    },
    {
      "name": "Kraken2",
      "icon": Icons.two_k,
      "bundleContent": '''
        kraken.methodChannel.addMethodCallHandler((method, args) => {
          if (method == 'eventBus') {
            console.log('B页面监听输出', args);
          }
        });
        const div = document.createElement("div");
        div.style.width = '100px';
        div.style.height = '100px';
        div.style.backgroundColor = 'green';
        div.appendChild(document.createTextNode("点击抛eventBus事件,值为bbb"));
        div.addEventListener('click', () => {
          kraken.methodChannel.invokeMethod('eventBus', 'bbb')
        })
        document.body.appendChild(div);
        ''',
    },
    {
      "name": "Kraken3",
      "icon": Icons.three_k,
      "bundleContent": '''
        kraken.methodChannel.addMethodCallHandler((method, args) => {
          if (method == 'eventBus') {
            console.log('C页面监听输出', args);
          }
        });
        const div = document.createElement("div");
        div.style.width = '100px';
        div.style.height = '100px';
        div.style.backgroundColor = 'blue';
        div.appendChild(document.createTextNode("点击抛eventBus事件,值为ccc"));
        div.addEventListener('click', () => {
          kraken.methodChannel.invokeMethod('eventBus', 'ccc')
        })
        document.body.appendChild(div);
        ''',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(pages[index]['name'])),
        body: IndexedStack(
          index: index,
          children: pages.map((page) {
            return Kraken(
              bundle: KrakenBundle.fromContent(page['bundleContent']),
              javaScriptChannel: javaScriptChannel,
            );
          }).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          items: pages.map((page) {
            return BottomNavigationBarItem(label: page['name'], icon: Icon(page['icon']));
          }).toList(),
          onTap: (int i) {
            setState(() {
              index = i;
            });
          },
        ),
      ),
    );
  }
}
