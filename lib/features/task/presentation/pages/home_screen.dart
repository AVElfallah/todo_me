import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_me/core/theme/app_colors.dart';

import '../widgets/drawer_widget.dart';
import '../widgets/note_page_widget.dart';
import '../widgets/task_new_line_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  //[_pageFlipAcceleration] to controls the page fliping values in ui and make it changing
  //[_isClicked] to handle if widget is draged or not
  final ValueNotifier<double> _pageFlipAcceleration = ValueNotifier(0);
  bool _isClicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Todo Me'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBarColor,
        foregroundColor: Colors.white,
        elevation: 10,
      ),
      drawer: HomeCustomDrawer(),
      body: ValueListenableBuilder(
        valueListenable: _pageFlipAcceleration,
        builder:
            (_, flipValue, _) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onPanStart: (d) {
                    _isClicked = true;
                  },
                  onPanUpdate: (d) {
                    if (_isClicked) {
                      _pageFlipAcceleration.value =
                          d.localPosition.dy / 350 * pi;
                    }
                  },
                  onPanEnd: (d) {
                    if (_isClicked) {
                      var tempValue = (d.localPosition.dy / 350 * pi).round();
                      if (tempValue < 2) {
                        _pageFlipAcceleration.value = 0;
                      } else if (tempValue > 4) {
                        _pageFlipAcceleration.value = 0;
                      } else {
                        _pageFlipAcceleration.value = 11;
                      }
                      _isClicked = false;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: SvgPicture.asset(
                      'assets/svgs/note_pin.svg',
      
                      width: 500,
                      height: 70,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    NotePageWidget.withEndTaskContainer(),
                    GestureDetector(
                      onPanStart: (d) {
                        _isClicked = true;
                      },
                      onPanUpdate: (d) {
                        if (_isClicked) {
                          _pageFlipAcceleration.value =
                              d.localPosition.dy / 350 * pi;
                        }
                      },
                      onPanEnd: (d) {
                        if (_isClicked) {
                          var tempValue =
                              (d.localPosition.dy / 350 * pi).round();
                          if (tempValue < 2) {
                            _pageFlipAcceleration.value = 0;
                          } else if (tempValue > 4) {
                            _pageFlipAcceleration.value = 0;
                          } else {
                            _pageFlipAcceleration.value = 11;
                          }
                          _isClicked = false;
                        }
                      },
                      child: Transform(
                        origin: const Offset(0, 0),
                        transform:
                            Matrix4.identity()
                              ..setEntry(2, 3, 0.0002)
                              ..rotateX(_pageFlipAcceleration.value),
                        child: NotePageWidget(
                          isAnimated: true,
                          containerColor: Colors.white,
                          children: [
                            for (var i = 0; i < 1; i++) TaskNewLineWidget(
                              isNewTask: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      ),
    );
  }
}
