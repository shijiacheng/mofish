import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mofish',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  int _countdownTime = 0;
  double _currentProcess = 0;

  void _onExitApp() {
    exit(0);
  }

  @override
  void initState() {
    super.initState();
    startCountdownTimer();
  }

  /*
   * 实现倒计时
   */
  void startCountdownTimer() {
    const oneSec = Duration(seconds: 1);

    var callback = (timer) => {
          setState(() {
            if (_countdownTime > 999) {
              _currentProcess = 99;
              _timer.cancel();
            } else {
              _countdownTime += 1;
              _currentProcess = _countdownTime / 10;
            }
          })
        };

    _timer = Timer.periodic(oneSec, callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // 背景色
        backgroundColor: const Color.fromARGB(255, 40, 0, 29),
        appBar: null,
        // 主体布局采用一个层叠布局，水平居中
        body: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              // logo的部分在全局居中
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 给logo加入点击事件，双击可以退出app
                  GestureDetector(
                    onDoubleTap: () => _onExitApp(),
                    child: Center(
                      child: Image.asset(
                        'images/ututuu1.png',
                        width: 400,
                      ),
                    ),
                  ),
                  // loading动画
                  Container(
                    padding: const EdgeInsets.only(top: 40, bottom: 10),
                    child: LoadingAnimationWidget.hexagonDots(
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Text(
                    'Scanning disk files to ${_currentProcess.toString()}%',
                    style: const TextStyle(color: Colors.white70, fontSize: 24),
                  ),
                  Container(
                    height: 50,
                  )
                ],
              ),
            ),
            // 提示语布局在底部居中的位置
            const Positioned(
              bottom: 200,
              child: Text(
                'Please do not turn off the computer, this operation will take some time. Happy mofish!',
                style: TextStyle(color: Colors.white54, fontSize: 18),
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}
