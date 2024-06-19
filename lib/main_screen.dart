import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum Arrow { up, down, left, right }

class _MainScreenState extends State<MainScreen> {
  int speed = 1000;
  bool started = false;
  Timer? frame;
  int headIndex = 0;
  late int randomCell;
  Arrow currentArrow = Arrow.down;

  void _start() {
    setState(() {
      started = true;
    });
    frame = Timer.periodic(
      Duration(milliseconds: speed),
      (_) {
        switch (currentArrow) {
          case Arrow.down:
            headIndex = headIndex + 20;
            break;
          case Arrow.up:
            headIndex = headIndex - 20;
            break;
          case Arrow.left:
            headIndex--;
            break;
          case Arrow.right:
            headIndex++;
            break;
          default:
        }
        setState(() {});
        if ((headIndex < 20 ||
            headIndex % 20 == 0 ||
            headIndex > 460 ||
            headIndex % 20 == 19)) {
          _gameOver();
        }
        if (headIndex == randomCell) {
          var num = Random().nextInt(479);
          if ((num > 20 &&
              num % 20 != 0 &&
              num < 460 &&
              num % 20 != 19 &&
              started)) {
            randomCell = num;
            setState(() {});
            debugPrint('$randomCell');
          }
        }
      },
    );

    Future.delayed(const Duration(seconds: 5)).then(
      (_) {
        var num = Random().nextInt(479);
        if ((num > 20 &&
            num % 20 != 0 &&
            num < 460 &&
            num % 20 != 19 &&
            started)) {
          randomCell = num;
          setState(() {});
          debugPrint('$randomCell');
        }
      },
    );
  }

  void _gameOver() {
    started = false;
    frame?.cancel();
    setState(() {});
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
            height: 210,
            child: Column(
              children: [
                Text(
                  'Game Over',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size(150, 40))),
                  onPressed: () {
                    Navigator.pop(context);
                    _start();
                  },
                  child: const Text('Start Again'),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size(150, 40))),
                  onPressed: () {
                    Navigator.pop(context);
                    _stop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _stop() {
    started = false;
    randomCell = 0;
    frame?.cancel();
    headIndex = 250;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    headIndex = 250;
    randomCell = 0;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      appBar: AppBar(
        title: const Text('Snake Mesnake'),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.secondary,
        height: height - 200,
        child: Column(
          children: [
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 20,
                    childAspectRatio: 1 / 1,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1),
                children: List.generate(
                  480,
                  (i) => Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(2),
                        color: i == headIndex
                            ? Theme.of(context).primaryColor
                            : (i < 20 || i % 20 == 0 || i > 460 || i % 20 == 19)
                                ? Theme.of(context).colorScheme.onErrorContainer
                                : i == randomCell
                                    ? Colors.lightGreen
                                    : null),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ArrowBtn(
                      icon: const Icon(Icons.arrow_upward),
                      onTap: () {
                        setState(() {
                          currentArrow = Arrow.up;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ArrowBtn(
                      icon: const Icon(Icons.arrow_back),
                      onTap: () {
                        setState(() {
                          currentArrow = Arrow.left;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ArrowBtn(
                      icon: const Icon(Icons.arrow_downward),
                      onTap: () {
                        setState(() {
                          currentArrow = Arrow.down;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ArrowBtn(
                      icon: const Icon(Icons.arrow_forward),
                      onTap: () {
                        setState(() {
                          currentArrow = Arrow.right;
                        });
                      },
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: started ? _stop : _start,
        child: Text(
          started ? 'Stop' : 'Start',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ArrowBtn extends StatelessWidget {
  final Widget icon;
  final void Function() onTap;
  const ArrowBtn({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
